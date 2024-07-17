# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# path prepend for Homebrew
PATH="/usr/local/bin:/usr/local/sbin:$PATH"

if ! which brew > /dev/null 2>&1; then
    BREW=false
else
    BREW=true
fi

if uname -r | grep -q 'WSL' ; then
    # Fix for CUDA library detection issue on WSL
    # See: https://github.com/microsoft/WSL/issues/8587
    export LD_LIBRARY_PATH=/usr/lib/wsl/lib:$LD_LIBRARY_PATH
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

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
# optional other plugins by platform/environment: macos, aws, gcloud, azure
if [[ $BREW == true ]]; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    plugins=(aws brew copyfile colored-man-pages git gitfast git-extras ssh-agent z)
elif [[ $BREW == false ]]; then
    source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source $ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    plugins=(aws copyfile colored-man-pages git gitfast git-extras ssh-agent z)
fi

# ssh-agent setup
zstyle :omz:plugins:ssh-agent agent-forwarding on

zstyle :omz:plugins:ssh-agent identities github

source $ZSH/oh-my-zsh.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
if [[ -d "$HOME/.zsh_profile" ]]; then
    for f in $HOME/.zsh_profile/*.sh; do source $f; done
fi

# WSL starts shell in the wrong place
if [[ "$(pwd)" == "/mnt/c/Users/Raja/" ]]; then
    cd ~
fi
