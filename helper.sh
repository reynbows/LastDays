#!/bin/zsh

arg="$1"

function showPopup()
{
    popupMsg=$1
    osascript -e "display notification \"$popupMsg\" with title \"LaInvencion Helper\""
}

function goToRepo()
{
    cd `dirname $0`
}

function pullMaster()
{
    goToRepo
    echo "pull master `pwd`"
    git fetch origin
    git merge origin master

    if [ $? -eq 0 ]; then
        showPopup "Merge with master succeeded!"
    else
        showPopup "Merge with master failed. Run \'git status\' for details."
    fi
}

function push()
{
    goToRepo
    branch=`git branch --show-current`
    git push origin $branch

    if [ $? -eq 0 ]; then
        showPopup "Pushed to the server successfully!"
    else
        showPopup "Push to the server failed. Try \'git push origin $branch\'"
    fi
}

function commit()
{
    goToRepo
    open -a GitHub\ Desktop
}

function cleanup()
{
    goToRepo
    find . -name 'Intermediate' -exec rm -Rf {} \;
    "/Users/Shared/Epic Games/UE_4.23/Engine/Build/BatchFiles/Mac/GenerateProjectFiles.sh" `pwd`/LaInvencion.uproject
    git submodule init
    git submodule update --recursive
    xcodebuild -workspace LaInvencion.xcworkspace -scheme LaInvencion
    if [ $? -eq 0 ]; then
        showPopup "Cleaned up!"
    else
        showPopup "Cleaned up, but couldn't build the project. Try opening Xcode and build it manually."
    fi
}

function showLatest()
{
    goToRepo
    branch=`git branch --show-current`
    commit=`git describe --always`
    latestCommit=`git log -1 --pretty=%B`
    msg="Branch: $branch. Latest: $commit: $latestCommit"
    showPopup "$msg"
    # osascript -e "display notification \"$msg\" with title \"LaInvencion Helper\""
}

case $arg in
    --pull-master)
    pullMaster
    ;;
    --commit)
    commit
    ;;
    --cleanup)
    cleanup
    ;;
    --latest)
    showLatest
    ;;
    --push)
    push
    ;;
    *)
    echo "unknown option $1"
    ;;
esac
