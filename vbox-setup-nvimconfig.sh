#! bin/bash/
# Setup nvim LSP, mostly ripped from the primeagen

# Folder setup: make initial directory, symlink the settings
printf "\nInstalling packages, setting up directories\n"
INSTALL_PACKS="g++"
sudo apt-get install $INSTALL_PACKS
mkdir -p $HOME/.config/
ln -s -f $HOME/.dotfiles/nvim $HOME/.config/nvim

# Packer plugin manager
printf "\nCloning Packer (nvim package manager) repo\n"
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

printf "\n\nTo finish nvim setup:\n"
printf "1) open ~/.config/nvim/lua/dev/packer.sync in nvim\n"
printf "2) use the :so command then :PackerSync\n"
printf "3) restart nvim, confirm binds, commands, colors, autocomplete\n"
