# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# path prepend for Homebrew
PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="/Users/rdoake/.oh-my-zsh"

# pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="pygmalion"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

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
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

# Note that zsh-syntax-highlighting must be the last plugin sourced.
plugins=(git gitfast git-extras aws osx brew copyfile z ssh-agent zsh-autosuggestions zsh-syntax-highlighting)

# ssh-agent setup
zstyle :omz:plugins:ssh-agent agent-forwarding on

zstyle :omz:plugins:ssh-agent identities github aws_github gitlab aws_gitlab cweos id_rsa

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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# open current git repo origin in browser, if possible. 
# works for git@ and https:// URLs. 
repo () {
    local remote=${1:-origin}
    local url=$(git config remote.$remote.url)
    echo "remote is $url"
    local branch=`git rev-parse --abbrev-ref HEAD | tr -d '\n'`
    zmodload zsh/regex
    if [[ $url -regex-match 'git@([^:]+):(.+)\.git$' ]]
    then
        local url2="https://$match[1]/$match[2]"
    elif [[ $url -regex-match 'https:\/\/(.+)\.git$' ]]
    then
        local url2="https://$match[1]"
    fi
    if [[ $branch != 'HEAD' ]]
    then
        url2="${url2}/tree/${branch}"
    fi
    echo "opening $url2"
    open $url2
    return
    echo "Can't map remote URL '${url}' to web"
}

# get the changelog for the current repo
rchangelog () {
       echo "Version XX  " $(date)
       echo "---------------------------"
       git --no-pager changelog $1..
}

# open an R project in RStudio
rstudio () {
  if [ -z "$1" ] ; then
    dir="."
  else
    dir="$1"
  fi
  cmd="proj <- list.files('$dir', pattern = '*.Rproj$', full.names = TRUE); if (length(proj) > 0) { system(paste('open -na Rstudio', proj[1])) } else { cat('No .Rproj file found in directory.\n') };"
  Rscript -e $cmd
}

# move config and current git repo into `container`
docker-populate() {
    local container=$1

    echo "Copying credentials into container"
    docker cp ~/.netrc $container:/root/
    docker cp ~/.ssh $container:/root/
    docker exec $container chown -R root /root/.netrc /root/.ssh
    docker exec $container chmod -R 400 /root/.netrc /root/.ssh

    local repo
    repo=$(git config --local --get remote.origin.url 2>/dev/null)
    if [[ $? -eq 0 ]]
    then
        echo "Cloning $repo into container"
        docker exec $container git clone "$repo" /tmp/repo
    else
        echo "Not in a git repo, skipping clone"
    fi
}
