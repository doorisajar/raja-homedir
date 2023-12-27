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
