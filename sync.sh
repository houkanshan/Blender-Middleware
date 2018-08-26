#!/usr/bin/env sh

VERSION=2.69
BASEDIR=$(dirname $(readlink -f "$0"))

if [ ! -f "$BASEDIR/sync.config" ]; then
    echo "$BASEDIR/sync.config does not exist; see sync.config.example"
    exit 1
fi

. $BASEDIR/sync.config

if [ -z "$BLENDER_APP_PATH" ]; then
    echo "BLENDER_APP_PATH not set"
    echo "Missing $PATH/sys.config?"
    exit 1
fi

if [ -z "$BLENDER_USER_PATH" ]; then
    echo "BLENDER_USER_PATH not set"
    echo "Missing $PATH/sys.config?"
    exit 1
fi

BLENDER_REPO_PATH="$BASEDIR/Blender"

update()
{
    if [ "$1" = "repo" ]; then
        A="$BLENDER_USER_PATH/$VERSION"
        B="$BLENDER_REPO_PATH/$VERSION"
        C="$BLENDER_APP_PATH/$VERSION"
        D="$BLENDER_REPO_PATH/$VERSION"
    fi

    if [ "$1" = "system" ]; then
        A="$BLENDER_REPO_PATH/$VERSION"
        B="$BLENDER_USER_PATH/$VERSION"
        C="$BLENDER_REPO_PATH/$VERSION"
        D="$BLENDER_APP_PATH/$VERSION"
    fi

    cd "$A/config"
    rsync -a --info=name *.blend "$B/config/"

    cd "$A/scripts/startup"
    rsync -a --info=name *.py "$B/scripts/startup/"

    cd "$A/scripts/modules"
    rsync -a --info=name --exclude=__pycache__ --exclude=*.pyc krz "$B/scripts/modules/"
    rsync -a --info=name plot.py "$B/scripts/modules/"

    cd "$A/scripts/addons"
    echo "$B/scripts/addons/"
    rsync -a --info=name krz_*.py "$B/scripts/addons/"

    cd "$C/scripts/addons/io_scene_fbx"
    rsync -a --info=name export_fbx.py "$D/scripts/addons/io_scene_fbx/"
    rsync -a --info=name __init__.py "$D/scripts/addons/io_scene_fbx/"
}
