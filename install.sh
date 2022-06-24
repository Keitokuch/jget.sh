#! /usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

CONFIG=~/.config/jget
mkdir -p $CONFIG

cp $DIR/config $CONFIG

JGET_SRC=$DIR $DIR/jget.sh install -f jget
