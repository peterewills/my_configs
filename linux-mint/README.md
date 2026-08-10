# Linux Mint (Cinnamon) Setup

Setup for the Linux Mint machine (`peter-2015-mbp`, actual Apple keyboard hardware
running Linux Mint 22.3/Cinnamon on X11). Everything below assumes the repo is
cloned to `~/code/my_configs` (not `~/.config/my_configs` like the macOS
instructions in the [root README](../README.md)), so files in this directory are
found at `~/code/my_configs/linux-mint/...`.

### Reused from the base (macOS) setup

Several files aren't duplicated here - they're shared straight from the repo root,
same as on macOS. Follow the relevant sections of the [root README](../README.md),
just swapping `~/.config/my_configs` for `~/code/my_configs` in the `ln -s` commands:

- `.bash_profile` / `.bash_prompt` - the `emacs` shell function referenced below lives
  in `.bash_profile`.
- `.tokens` and `~/.git-completion.bash` - `.bash_profile` sources both unconditionally,
  same as on macOS.
- `.emacs` - see "[.emacs on Linux](#emacs-on-linux)" below for how it diverges here.
- `.gitconfig` / `.gitignore_global` and git-lfs.
- `.tmux.conf`.

### Keyboard remapping (keyd)

`setup-keyd-mint.sh` installs [keyd](https://github.com/rvaiya/keyd) (via the
`ppa:keyd-team/ppa` PPA, since it's not in Mint 22.3's default repos) and writes
`/etc/keyd/default.conf`. keyd operates below X11 at the evdev level, so it's
consistent across every app, including the terminal.

Run it (needs sudo, so run it yourself, not via Claude):

```
source ~/code/my_configs/linux-mint/setup-keyd-mint.sh
```

It's idempotent - re-run any time after editing the script to redeploy the config
and restart the `keyd` service. `sudo systemctl stop keyd` reverts everything
instantly if something's wrong.

What it sets up (see the script for the actual keyd syntax):

- Caps Lock -> Control (plain remap, works identically to the real Ctrl key)
- Ctrl+A / Ctrl+E -> beginning/end of line (plain cursor move, not select)
- Command (both sides; hid-apple reports these as Meta/Super on this hardware)
  -> aliased straight to Control, so Command+`<any key>` becomes Ctrl+`<any key>`
  automatically. This also means tapping Command alone no longer opens the
  Cinnamon menu (see below for the replacement), and Command+Left/Right does
  word-jump now (same as Ctrl+Left/Right) rather than home/end.
- Option (hid-apple reports this as Alt) -> Option+Left/Right for word-jump,
  Option+Backspace for delete-word. Otherwise left alone as plain Alt, so
  Alt+Tab, Alt+F4, Alt+F2, etc. all still work normally.

Ctrl+Left/Right (word-jump) and Ctrl+Backspace/Delete (delete-word) needed no
config at all - they're already the Linux/GTK default everywhere.

### Emacs pop-up window behavior (emacs --daemon)

To get Emacs to open as a separate window without blocking the terminal
(equivalent to what the macOS `.app` bundle gave for free), we run it as a
persistent daemon and connect to it with `emacsclient`:

```
systemctl --user enable --now emacs.service
```

This uses the `emacs.service` systemd user unit that ships with the `emacs-gtk`
package - nothing to track here, since it's stock. The `emacs` shell function in
`.bash_profile` (reused from the root of the repo) calls `emacsclient`, and picks
`-c` (create a window) vs. no flag (reuse the existing one, opening the file as a
new buffer) depending on whether a real GUI frame already exists, so `emacs <file>`
never spawns duplicate windows.

### Ctrl+Delete in terminal (.inputrc)

```
ln -s ~/code/my_configs/linux-mint/.inputrc ~/.inputrc
```

GTK/GUI apps bind Ctrl+Delete (delete word forward) natively, but `readline`
(what bash/terminal use) doesn't by default, even though terminals do send an
escape sequence for it. This binds `\e[3;5~` to `kill-word`. Includes
`$include /etc/inputrc` at the top - required, otherwise creating `~/.inputrc`
silently drops all of readline's normal default bindings.

### Ctrl+Space opens the Cinnamon menu (Spotlight-style)

```
ln -s ~/code/my_configs/linux-mint/cinnamon-menu-applet-settings.json \
  ~/.config/cinnamon/spices/menu@cinnamon.org/0.json
```

Cinnamon's Menu applet has its own hotkey setting (`overlay-key`, in this JSON
file) separate from any gsettings schema - it used to fire on a bare tap of
Super, but that broke once Command got aliased to Control above (Command no
longer sends a real Super keypress). This is set to `<Control>space` instead.

Also had to strip `Control+space` out of `org.freedesktop.ibus.general.hotkey
trigger` (`gsettings set org.freedesktop.ibus.general.hotkey trigger
"['Zenkaku_Hankaku', 'Alt+Kanji', 'Alt+grave', 'Hangul', 'Alt+Release+Alt_R']"`)
since `ibus-daemon` was grabbing Ctrl+Space first as its input-method-switch
trigger, before Cinnamon ever saw it. Not captured as a file anywhere since it's
a dconf key, not a config file - just re-run that command if it ever resets.

**Caveat:** Cinnamon rewrites this JSON file whenever *any* menu applet setting
changes (icon, sidebar options, etc.), not just ones you touch intentionally -
so expect unrelated diffs in this file over time. There's also a small risk
that if Cinnamon ever does an atomic write (temp file + rename) instead of
an in-place edit, it'll silently replace the symlink with a plain file and
stop tracking - if the repo copy ever looks stale, just re-run the `ln -s`
above after re-`cp`-ing the current live file back in.

### Trackpad scroll speed

The Apple internal trackpad (`bcm5974` driver) scrolls too fast by default under
libinput. `fix-trackpad-scroll-speed.sh` slows it down by raising the "libinput
Scrolling Pixel Distance" property. Set up as an autostart entry so it applies
each login:

```
ln -s ~/code/my_configs/linux-mint/trackpad-scroll-speed.desktop \
  ~/.config/autostart/trackpad-scroll-speed.desktop
```

### .emacs on Linux

Same symlink as the macOS instructions (`ln -s ~/code/my_configs/.emacs
~/.emacs`) - `.emacs` itself is reused from the repo root, not duplicated here.
Note the file has diverged for this machine: mac-only paths (homebrew,
`/Users/...`, treesit grammar path, org-agenda-files) were stripped out,
`mac-command-modifier` was removed (irrelevant on Linux, and superseded by
the keyd Command->Control alias above), and the default font height was dropped
from 145 to 100 (14.5pt felt huge on this machine). elpy's Python paths point at
`/usr/bin/python3` for now, but elpy itself isn't functional yet - this machine
hasn't had a real Python environment (pip, jedi, flake8, etc.) set up.
