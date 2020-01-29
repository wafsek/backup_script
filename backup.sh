#!/bin/bash
<<COMMENT
  A few things to note when using this script.
  Do not put the script into any of the directories.
  This script presumes that the backup folder and
  working folder are right next to each other and that
  the script it self is at the same dir level as them.
  Change that before using the script. :)
COMMENT

backup_dir="backup"
working_dir="working"
temp_dir="temp"
new_backup=B$(date +"%Y%m%d%H%M%S")
if [ "$(ls -A $backup_dir)" ]; then
    mkdir $new_backup
    rsync -a  $working_dir"/" $temp_dir
    for entry in "$backup_dir"/*
    do
      rm -r $new_backup
      rsync -a  --compare-dest=../$entry/ $temp_dir/ $new_backup
      rm -r $temp_dir
      rsync -a $new_backup/ $temp_dir
    done
    mv $new_backup $backup_dir/$new_backup
    rm -r $temp_dir
else
    rsync -av  $working_dir"/" backup/"B00000000000000"
fi