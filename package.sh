#!/bin/sh
MODE=$1
[ "$MODE" = "" ] && MODE=hr

./copy-mode-files.sh $MODE

RESOURCE_PATH=$(find . -path './resources*.xml' | xargs | tr ' ' ':')

monkeyc -e \
    -o bin/$MODE-datafield.iq \
    -w \
    -z $RESOURCE_PATH \
    -m modes/$MODE/manifest.xml \
    src/*.mc
