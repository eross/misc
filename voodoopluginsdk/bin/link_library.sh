#!/bin/sh

SRC_DIR=`cd ${0%/*}/..; pwd`


if [ ! -d ~/Library/Application\ Support/VoodooPad/PlugIns ]; then
    mkdir ~/Library/Application\ Support/VoodooPad/PlugIns
fi

cd ~/Library/Application\ Support/VoodooPad/PlugIns

for i in $SRC_DIR/build/*.vpplugin; do
    ln -s $i 
done