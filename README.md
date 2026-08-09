# Installing Configs

My general approach is to link the expected location of the configuration files
to this directory.

### Get the repo

Clone it into `~/.config/my_configs`:

```
cd ~
mkdir .config
cd .config
git clone https://github.com/peterewills/my_configs.git
```

You may have to install xcode - even if it prompts you at first, you might have to do it
again via `xcode-select --install`.

### Homebrew

Install homebrew, as per the instructions on their website.


### Python

The default would be to `brew install python@whatever` and then create aliases in your
`.bash_profile`, e.g.

```
alias python='/opt/homebrew/bin/python3'
alias pip='/opt/homebrew/bin/pip3'
```

Then do

```
pip install jupyter flake8 jedi autopep8 yapf
```

### Bash profile

From this repo's root, do

```
ln -s ~/.config/my_configs/.bash_profile ~/.bash_profile
```

### Tmux

`brew install tmux`, then put the tmux config in place:

```
ln -s ~/.config/my_configs/.tmux.conf ~/.tmux.conf
```

### Tokens

I store sensitive tokens and keys in `~/.tokens`. Right now it's just the circle CI
token. For a new machine, probably best to re-generate these.

### Terminal style

Go into terminal preferences, and select "Import" from the bottom gear thing of
the themes menu. You'll probably have to move `zenburn.terminal` to the desktop
to make it visible.

To allow yourself to delete a word at a time using `Ctrl-delete`, enter the
keyboard shortcut manually. The "Action" you want to link this to is
`\033\177`, which you get by doing `esc delete`.

### IPython Startup

Link the `ipython_startup` directory, as follows:

`ln -s ~/.config/my_configs/ipython_startup ~/.ipython/profile_default/startup`

#### Plot style

The `zenburn_plots.py` file implements the zenburn color theme in matplotlib plots (&
seaborn, if available). This makes it play nice with Emacs IPython Notebook.

I never got `zenburn.mplstyle` to work properly. I'll leave it here for now.

### Default Keybindings

These are nice - get emacs-like text motions in (some) macOS apps, like
Messages, Slack, etc. Do

```
mkdir ~/Library/KeyBindings
ln ~/.config/my_configs/DefaultKeyBinding.dict ~/Library/KeyBindings/
```

This **can't** be a soft-link; if it is it won't get seen by macOS. Also, make
sure to go to System Preferences and set your caps lock key to control. Also
also, remove all the system-predefined shortcuts involving control; they're all
in System Preferences under "Mission Control". These override application keys
if they're active.

### Emacs

Install the [universal emacs OSX binaries](https://emacsformacosx.com/); this
will allow you to put the app on the dock, so it's more app-y and less
command-utility-y.

Do this after you set up your keybindings, since then you'll have the meta key
set to the apple key as you're used to.

Then, put your `.emacs` in place: `ln -s ~/.config/my_configs/.emacs ~/.emacs`. This _should_ be
plug-and-play, save for getting Zenburn from github, which is outlined in the
`.emacs` file itself.

You will also need to install Fira Code if that's still the font in use.

For nano-emacs, you'll need to clone [this
repo](https://github.com/peterewills/nano-emacs) and make sure that it's in the right
place for your .emacs file; look for the call to `load-file`, which is what initializes
the nano-stuff.

Install Roboto-Mono and Fira-Code fonts.

### Git

Do

```
ln -s ~/.config/my_configs/.gitignore_global ~/.gitignore_global
ln -s ~/.config/my_configs/.gitconfig ~/.gitconfig
```

Since 2-factor authentication is set up, you'll need to generate a token instead
of using your github password.

### Keeb

I've included my QMK keyboard firmware JSON in here, as well. You can go to the [QMK
configurator](https://config.qmk.fm/#) and load it to play around.

### Other Stuff

I use dropbox to back up my org files. I use google drive to back up my notebooks
directory. Why do I use different clients for these? I'm not really sure. Maybe I could
use the same for both.

I've included a pip-freeze just in case, but using most recent versions of things should
usually work. This is as-of 1/5/2021, and probably will be out-of-date soon.

I use SizeUp for window management. I set Fn-Ctrl-Shift-{Up, Down, Left, Right, M} to
move or full-screen (M) the window. This keybinding is set up to play nicely with my
ergonomic keyboard.

1Password is for password management.

## Linux Mint (Cinnamon)

Setup for the Linux Mint machine (`peter-2015-mbp`, actual Apple keyboard hardware
running Linux Mint 22.3/Cinnamon on X11). Everything below assumes the repo is
cloned to `~/code/my_configs` (not `~/.config/my_configs` like the macOS
instructions above).

### Keyboard remapping (keyd)

`setup-keyd-mint.sh` installs [keyd](https://github.com/rvaiya/keyd) (via the
`ppa:keyd-team/ppa` PPA, since it's not in Mint 22.3's default repos) and writes
`/etc/keyd/default.conf`. keyd operates below X11 at the evdev level, so it's
consistent across every app, including the terminal.

Run it (needs sudo, so run it yourself, not via Claude):

```
source ~/code/my_configs/setup-keyd-mint.sh
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
`.bash_profile` calls `emacsclient`, and picks `-c` (create a window) vs. no
flag (reuse the existing one, opening the file as a new buffer) depending on
whether a real GUI frame already exists, so `emacs <file>` never spawns
duplicate windows.

### Ctrl+Delete in terminal (.inputrc)

```
ln -s ~/code/my_configs/.inputrc ~/.inputrc
```

GTK/GUI apps bind Ctrl+Delete (delete word forward) natively, but `readline`
(what bash/terminal use) doesn't by default, even though terminals do send an
escape sequence for it. This binds `\e[3;5~` to `kill-word`. Includes
`$include /etc/inputrc` at the top - required, otherwise creating `~/.inputrc`
silently drops all of readline's normal default bindings.

### Ctrl+Space opens the Cinnamon menu (Spotlight-style)

```
ln -s ~/code/my_configs/cinnamon-menu-applet-settings.json \
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
ln -s ~/code/my_configs/trackpad-scroll-speed.desktop \
  ~/.config/autostart/trackpad-scroll-speed.desktop
```

### .emacs on Linux

Same symlink as the macOS instructions (`ln -s ~/code/my_configs/.emacs
~/.emacs`), but note the file has diverged for this machine: mac-only paths
(homebrew, `/Users/...`, treesit grammar path, org-agenda-files) were stripped
out, `mac-command-modifier` was removed (irrelevant on Linux, and superseded by
the keyd Command->Control alias above), and the default font height was dropped
from 145 to 100 (14.5pt felt huge on this machine). elpy's Python paths point at
`/usr/bin/python3` for now, but elpy itself isn't functional yet - this machine
hasn't had a real Python environment (pip, jedi, flake8, etc.) set up.
