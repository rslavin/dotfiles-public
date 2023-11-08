# HOSTS

# ALIASES

# ENV VARIABLES
export VISUAL=vim
export PATH=$HOME/bin:/bin:/usr/local/bin:$PATH


# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# ZSH OPTIONS
# Note: check ~/.oh-my-zsh/templates/zshrc.zsh-template periodically for new options

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="af-magic-dynamic"

# truncates parent directories to single letter (slow)
# requires shrink-path plugin and af-magic-dynamic theme (rslavin)
# https://github.com/rslavin/af-magic-dynamic
#ENABLE_SHRINK_PROMPT="true" 

# Sets how much whitespace (in characters) the prompt must reserve for 
# your commands. The directory path shortens to accomodate
# this number. Defaults to 60.
# MIN_PROMPT_WHITESPACE=120


# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
#DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
#HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git shrink-path)

# by default, zsh produces an error and immediately stops when a glob does not match
# this disables that
setopt nonomatch

source $ZSH/oh-my-zsh.sh

# SSH Agent
# export SSH_KEY_PATH="~/.ssh/dsa_id"
#SSH_ENV=$HOME/.ssh/environment

# start the ssh-agent
function start_agent {
    echo "Initializing new SSH agent..."
    # spawn ssh-agent
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add
}
   
#if [ -f "${SSH_ENV}" ]; then
#     . "${SSH_ENV}" > /dev/null
#     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
#        start_agent;
#    }
#else
#    start_agent;
#fi

# aliases for native python venv
function mkvenv {
    
    if [ -z "$1" ]; then
        echo "Please provide a name for the virtual environment."
        return 1
    fi
    
    target_path="${VENV_PATH}/$1"
    
    python3 -m venv "$target_path"
    
    if [ $? -eq 0 ]; then
        echo "Virtual environment '$1' created."
    else
        echo "Failed to create virtual environment."
    fi

    workon "$1"
}

function workon {
    if [ -z "$1" ]; then
        echo "Please specify which virtual environment to activate."
        return 1
    fi
    source "${VENV_PATH}/$1/bin/activate"
}

function rmvenv {
    if [ -n "$1" ]; then
        target_venv="${VENV_PATH}/$1"
        if [ -d "$target_venv" ]; then
            rm -rf "$target_venv"
            if [ "$VIRTUAL_ENV" == "$target_venv" ]; then
                deactivate
            fi
            echo "Removed '$target_venv'"
        else
            echo "'$target_venv' does not exist."
        fi
    elif [ -n "$VIRTUAL_ENV" ]; then
        deactivate
        rm -rf "$VIRTUAL_ENV"
        echo "Removed '$VIRTUAL_ENV'"
    else
        echo "Not in a virtual environment and no environment specified. Nothing to remove."
    fi
}

alias lsvenv="ls $VENV_PATH"
# `deactivate` works natively
