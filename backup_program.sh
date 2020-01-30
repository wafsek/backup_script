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
  WARNING DO NOT USE THIS SCRIPT ON SOMETHING IMPORTANT.
  IT MAY NOT BE SAFE FOR ONE REASON.
  1) I AM NOT AN EXPERT AT BASH SCRIPTING.
  Please i dont want you to mess up your files.
COMMENT

<<COMMENT
  If you still wish to use it. note the following things:
  1) Do not put your script into any of the dirs.
  2) You need to edit the directory variables so as to
     fit them to your using.
     Right now the script presumes that the script is
     in the same directory as the backup, working and recovery
     directory.

  Now feel free to play around or fork it to improve it. cheers :)
  Feedback is highly welcomed :)
COMMENT


clear

backup_dir="backup"         #The directory that has/will have the backups
working_dir="working"       #The directory that is to be backed up
recovery_dir="recovery"     #The directory where you want your recovery to be copied to
temp_dir="temp"             #A temp directory that the script needs

function backup {
	{
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
        rsync -av  $working_dir"/" backup/$new_backup
    fi
	} | whiptail --gauge "Backing up data ..." 6 60 0
}



function recovery {
	{
	  if [ "$(ls -A $backup_dir)" ]; then
    mkdir $temp_dir
    for entry in "$backup_dir"/*
    do
      rsync -av  --compare-dest=../$temp_dir/ $entry/ $recovery_dir
      rm -r $temp_dir
      rsync -av $recovery_dir/ $temp_dir/
      done
      rm -r $temp_dir
    else
      echo "No backup found"
    fi
	} | whiptail --gauge "Recovering data ..." 6 60 0
}



while [ 1 ]
do
CHOICE=$(
whiptail --title "Backup program" --menu "Make your choice" 16 100 9 \
	"1)" "Backup your files."   \
	"2)" "Recover your files."  \
	"9)" "End script"  3>&2 2>&1 1>&3
)


case $CHOICE in
	"1)")
		backup
	;;
	"2)")
	  recovery
	;;

	"9)") exit
        ;;
esac
done
exit