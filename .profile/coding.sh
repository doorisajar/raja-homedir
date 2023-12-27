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
changelog () {
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

# convert tabs to spaces inplace
detab() {
  [[ "$#" -ne "1" ]] && { echo "A single argument must be provided"; exit 1; }
  tmp=`mktemp` && expand "$1" > "$tmp" && mv "$tmp" "$1"
}

# Use ffpmeg and imagemagick to quickly convert a .mov to a .gif.
# Primarily used for quickly converting screencasts
# into gifs (which can then be viewed online easily)
mov2gif () {
    # Seen at https://community.rstudio.com/t/is-there-a-way-to-record-code-typing-and-execution-as-a-video-gif-etc-in-rstudio/13614/8

    if [ "$#" -eq 0 ]; then
        echo "Usage: mov2gif input [output]"
        return 1
    fi

    if [ "$#" -eq 1 ]; then
	    OUTPUT="${1%.mov}".gif
    else
	    OUTPUT="$2"
    fi

    ffmpeg -i "$1" -r 20 -f image2pipe -vcodec ppm - | \
	convert -delay 5 -fuzz 1% -layers Optimize -loop 0 - "${OUTPUT}"
}

# binary diff of 2 files
hexdiff () {
    hexdump -C $1 > /tmp/${1:t}
    hexdump -C $2 > /tmp/${2:t}
    git diff "$@[3,-1]" --no-index /tmp/${1:t} /tmp/${2:t}
}
