#!/bin/sh -e
DEVICE=$1
[ "$DEVICE" = "" ] && DEVICE=fenix3_sim
MODE=$2
[ "$MODE" = "" ] && MODE=hr

killall simulator || true
connectiq
./build.sh $DEVICE $MODE
monkeydo bin/$MODE-datafield.prg $DEVICE
