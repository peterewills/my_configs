# Installing Configs

My general approach is to link the expected location of the configuration files
to this directory, which I assume is cloned into `~/.config/my_configs`.

### Bash profile

From this repo's root, do

```
ln -s ~/.config/my_configs/.bash_profile ~/.bash_profile
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

Then, put your `.emacs` in place: `ln -s ./.emacs ~/.emacs`. This _should_ be
plug-and-play, save for getting Zenburn from github, which is outlined in the
`.emacs` file itself.

You will also need to install Fira Code if that's still the font in use.

For nano-emacs, you'll need to clone [this
repo](https://github.com/peterewills/nano-emacs) and make sure that it's in the right
place for your .emacs file; look for the call to `load-file`, which is what initializes
the nano-stuff. Install Roboto-Mono and Fira-Code fonts.

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

### pyenv

Install pyenv, and make sure that 3.7.8 is your default, but that **you have some 3.6.X
version available**. I think it's sidecar that needs it.

### jars

You should have both `presto-jdbc-0.219.jar` and `sf-presto-cli-318-executable.jar` in
your `~/jars` directory. Ask in #algo-help if you need new versions of these.


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
