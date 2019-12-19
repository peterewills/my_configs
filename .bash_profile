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
alias run_compare_backfills_notebook='python /Users/peterwills/code/stitchfix/jyn-backtest/scripts/run_compare_backfills_notebook.py'

#############################
### ENVIRONMENT VARIABLES ###
#############################

export STITCHFIX_USER_EMAIL=peter.wills@stitchfix.com
export VAULT_ADDR=https://hvault.vertigo.stitchfix.com

# pip install --user puts stuff in this bin
export PATH="/Users/peterwills/.local/bin:$PATH"

######################
### COMMAND PROMPT ###
######################

# Git branch in prompt.
parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
# this doesn't show user or host, to do so add "\u@\h" to beginning\
export PS1="\[\033[96m\]\W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "


#############
### OTHER ###
#############

# pyenv initialization                                                                                                                                                                                                                                                       
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# get this file from
#
#  https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
source ~/.git-completion.bash

##
# Your previous /Users/peterwills/.bash_profile file was backed up as /Users/peterwills/.bash_profile.macports-saved_2019-08-28_at_11:41:08
##

# MacPorts Installer addition on 2019-08-28_at_11:41:08: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

