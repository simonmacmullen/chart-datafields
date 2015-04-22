#!/bin/sh
rm -rf bin
for mode in `ls modes` ; do
    echo $mode
    ./package.sh $mode
done
