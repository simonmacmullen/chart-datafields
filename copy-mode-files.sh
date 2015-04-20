#!/bin/sh -e
MODE=$1
cp modes/strings-$MODE.xml resources/strings.xml
cp modes/mode-$MODE.mc src/mode.mc

