#!/bin/sh -e
MODE=$1
cp modes/$MODE/strings.xml resources/strings.xml
cp modes/$MODE/mode.mc src/mode.mc

