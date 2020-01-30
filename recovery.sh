#!/bin/bash

# This program is just an backup program
# Copyright (C) 2020  Baljit Singh Sarai

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; version 2 of
# the License.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.


<<COMMENT
  A few things to note when using this script.
  Do not put the script into any of the directories.
  This script presumes that the backup folder and
  working folder are right next to each other and that
  the script it self is at the same dir level as them.
  Change that to your liking before using the script. :)
COMMENT

backup_dir="backup"
working_dir="working"
temp_dir="temp"
if [ "$(ls -A $backup_dir)" ]; then
    mkdir $temp_dir
    for entry in "$backup_dir"/*
    do
      rsync -av  --compare-dest=../$temp_dir/ $entry/ $working_dir
      rm -r $temp_dir
      rsync -av $working_dir/ $temp_dir/
    done
    rm -r $temp_dir
else
  echo "No backup found"
fi