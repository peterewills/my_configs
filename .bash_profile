############################
### PETER'S BASH PROFILE ###
############################

###############
### ALIASES ###
###############

# Easy use
alias cdu='cd ..'
alias cdb='cd -'
alias ll='ls -alFh'

# the true location of python 3.11 as installed by brew
# NOTE: I just added symlinks in /usr/local/bin instead
# alias python='/opt/homebrew/bin/python3'
# alias pip='/opt/homebrew/bin/pip3'

# make enconding work nicely with python 3
export LS_ALL=en_US.utf-8
export LANG=en_US.utf-8

# Opens emacs in a separate window (so I have all my nice keybindings etc)
alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs "$@"'

# got tired of writing these out
alias jphtml='jupyter nbconvert --to html'
alias jpscript='jupyter nbconvert --to script'
alias ipdb='python -m ipdb -c continue'

# we have flake8 installed in a special virtual environment, so that it can be used
# across all venvs. mostly this is just for use in emacs, so this alias probably won't
# really get used much, but I'm adding it here just in case.
alias flake8='/Users/peterewills/.flake8_venv/bin/flake8'

list_versions () {
    # list the available versions of a python package. don't just do `pip install ==`
    # without a version number, because then it can install version 0.0 we assume that
    # packages won't have version 100.100.100.foobar available. If they do, this won't
    # work.
    pip install $1==100.100.100.foobar --use-deprecated=legacy-resolver
}

# add brew to path
if [[ -x /opt/homebrew/bin/brew ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

#############################
### ENVIRONMENT VARIABLES ###
#############################

# pip install --user puts stuff in this bin
export PATH="/Users/peter.wills@equipmentshare.com/.local/bin:$PATH"
# MacPorts Installer addition on 2019-08-28_at_11:41:08: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# # Add python3 to path, since I'm aliasing python to python3
# export PATH="/Users/peterwills/Library/Python/3.9/bin:$PATH"


# STFU terminal, I like bash
export BASH_SILENCE_DEPRECATION_WARNING=1
export VIRTUAL_ENV_DISABLE_PROMPT=1

#################################
### SUPERCHARGED BASH HISTORY ###
#################################

# https://metaredux.com/posts/2020/07/07/supercharge-your-bash-history.html

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
# append and reload the history after each command
PROMPT_COMMAND="history -a; history -n"

# ignore certain commands from the history
HISTIGNORE="ls:ll:cd:pwd:bg:fg:history"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=10000000

########################
# EQUIPMENTSHARE STUFF #
########################

# Note: first go to https://dev-portal.internal.equipmentshare.com/saml, and get your
# AWS creds. Copy them into your terminal; then you should be able to run pAuth.

# the original pAuth includes poetry configuration. I'm not using this ATM, so I removed it.
alias pAuth='export CODEARTIFACT_TOKEN=$(aws codeartifact get-authorization-token --domain equipmentshare --domain-owner 696398453447 --query authorizationToken --output text) && poetry config http-basic.codeartifact-dev aws $CODEARTIFACT_TOKEN && poetry config http-basic.codeartifact-prod aws $CODEARTIFACT_TOKEN && aws codeartifact login --tool pip --repository dev --domain equipmentshare --domain-owner 696398453447'

#############
### OTHER ###
#############

# get this file from
#
#  https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
source ~/.git-completion.bash
# Tokens we don't want to push to GitHub :facepalm:
source ~/.tokens

# start up our "default" virtualenv
source ~/code/sandbox/bin/activate


######################
### COMMAND PROMPT ###
######################

# abstracted out into its own file, found on the interwebs
source ~/.bash_prompt

# added by rustup installer
. "$HOME/.cargo/env"
