# Get git main branch name
get_git_main_branch() {
    git_main="main"
    if [ `git rev-parse --verify main 2>/dev/null` ]
    then
        git_main="main"
    else 
        git_main="master"
    fi
}

# resync to master.
resync (){
    current_branch=`git branch --show-current` 
    sync_to_main()
    if [ $current_branch != $git_main]
    then 
        git checkout $current_branch
        git merge $git_main
    fi
    git stash pop
}

# stash local change and switch to master
sync_to_main (){
    git stash
    get_git_main_branch()
    echo "checkout main ...."
    git checkout main
    git pull origin $git_main 
}

# get eth balance for any network.
get_balance() {
    local url=$1
    local param1=$2
    local param2=${3:-"latest"}

    curl --request POST \
         --url "$url" \
         --header 'accept: application/json' \
         --header 'content-type: application/json' \
         --data "{
           \"id\": 1,
           \"jsonrpc\": \"2.0\",
           \"params\": [
             \"$param1\",
             \"$param2\"
           ],
           \"method\": \"eth_getBalance\"
         }"
}

