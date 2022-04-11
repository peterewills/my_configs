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

# make enconding work nicely with python 3
export LS_ALL=en_US.utf-8
export LANG=en_US.utf-8

# Opens emacs in a separate window (so I have all my nice keybindings etc)
alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs "$@"'

# got tired of writing these out
alias jphtml='jupyter nbconvert --to html'
alias jpscript='jupyter nbconvert --to script'
alias ipdb='python -m ipdb -c continue'

list_versions () {
    # list the available versions of a python package. don't just do `pip install ==`
    # without a version number, because then it can install version 0.0 we assume that
    # packages won't have version 100.100.100.foobar available. If they do, this won't
    # work.
    pip install $1==100.100.100.foobar --use-deprecated=legacy-resolver
}

#############################
### ENVIRONMENT VARIABLES ###
#############################

export STITCHFIX_USER_EMAIL=peter.wills@stitchfix.com
export STITCHFIX_OWNER_ID=peter.wills
export SF_ENV=prod  # something about bumblebee... I dunno
export VAULT_ADDR=https://hvault.vertigo.stitchfix.com
export JYN_DEV_LOADER=true

# pip install --user puts stuff in this bin
export PATH="/Users/peterewills/.local/bin:$PATH"
# MacPorts Installer addition on 2019-08-28_at_11:41:08: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

# STFU terminal, I like bash
export BASH_SILENCE_DEPRECATION_WARNING=1

######################
### COMMAND PROMPT ###
######################

# # Git branch in prompt.
# TODO fix my prompt
# parse_git_branch() {
# 	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
# }
# # this doesn't show user or host, to do so add "\u@\h" to beginning\
# export PS1="\[\033[96m\]\W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "



# #################################
# ### SUPERCHARGED BASH HISTORY ###
# #################################

# TODO recover this functionality in zsh
# # https://metaredux.com/posts/2020/07/07/supercharge-your-bash-history.html

# # don't put duplicate lines or lines starting with space in the history.
# # See bash(1) for more options
# HISTCONTROL=ignoreboth

# # append to the history file, don't overwrite it
# shopt -s histappend
# # append and reload the history after each command
# PROMPT_COMMAND="history -a; history -n"

# # ignore certain commands from the history
# HISTIGNORE="ls:ll:cd:pwd:bg:fg:history"

# # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# HISTSIZE=100000
# HISTFILESIZE=10000000


# #############
# ### OTHER ###
# #############

# # pyenv initialization
# if command -v pyenv 1>/dev/null 2>&1; then
#   eval "$(pyenv init -)"
#   eval "$(pyenv virtualenv-init -)"
# fi

# get this file from
#
#  https://github.com/git/git/blob/master/contrib/completion/git-completion.zsh
# TODO get this running
# source ~/.git-completion.zsh
# Tokens we don't want to push to GitHub :facepalm:
source ~/.tokens
