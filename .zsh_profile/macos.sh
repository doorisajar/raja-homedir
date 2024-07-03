unameOut="$(uname -s)"

if [[ $unameOut == "Darwin" ]]; then

    alias showdots='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
    alias hidedots='defaults write com.apple.finder AppleShowAllFiles NO;  killall Finder /System/Library/CoreServices/Finder.app'

fi
