#! /bin/bash

clear
result=$(whoami)
function backup {
	{
	  echo "backup" > result
	} | whiptail --gauge "Backing up data ..." 6 60 0
}



function recovery {
	{
	  echo "recovery" > result
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
		read -r result < result
	;;
	"2)")
	  recovery
	  read -r result < result
	;;

	"9)") exit
        ;;
esac
whiptail --msgbox "$result" 20 78
rm result
done
exit