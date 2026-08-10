#!/usr/bin/env bash
# Installs and configures keyd on Linux Mint (Cinnamon/X11) to get emacs/mac-like
# keybindings: Caps Lock -> Ctrl, Ctrl+E -> end of line, Alt acting like Mac Cmd
# (proxies to Ctrl+<key> shortcuts, Alt+Left/Right -> Home/End), and Super acting
# like Mac Option (word-jump, delete-word). See conversation with Claude for the
# reasoning behind the physical-key-position mapping.
#
# Usage: source this file (or run it directly) and follow the sudo prompts.
#   $ source setup-keyd-mint.sh
# Safe to re-run; it just overwrites the config and restarts the service.

sudo add-apt-repository -y ppa:keyd-team/ppa
sudo apt update
sudo apt install -y keyd

sudo tee /etc/keyd/default.conf > /dev/null <<'EOF'
[ids]
*

[main]
capslock = leftcontrol
# Physical Command key -> hid-apple reports these as Meta/Super. Alias straight
# to Control so Command+<key> becomes Ctrl+<key> for everything, automatically.
leftmeta = leftcontrol
rightmeta = leftcontrol

[control:C]
a = home
e = end

# Physical Option key -> hid-apple reports this as Alt (word-jump, delete-word)
[alt:A]
left = macro(C-left)
right = macro(C-right)
backspace = macro(C-backspace)
EOF

sudo systemctl enable --now keyd
sudo systemctl restart keyd

echo "keyd installed and running. Test bindings now; 'sudo systemctl stop keyd' reverts instantly if something's off."
