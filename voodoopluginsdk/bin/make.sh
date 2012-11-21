#!/bin/sh

PLUGINS_DIR=${0%/*}

PLUGINS_DIR=`cd $PLUGINS_DIR/..;pwd`
BUILD_DIR=$PLUGINS_DIR/build

if [ -d $BUILD_DIR ]; then
    rm -rf $BUILD_DIR
fi

cd $PLUGINS_DIR

xcodebuild -project voodoopadplugins.xcode\
  -alltargets -buildstyle Deployment build \
  OBJROOT=$BUILD_DIR SYMROOT=$BUILD_DIR

if [ $? != 0 ]; then
    echo "Bad build"
else
    /Developer/Tools/SetFile -a B $BUILD_DIR/*.vpplugin
    
fi

#mkdir -p ~/builds/VoodooPad.app/Contents/PlugIns
#cp -r ./build/*.vpplugin ~/builds/VoodooPad.app/Contents/PlugIns/.