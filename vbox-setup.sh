#!/bin/bash
# short script to set up a new Ubuntu VM with VirtualBox Guest Additions
#	1. Update OS to latest, clean up, set vars
#	2. Install packages required for Guest Additions, prompt for CD Install
#	3. If kernel mod is present, setup guest additions

SECTION_BORDER_ART="\n["================================="]\n"
SECTION_DIVIDER="\n--------------------\n"

printf "$SECTION_BORDER_ART"
printf "Setup VirtualBox Ubuntu VMs"
printf "$SECTION_BORDER_ART"

# first updates
printf "Updating to latest sources...\n"
sudo apt-get -qq update -y
printf "Upgrading to latest packages...\n"
sudo apt-get -qq dist-upgrade -y
printf "$SECTION_DIVIDER"
printf "Some cleanup...\n"
sudo apt-get -qq autoclean -y
sudo apt-get -qq autoremove -y
printf "Initial updates done\n"

# set script vars from updated state
LINUX_HEADER_VER="linux-headers-$(uname -r)"
VBOX_REQUIRED_APPS="make gcc $LINUX_HEADER_VER xz-utils"
VBOX_GUEST_MODNAME="vboxguest"
VBOX_CHECK_MODNAME=`lsmod | grep "$VBOX_GUEST_MODNAME" | awk '{print $1}'`
VBOX_GROUPNAME="vboxsf"
VBOX_CONFIG_FLAG=0

# install terminal font
printf "$SECTION_DIVIDER" #---------
printf "\nInstalling patched font\n"
FONT_PACK="Lilex.tar.xz"
FONT_LINK="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.1/Lilex.tar.xz"
FONT_CLEANUP="*.txt *.md *.xz"
FONT_FILE="LilexNerdFontMono-Regular.ttf"
FONT_DIR="$HOME/.fonts/"
if [ ! -f "$FONT_DIR$FONT_FILE" ];
    then
        # bash code to download this file and unpack it.
        mkdir -p $FONT_DIR
        wget -nc --directory-prefix=$FONT_DIR $FONT_LINK
        cd $FONT_DIR && tar -xf $FONT_PACK
        rm $FONT_CLEANUP
    else
        printf "\nFont found, skipping install\n"
fi

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
	printf "$SECTION_DIVIDER"
fi
printf "\nA reboot is required to load the kernel modules and update group membership.\n"
printf "\nConfirm the hypervisor has Guest-Host interaction configured (clipboard, sharing, drag/drop).\n"
printf "$SECTION_BORDER_ART"
