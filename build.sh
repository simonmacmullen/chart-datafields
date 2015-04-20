#!/bin/sh -e
DEVICE=$1
[ "$DEVICE" = "" ] && DEVICE=fenix3
MODE=$2
[ "$MODE" = "" ] && MODE=hr

./copy-mode-files.sh $MODE

RESOURCE_PATH=$(find . -path './resources*.xml' | xargs | tr ' ' ':')
monkeyc -o bin/$MODE-datafield.prg -d $DEVICE -m manifest-$MODE.xml -z $RESOURCE_PATH src/*.mc
