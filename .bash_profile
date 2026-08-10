############################
### PETER'S BASH PROFILE ###
############################

# Disable bracketed mode - prevent 00~ and 01~ from surrounding pasted text
printf '\e[?2004l'

###############
### ALIASES ###
###############

# Easy use
alias cdu='cd ..'
alias cdb='cd -'
alias ll='ls -alFh'

# the true location of python 3.14 as installed by brew
alias python='/opt/homebrew/bin/python3'
alias pip='/opt/homebrew/bin/pip3'

# dev tools venv (jupyter, flake8, jedi, autopep8, yapf) - see README "Python" section.
# elpy in .emacs points straight at this venv's interpreter; this just puts its
# CLI tools (flake8, yapf, jupyter, ...) on PATH for shell use too.
export PATH="$HOME/.venvs/tools/bin:$PATH"

# make enconding work nicely with python 3
export LS_ALL=en_US.utf-8
export LANG=en_US.utf-8

# Opens files in the persistent emacs --daemon (see emacs.service, enabled via
# systemctl --user). Reuses the existing window as a new buffer if one's
# already open, rather than spawning a new one; only creates a new window if
# none exists yet.
emacs() {
  if [ "$(emacsclient -e '(seq-some (function window-system) (frame-list))' 2>/dev/null)" != "nil" ]; then
    emacsclient -n -a "" "$@"
  else
    emacsclient -n -c -a "" "$@"
  fi
}

alias jupyter='python -m jupyter'
alias poetry='python -m poetry'
alias prun='poetry run'

# got tired of writing these out
alias jphtml='jupyter nbconvert --to html'
alias jpscript='jupyter nbconvert --to script'
alias ipdb='python -m ipdb -c continue'

export JUPYTER_PATH=/opt/homebrew/share/jupyter

alias awsclaude='CLAUDE_CODE_USE_BEDROCK=1 ANTHROPIC_MODEL=us.anthropic.claude-sonnet-4-20250514-v1:0 claude'
alias claude='~/.local/bin/claude'

# dangling homebrew link that needs to be overwritten
alias docker='/usr/local/bin/docker'

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

activate-venv () {
    source ~/code/venvs/$1/bin/activate
}

# Use this alias for native-install claude code... when that happens
# alias claude="~/.local/bin/claude"

# activate-venv sandbox

#############################
### ENVIRONMENT VARIABLES ###
#############################

# pip install --user puts stuff in this bin
# export PATH="/Users/peter.wills@equipmentshare.com/.local/bin:$PATH"
# MacPorts Installer addition on 2019-08-28_at_11:41:08: adding an appropriate PATH variable for use with MacPorts.
# export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# # Add python3 to path, since I'm aliasing python to python3
# export PATH="/Users/peterwills/Library/Python/3.9/bin:$PATH"

# export JUPYTER_PATH=/opt/homebrew/share/jupyter
# export JUPYTER_CONFIG_PATH=/opt/homebrew/etc/jupyter

# export PYTHONPATH=$PYTHONPATH:/opt/homebrew/lib/python3.11/site-packages
# pip install --user and native-install claude code live here
export PATH="$HOME/.local/bin:$PATH"
export PATH=$PATH:/opt/homebrew/bin

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

export DEV_ENV=true

########################
# EQUIPMENTSHARE STUFF #
########################

# the original pAuth includes poetry configuration. I'm not using this ATM, so I removed it.
alias pAuth='export CODEARTIFACT_TOKEN=$(aws codeartifact get-authorization-token --domain equipmentshare --domain-owner 696398453447 --query authorizationToken --output text) && python -m poetry config http-basic.codeartifact-prod aws $CODEARTIFACT_TOKEN && python -m poetry config http-basic.codeartifact-prod aws $CODEARTIFACT_TOKEN && aws codeartifact login --tool pip --repository prod --domain equipmentshare --domain-owner 696398453447'
alias pAuthDev='export CODEARTIFACT_TOKEN=$(aws codeartifact get-authorization-token --domain equipmentshare --domain-owner 696398453447 --query authorizationToken --output text) && python -m poetry config http-basic.codeartifact-dev aws $CODEARTIFACT_TOKEN && python -m poetry config http-basic.codeartifact-dev aws $CODEARTIFACT_TOKEN && aws codeartifact login --tool pip --repository dev --domain equipmentshare --domain-owner 696398453447'
alias ecrLogin='aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 696398453447.dkr.ecr.us-west-2.amazonaws.com'
alias sql-formatter='npx sql-formatter'
alias docker_build_with_aws='docker build --build-arg CODEARTIFACT_TOKEN=$(aws codeartifact get-authorization-token --domain equipmentshare --domain-owner 696398453447 --query authorizationToken --output text)'

# Build docker image with AWS auth, using current repo name as tag
docker_build_repo() {
    local repo_name=$(basename $(git rev-parse --show-toplevel 2>/dev/null) 2>/dev/null)
    if [ -z "$repo_name" ]; then
        echo "Error: Not in a git repository"
        return 1
    fi
    docker build \
        --build-arg CODEARTIFACT_TOKEN=$(aws codeartifact get-authorization-token --domain equipmentshare --domain-owner 696398453447 --query authorizationToken --output text) \
        --platform linux/amd64 \
        -t "$repo_name" \
        "$@"
}

alias cleanup_branches='source ~/code/scripts/cleanup-branches.sh'

# Run poetry API server with debug logging teed to /tmp/<repo>-api.log
debug-api () {
    local repo_root
    repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [ -z "$repo_root" ]; then
        echo "Error: not in a git repository"
        return 1
    fi
    if [ ! -f "$repo_root/setup-environment.sh" ]; then
        echo "Error: no setup-environment.sh at repo root ($repo_root)"
        return 1
    fi
    local repo_name=$(basename "$repo_root")
    local logfile="/tmp/${repo_name}-api.log"
    rm -f "$logfile"
    cd "$repo_root" && source setup-environment.sh && LOG_LEVEL=DEBUG poetry run api 2>&1 | tee "$logfile"
}

# Snowflake query CLI
# Mirrored as a function in .zshrc so Claude Code can use it (aliases don't work in non-interactive shells)
alias query-snowflake='poetry -C ~/code/ai-platform/ds-tools run python ~/code/ai-platform/ds-tools/scripts/query.py'


######################
### COMMAND PROMPT ###
######################

# abstracted out into its own file, found on the interwebs
source ~/.bash_prompt

#############
### OTHER ###
#############

# get this file from
#
#  https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
source ~/.git-completion.bash

# Tokens we don't want to push to GitHub :facepalm:
source ~/.tokens
