# Shell script to deploy config to a new VirtualBox Ubuntu VM
#

# The new classic
sudo snap install nvim -y
# The foundation
sudo apt-get install curl ripgrep

# Build javascript environment
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# Update directories immediately
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

printf "Installing latest node via nvm"
nvm install node

# find/generate an ssh key
mkdir -p ~/.ssh/
SSH_CHECK_RESULT=`find ~/.ssh -name "id_rsa"`
if [ "$SSH_CHECK_RESULT" == "/home/$USERNAME/.ssh/id_rsa" ]
then
	printf "key already present\n"
else
	ssh-keygen
	printf "new key\n"
fi
