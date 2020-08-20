#!/usr/bin/env bash

# prompt user
zenity --title "ISO Writer" --info --text="Start wizard" --no-wrap

# get iso file location
FILE=$(zenity --file-selection --title="Select an ISO file" --file-filter='*.iso')

# get usb device location
DEVICE=$(zenity --file-selection --title="Select an USB device" --filename="/dev/" --file-filter='sda*')

# confirmation
zenity --question \
    --title="Confirmation" \
    --text="
ISO: $FILE
Device: $DEVICE
Are you sure you wish to proceed?" \
    --no-wrap

#if command -v pkexec &> /dev/null; then
#	pkexec
#else
#	zenity --password
#fi

if sudo -k -S dd if="$FILE" of="$DEVICE" oflag=sync bs=4M status=progress <<< "$(zenity --password --title="This action requires admin previleges")" | zenity --progress --pulsate --auto-close --no-cancel --text='sudo dd if=/path/to/ubuntu.iso of=/dev/sdb bs=1M'; then
    zenity --info --text="Successfully wrote iso to usb!" --no-wrap
else
    zenity --error --text="Some error occured!" --no-wrap
fi

# sudo -k -S <<< "$(zenity --password)" pacman -Syu | zenity --progress
