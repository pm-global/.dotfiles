#!/bin/bash
# this is a bash script for quickly setting up a new VirtualBox Ubuntu guest VM
#	1. Update OS to latest, clean up, set vars
#	2. Install packages required for Guest Additions, prompt for CD Install
#	3. If kernel mod is present, add user to vbox group
# 	4. Prompt to configure VM settings + manual reboot

SECTION_BORDER_ART="\n["================================="]\n"
printf "$SECTION_BORDER_ART"
printf "Setup VirtualBox Ubuntu VMs"
printf "$SECTION_BORDER_ART"

# first updates
printf "Updating to latest sources...\n"
sudo apt-get -qq update -y
printf "Upgrading to latest packages...\n"
sudo apt-get -qq dist-upgrade -y
printf "Some cleanup...\n"
sudo apt-get -qq autoclean -y
sudo apt-get -qq autoremove -y
printf "Updates done\n"

# set script vars from updated state
LINUX_HEADER_VER="linux-headers-$(uname -r)"
VBOX_REQUIRED_APPS="make gcc $LINUX_HEADER_VER"
VBOX_GUEST_MODNAME="vboxguest"
VBOX_CHECK_MODNAME=`lsmod | grep "$VBOX_GUEST_MODNAME" | awk '{print $1}'`
VBOX_GROUPNAME="vboxsf"
VBOX_CONFIG_FLAG=0

# prep vm for VirtualBox Guest Additions
printf $SECTION_BORDER_ART
printf "Installing these packages required by Guest Additions:\n$VBOX_REQUIRED_APPS\n"
sudo apt-get -qq install $VBOX_REQUIRED_APPS

# prompt to install Guest Additions CD
printf $SECTION_BORDER_ART
printf "From this VM's menu: 'Devices > Insert Guest Additions CD Image...'\n"
read -n 1 -s -r -p "After the Guest Additions install is complete, press enter to continue."
printf "\n"

# check that Guest Additions was installed
printf $SECTION_BORDER_ART
printf "Checking for VirtualBox Guest Additions\n"

if [ "$VBOX_CHECK_MODNAME" != "$VBOX_GUEST_MODNAME" ]
then    
	printf "Guest Addition kernel module "$VBOX_GUEST_MODNAME" not found"
else	
	printf "Guest Additions found\n"
	printf "Adding "$USER" user to "$VBOX_GROUPNAME"\n"
	sudo adduser --quiet "$USER" "$VBOX_GROUPNAME"
	printf "The group members of "$VBOX_GROUPNAME" are now:\n"
	grep -i --color "$VBOX_GROUPNAME" /etc/group
fi
printf "\nA reboot is required to load the kernel modules and update group membership.\n"
printf "\nConfirm the hypervisor has Guest-Host interaction configured (clipboard, sharing, drag/drop).\n"
printf "$SECTION_BORDER_ART"
