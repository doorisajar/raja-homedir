# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$HOME/git/multi-git-status:$PATH
export PATH="/usr/local/sbin:$PATH"

# $PATH as of 2018-07:
# /Library/Frameworks/Python.framework/Versions/3.5/bin:/Library/TeX/texbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/TeX/texbin

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="pygmalion"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(aws osx)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git gitfast git-extras aws osx brew copyfile)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Configure virtualenv for python
# export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"

# WORKON_HOME=~/envs

# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# Enable Z for quick navigation
. `brew --prefix`/etc/profile.d/z.sh

# Add syntax highlighting plugin
source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# this file doesn't exist and yet tab completion seems to be working anyway?
# source /usr/bin/git/contrib/completion/git-completion.zsh

# open current git repo in GitLab
repo () {
    local remote=${1:-origin}
    local url=$(git config remote.$remote.url)
    echo $url
    local branch=`git_branch`
    zmodload zsh/regex
    if [[ $url -regex-match 'git@([^:]+):(.+)\.git$' ]]
    then
        local url2="https://$match[1]/$match[2]"
        if [[ $branch != 'HEAD' ]]
        then
            url2="${url2}/tree/${branch}"
        fi
        echo $url2
        open $url2
        return
    fi
    echo "Can't map remote URL '${url}' to web"
}

# get the changelog for the current repo
rchangelog () {
       echo "Version XX  " $(date)
       echo "---------------------------"
       git --no-pager changelog $1..
}
