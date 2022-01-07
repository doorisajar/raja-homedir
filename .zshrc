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

# Set name of the theme to load
ZSH_THEME="pygmalion"

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 13

# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Note that zsh-syntax-highlighting must be the last plugin sourced.
plugins=(aws brew copyfile colored-man-pages git gitfast git-extras macos ssh-agent z zsh-autosuggestions zsh-syntax-highlighting)

# ssh-agent setup
zstyle :omz:plugins:ssh-agent agent-forwarding on

zstyle :omz:plugins:ssh-agent identities github

source $ZSH/oh-my-zsh.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

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
