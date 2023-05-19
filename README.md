# dotfiles

currently has scripts to...
set up a new VirtualBox guest VM (only tested on Ubuntu 23)
    - update repos and apps
    - interactively install guest additions CD
    - detect correct installation (vboxguest kernel mod exists?)
    - configure vbox sharing group

set up a VM for dev work
    - tuned for javascript and web development
        - nvm at the moment, but easy to add more
    - nvm/node, neovim 0.9, others
    - multiple interactive prompts
        - ssh keygen + strong defaults (blast on through with confidence!)
        - upload the public key to github
        - test ssh connectivity
    - complete git config
    - updates the local .dotfiles repo to use SSH (presumes cloning via https)

load preferences into neovim
    - REQUIRED - open vim and run :so and :PackerSync commands on packer.lua
    - lifted almost totally from github.com/thePrimeagen
    - extensive remaps, configs, packages
    - includes git, large undo history, treesitter, lsps, mason, etc.
    -
