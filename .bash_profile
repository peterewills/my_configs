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

# we have flake8 installed in a special virtual environment, so that it can be used
# across all venvs. mostly this is just for use in emacs, so this alias probably won't
# really get used much, but I'm adding it here just in case.
alias flake8='/Users/peterewills/.flake8_venv/bin/flake8'

# Quick way to run things via aws-vault
alias awsv='aws-vault exec prod-eng -- aws'

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
export PATH="/Users/peterewills/.local/bin:$PATH"
# MacPorts Installer addition on 2019-08-28_at_11:41:08: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"


# STFU terminal, I like bash
export BASH_SILENCE_DEPRECATION_WARNING=1
export VIRTUAL_ENV_DISABLE_PROMPT=1

######################
### COMMAND PROMPT ###
######################

# Git branch in prompt.
parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
# this doesn't show user or host, to do so add "\u@\h" to beginning\
export PS1="\[\033[96m\]\W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "



# #################################
# ### SUPERCHARGED BASH HISTORY ###
# #################################

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


# #############
# ### OTHER ###
# #############

# get this file from
#
#  https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
source ~/.git-completion.bash
# Tokens we don't want to push to GitHub :facepalm:
source ~/.tokens


# define an env var for the path to source, our monorepo
export SOURCE=$HOME/code/source
# a bunch of abnormal-specific bash tooling
. $SOURCE/tools/dev/common_bash_includes

# activate the virtual environment defined in source whenever we start up a shell
export VENV="$SOURCE/.venv"
source "$VENV/bin/activate"

# see https://www.logcg.com/en/archives/3548.htmlq
export CPATH="/opt/homebrew/include/"
export HDF5_DIR=/opt/homebrew/

alias adhoc_build='aws-vault exec prod-eng -- python $SOURCE/src/py/abnormal/tools/rescore_tools/spark_rt_rescore.py build --identifier pwills --override_existing_deployment'
alias adhoc_end='aws-vault exec prod-eng -- python $SOURCE/src/py/abnormal/tools/rescore_tools/spark_rt_rescore.py end --identifier pwills'
alias adhoc_score_1s='aws-vault exec prod-eng -- python $SOURCE/src/py/abnormal/tools/rescore_tools/rt_rescore.py score pwills --start_time "2022-04-01 04:00:00" --interval 1S'

export ABNORMAL_USER=pwills

# tfenv use 0.12.31
