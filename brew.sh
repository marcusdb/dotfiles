
# Install command-line tools using Homebrew

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

brew install stow

brew install antigen

brew install zoxide

#fast finder https://github.com/sharkdp/fd
brew install fd

# mtr - ping & traceroute. best.
brew install mtr

    # allow mtr to run without sudo
    mtrlocation=$(brew info mtr | grep Cellar | sed -e 's/ (.*//') #  e.g. `/Users/user/.homebrew/Cellar/mtr/0.86`
    sudo chmod 4755 $mtrlocation/sbin/mtr
    sudo chown root $mtrlocation/sbin/mtr

brew install zsh-history-substring-search

# Install other useful binaries
brew install the_silver_searcher

brew install fzf

brew install ffmpeg

brew install terminal-notifier

brew install ncdu # find where your diskspace went

brew install cdargs

brew install tmux

brew install nodejs

brew install --cask iterm2

brew install --cask gpg-suite

#github cli
brew install gh

#Tilt - local kubernetes dev
brew install kind
brew install tilt
brew install ctlptl
brew install kubernetes-cli
###

brew install --cask slack

brew install --cask zoom

brew install go

brew install helm

# Remove outdated versions from the cellar
brew cleanup