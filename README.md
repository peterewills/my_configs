# Installing Configs

My general approach is to link the expected location of the configuration files
to this directory, which I assume is cloned into `~/.config/my_configs`.

### Bash profile

From this repo's root, do

```
ln -s ~/.config/my_configs/.bash_profile ~/.bash_profile
```

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

#### Notify Cell Magics

TODO

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

### Git

Do

```
ln -s ~/.config/my_configs/.gitignore_global ~/.gitignore_global
```

Also do the same for `.gitconfig`.

Since 2-factor authentication is set up, you'll need to generate a token instead
of using your github password.
