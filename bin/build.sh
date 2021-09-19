#!/usr/bin/bash
OLD_ROCKSPECS=$(ls *.rockspec)
luarocks new_version
rm $OLD_ROCKSPECS
sudo luarocks build