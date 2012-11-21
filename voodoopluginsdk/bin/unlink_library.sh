#!/bin/sh

PLUGINS_DIR=${0%/*}


if [ ! -d ~/Library/Application\ Support/VoodooPad/PlugIns ]; then
    mkdir ~/Library/Application\ Support/VoodooPad/PlugIns
fi

dir=

echo $dir

for i in ~/Library/Application\ Support/VoodooPad/PlugIns/*.vpplugin; do
    rm "$i"
done