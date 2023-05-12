# Shell script to deploy a dev config to a new VirtualBox Ubuntu VM
#
SECTION_BORDER_ART="\n["================================="]\n"

printf $SECTION_BORDER_ART
printf "Dev Env Setup"
printf $SECTION_BORDER_ART

PACKAGE_INSTALL_LIST="curl ripgrep xclip"
printf "\nInstalling packages and managers, including node\n"
sudo apt-get install $PACKAGE_INSTALL_LIST
sudo snap install nvim

# Build javascript environment
printf $SECTION_BORDER_ART
printf "Installing Node Version Manager, enabling immediately\n"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# Update directories immediately
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

printf $SECTION_BORDER_ART
printf "Installing latest node via nvm\n"
nvm install node

printf $SECTION_BORDER_ART
# ssh keys and agent
mkdir -p ~/.ssh/
printf "Making ssh key (if necessary)\n"
ssh-keygen 
printf "\nAdding to agent\n"
sudo ssh-agent ~/.ssh/id_rsa.pub

printf $SECTION_BORDER_ART
# connect to github, prompt to add key
printf "Checking github ssh authentication. 'yes' if prompted to add github server.\n"
ssh -T git@github.com
printf "\nIf that didn't work, add the following key to GitHub\n"
printf "Go here: GitHub.com -> Profile Icon -> Settings -> SSH & GPG Keys -> New SSH Key\n"

printf $SECTION_BORDER_ART
sudo cat ~/.ssh/id_rsa.pub
printf $SECTION_BORDER_ART
read -n 1 -s -r -p "After adding this key to github, press enter to continue"

printf "\n"
