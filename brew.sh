
# Install command-line tools using Homebrew

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

brew install stow

#brew install antigen

#https://github.com/ajeetdsouza/zoxide a smarter CD
brew install zoxide

#fast finder https://github.com/sharkdp/fd
brew install fd

#zsh
brew install jandedobbeleer/oh-my-posh/oh-my-posh
# install font for oh-my-posh
brew install --cask font-fira-code-nerd-font


brew install zsh-autosuggestions
brew install zsh-history-substring-search

#https://github.com/ggreer/the_silver_searcher
#brew install the_silver_searcher

#https://github.com/junegunn/fzf
brew install fzf

#really??
#brew install ffmpeg
#https://github.com/julienXX/terminal-notifier
#brew install terminal-notifier

# find where your diskspace went
#brew install ncdu 

brew install tmux

#brew install node@18

brew install --cask iterm2

brew install --cask gpg-suite


brew install neovim

#github cli
brew install gh

#Tilt - local kubernetes dev
brew install kind
brew install tilt
brew install ctlptl
brew install kubernetes-cli

brew install --cask rancher
###

brew install --cask slack

brew install --cask zoom

brew install --cask logi-options-plus

brew install --cask raycast

brew install helm

brew install --cask obsidian

#Time to play
brew install --cask steam

brew install --cask whatsapp 
brew install --cask visual-studio-code
brew install --cask signal
brew install nvm

brew install magic-wormhole

# a better CAT command
brew install bat

# automatically swith keyboard layouts depending on the keyboard
# https://github.com/ohueter/autokbisw
#autokbisw doesn't work after installation.
#If autokbisw isn't working after the first start of the service, try these solutions:
#Restart the service:
#brew services restart autokbisw

brew install ohueter/tap/autokbisw
brew services start autokbisw


#Language tool
brew install languagetool
brew services start languagetool

brew install --cask insta360-studio
# Remove outdated versions from the cellar

brew install --cask blender

brew install --cask postman

#internet access for local pages
brew install ngrok/ngrok/ngrok
brew install openjdk@17
brew install discord
brew cleanup

# add karbiner elements
# to add keyboard casting
brew install --cask keycastr  

brew install ollama

# application uninstaller remover
brew install pearcleaner

brew install ripgrep

brew install fd

brew install pass

brew install dopplerhq/cli/doppler

brew tap hashicorp/tap
brew install hashicorp/tap/terraform

brew install checkov

brew install mprocs