#!/bin/sh

RESOURCE_PATH=$(find . -path './resources*.xml' | xargs | tr ' ' ':')

monkeyc -e \
    -o bin/hr-datafield.iq \
    -w \
    -z $RESOURCE_PATH \
    -m manifest.xml \
    src/*.mc
