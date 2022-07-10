#!/usr/bin/env bash

repo=`echo $REPOSITORY`
repo_path="/srv/repo/blog"
destination="/srv/public/blog"


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

function hugo-generate(){
    if [ ! -d "$repo_path" ]; then
        echo "hugo generate, path ${repo_path} not exist, return"
        return 1
    fi

    if [ -d "$destination" ]; then
        rm -rf $destination
        if [ $? != 0 ]; then
            echo "hugo generate, remove destination ${destination} error, return"
        fi
    fi
    mkdir -p $destination
    if [ $? != 0 ]; then
        echo "hugo generate, create destination ${destination} error, return"
        return 1
    fi

    cd $repo_path
    /usr/bin/hugo -D --destination=/srv/public/blog
    if [ $? != 0 ]; then
        echo "hugo generate, generate static file error, return"
        return 1
    fi
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

    hugo-generate
    if [ $? != 0 ]; then
        return 1
    fi
    return 0
}

hook