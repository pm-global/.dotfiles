#!/bin/bash
# Script to install some developer tools on an ubuntu VM
#
SECTION_BORDER_ART="\n["================================="]\n"
SECTION_DIVIDER="\n--------------------\n"

printf $SECTION_BORDER_ART #-------------------------------------
printf "Install dev programs and some config"
printf $SECTION_BORDER_ART

PACKAGE_INSTALL_LIST="curl ripgrep xclip"
SNAP_INSTALL_LIST="nvim"
printf "\nInstalling packages: $PACKAGE_INSTALL_LIST\n"
sudo apt-get install $PACKAGE_INSTALL_LIST

printf "$SECTION_DIVIDER" #---------
printf "\nInstalling snaps: $SNAP_INSTALL_LIST\n"
sudo snap install $SNAP_INSTALL_LIST

# Get node manager
printf $SECTION_BORDER_ART #-------------------------------------
printf "Installing NVM\n"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

printf "$SECTION_DIVIDER" #---------
# Update environment to immediately install latest node
printf "Loading nvm and bash completion\n"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

printf $SECTION_BORDER_ART #-------------------------------------
printf "Install latest node?\n"
read -n 1 -s -r -p "enter for 'no', any other input will install node: " NODE_CHOICE

if [ "$NODE_CHOICE" != "" ]
then
	printf "\nInstalling latest Node\n"
	nvm install node
fi

printf $SECTION_BORDER_ART #-------------------------------------
# ssh keys and agent - interactive to be more useful
printf "Making ssh key\nWhat folder to use?\n"
read -r -p "(enter for $HOME/.ssh): " NEW_DIR
SSH_DIR="$HOME/.ssh"				# this is bash magic
[ -n "${NEW_DIR}" ] && SSH_DIR=${NEW_DIR}	# for assigning default values
 						# https://stackoverflow.com/a/2013732
mkdir -p $SSH_DIR

printf "$SECTION_DIVIDER" #---------
read -r -p "SSH Options (enter for 4096-bit): " USR_OPT
SSH_OPT="-t rsa -b 4096"			# default
[ -n "${USR_OPT}" ] && SSH_OPT=${USR_OPT} 	# assigns user options to ssh if present, otherwise default

printf "running ssh-keygen options $SSH_OPT\n"
ssh-keygen $SSH_OPT -f $SSH_DIR/id_rsa

printf "$SECTION_DIVIDER" #---------
printf "\nRefreshing agent with new keys.\n"
eval "$(ssh-agent -s)"
chmod 700 "$SSH_DIR"
ssh-add $SSH_DIR/id_rsa

printf "Displaying public RSA key"
printf $SECTION_BORDER_ART #-------------------------------------
sudo cat "$SSH_DIR/id_rsa.pub"
printf $SECTION_BORDER_ART #-------------------------------------
printf "Go here: GitHub.com -> Profile Icon -> Settings -> SSH & GPG Keys -> New SSH Key\n"
read -n 1 -s -r -p "After adding this key to github, propagation takes about ~1 minute, enter to start a timer and test."
printf "\n"  # additional \n because the read command doesn't give one

# timer to wait for github propagation delay
SECONDS=70
printf "\nWaiting $SECONDS seconds before testing github\n"
awk -v t=$SECONDS 'BEGIN{t=int(t*1000); printf "Elapsed Time (HH:MM:SS): %d:%02d:%02d\n", t/3600000, t/60000%60, t/1000%60}'

printf $SECTION_BORDER_ART #-------------------------------------
# connect to github, prompt to add key
printf "Checking github ssh authentication. 'yes' if prompted to approve new ssh connection.\n"
ssh -T git@github.com
printf "\nIf that didn't work, check the key on GitHub\n"

printf "\nChanging dotfiles origin from http to ssh\n"
(cd $HOME/.dotfiles/; git -v git@github.com:sgvertical/.dotfiles.git)
