#!/usr/bin/env bash

repo=`echo $NOTES`
repo_path="/srv/repo/notes"
destination="/srv/public/notes"


function clone(){
    echo "git clone repo ${repo} ..."
    rm -rf $repo_path
    git clone --recursive $repo $repo_path
    if [ $? != 0 ]; then
        echo "git clone repo ${repo} error, remove repo path ${repo_path} and retry"
        rm -rf $repo_path
        if [ $? != 0 ]; then
            echo "remove path ${repo_path} of repo ${repo} error, return"
            return 1
        fi
        git clone $repo $repo_path
        if [ $? != 0 ]; then
            echo "git clone repo ${repo} error, return"
            return 1
        fi
    fi
    return 0
}

function pull(){
    echo "git pull repo ${repo} ...";
    if [ ! -d "$repo_path/.git" ]; then
        echo "git pull and update submodule repo ${repo}, path ${repo_path} not exist, return"
        return 1
    fi
    cd $repo_path
    git pull --rebase && git submodule update --remote
    if [ $? != 0 ]; then
        echo "git pull and update submodule repo ${repo} error, return"
        return 1
    fi
    return 0
}

function mdbook-generate(){
    if [ ! -d "$repo_path" ]; then
        echo "mdbook generate, path ${repo_path} not exist, return"
        return 1
    fi

    if [ -d "$destination" ]; then
        rm -rf $destination
        if [ $? != 0 ]; then
            echo "mdbook generate, remove destination ${destination} error, return"
        fi
    fi
    mkdir -p $destination
    if [ $? != 0 ]; then
        echo "mdbook generate, create destination ${destination} error, return"
        return 1
    fi

    cd $repo_path
    for row in $(cat "$repo_path/update.json"|jq -r '.[]'); do  
        /usr/bin/mdbook build $row --dest-dir "$destination/$row"
        if [ $? != 0 ]; then
            echo "mdbook generate, generate $row static file error, return"
            return 1
        fi
    done
    return 0
}

function hook(){
    if [ -z "$repo" ];then
        echo "repository is empty"
        exit 0
    fi

    if [ ! -d "$repo_path/.git" ]; then
        clone;
        if [ $? != 0 ]; then
            return 1
        fi
    else
        pull;
        if [ $? != 0 ]; then
            return 1
        fi
    fi

    mdbook-generate
    if [ $? != 0 ]; then
        return 1
    fi
    return 0
}

hook