#!/usr/bin/env bash
#make the directories we need
mkdir $HOME/public/ghost
mkdir $HOME/public/ghost/ghostscript
#copy the binaries and flatten into the directory above
cp `find -L $HOME/../deps/0/ -type f | awk -F/ '{a[$NF]=$0}END{for(i in a)print a[i]}'` $HOME/public/ghost/ghostscript
#move the first libgs.so to the root (Ghostscript Jar requires this file in the root of the classpath)
mv `find $HOME/public/ghost/ghostscript -type f -name libgs.so* | head -n 1` $HOME/public/ghost/libgs.so
#cd into directory so the structure of the zip is correct
cd $HOME/public/ghost
zip -x "*.gz" -x "*.jar" -r ../ghostscript.zip .
#cd back to home dir for stager and delete the directory
cd
rm -r $HOME/public/ghost