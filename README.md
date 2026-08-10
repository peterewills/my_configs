# Installing Configs

My general approach is to link the expected location of the configuration files
to this directory.

This README covers **macOS** setup. For the Linux Mint (Cinnamon) machine, see
[`linux-mint/README.md`](linux-mint/README.md) - it reuses several of the files
described below (`.bash_profile`, `.bash_prompt`, `.emacs`, `.gitconfig`,
`.gitignore_global`, `.tmux.conf`) but has its own clone location and a handful of
OS-specific files (keyboard remapping, trackpad fix, Cinnamon tweaks) that live in
that subdirectory instead of the repo root.

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

The default would be to `brew install python@whatever` (currently `python@3.14`) and
then create aliases in your `.bash_profile`, e.g.

```
alias python='/opt/homebrew/bin/python3'
alias pip='/opt/homebrew/bin/pip3'
```

Homebrew's python is "externally managed" (PEP 668), so a bare `pip install` against it
fails with an `externally-managed-environment` error. Rather than overriding that with
`--break-system-packages`, dev tools live in a dedicated venv instead:

```
python3 -m venv ~/.venvs/tools
~/.venvs/tools/bin/pip install jupyter flake8 jedi autopep8 yapf
```

Then add the venv's `bin/` to `PATH` in `.bash_profile`:

```
export PATH="$HOME/.venvs/tools/bin:$PATH"
```

This makes `flake8`, `yapf`, `jupyter`, etc. available as shell commands, and `.emacs`
points `elpy-rpc-python-command` / `python-shell-interpreter` straight at
`~/.venvs/tools/bin/python3` so elpy uses the same environment.

### Bash profile

From this repo's root, do

```
ln -s ~/.config/my_configs/.bash_profile ~/.bash_profile
ln -s ~/.config/my_configs/.bash_prompt ~/.bash_prompt
```

`.bash_profile` also unconditionally sources two files that live outside this repo, so
new shells will error until both exist:

- `~/.tokens` - see "Tokens" below.
- `~/.git-completion.bash` - not part of this repo, fetched straight from git's own
  upstream:
  ```
  curl -fsSL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
  ```

### Tmux

`brew install tmux`, then put the tmux config in place:

```
ln -s ~/.config/my_configs/.tmux.conf ~/.tmux.conf
```

### Tokens

I store sensitive tokens and keys in `~/.tokens`, which `.bash_profile` sources
unconditionally - so it needs to exist even if empty, or new shells will error:

```
touch ~/.tokens
```

Historically it's just held the circle CI token. For a new machine, probably best to
re-generate these rather than copying old ones over.

### Terminal style

Go into terminal preferences, and select "Import" from the bottom gear thing of
the themes menu. You'll probably have to move `zenburn.terminal` to the desktop
to make it visible.

To allow yourself to delete a word at a time using `Ctrl-delete`, enter the
keyboard shortcut manually. The "Action" you want to link this to is
`\033\177`, which you get by doing `esc delete`.

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

For nano-emacs, you'll need to clone [this
repo](https://github.com/peterewills/nano-emacs) and make sure that it's in the right
place for your .emacs file; look for the call to `load-file`, which is what initializes
the nano-stuff.

Install Roboto-Mono and Fira-Code fonts (the default face is `"Fira Code Light"`,
see `.emacs`):

```
brew install --cask font-fira-code font-roboto-mono
```

elpy's Python backend (jedi, flake8, autopep8, yapf) runs out of the venv set up in the
Python section above - `elpy-rpc-python-command` in `.emacs` points straight at
`~/.venvs/tools/bin/python3`, so no extra elpy-specific setup is needed once that venv
exists.

### Git

Do

```
ln -s ~/.config/my_configs/.gitignore_global ~/.gitignore_global
ln -s ~/.config/my_configs/.gitconfig ~/.gitconfig
```

Since 2-factor authentication is set up, you'll need to generate a token instead
of using your github password.

`.gitconfig` requires git-lfs (the `[filter "lfs"]` block), so install it and register
the filters globally or git operations on LFS-tracked repos will fail:

```
brew install git-lfs
git lfs install
```

## Additional Apps to Install

- 1Password
- Rectangle for window management (macOS)


## Extra Stuff

### Keeb

I've included my QMK keyboard firmware JSON in here, as well. You can go to the [QMK
configurator](https://config.qmk.fm/#) and load it to play around.

### IPython Startup

Link the `ipython_startup` directory, as follows:

`ln -s ~/.config/my_configs/ipython_startup ~/.ipython/profile_default/startup`

#### Plot style

The `zenburn_plots.py` file implements the zenburn color theme in matplotlib plots (&
seaborn, if available). This makes it play nice with Emacs IPython Notebook.

## Linux Mint (Cinnamon)

See [`linux-mint/README.md`](linux-mint/README.md) for the Linux Mint machine setup -
keyboard remapping (keyd), the Cinnamon-specific tweaks, and how it reuses files from
this directory.
