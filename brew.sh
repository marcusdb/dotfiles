#!/bin/bash

# Install command-line tools using Homebrew

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

brew install antigen
# GNU core utilities (those that come with OS X are outdated)
brew install coreutils
brew install moreutils
# GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew install findutils
# GNU `sed`, overwriting the built-in `sed`
#brew install gnu-sed --with-default-names


# z hopping around folders
brew install z

#fast finder https://github.com/sharkdp/fd
brew install fd

# run this script when this file changes guy.
#brew install entr

# github util. gotta love `hub fork`, `hub create`, `hub checkout <PRurl>`
#brew install hub


# mtr - ping & traceroute. best.
brew install mtr

    # allow mtr to run without sudo
    mtrlocation=$(brew info mtr | grep Cellar | sed -e 's/ (.*//') #  e.g. `/Users/user/.homebrew/Cellar/mtr/0.86`
    sudo chmod 4755 $mtrlocation/sbin/mtr
    sudo chown root $mtrlocation/sbin/mtr

brew install zsh-history-substring-search

# Install other useful binaries
brew install the_silver_searcher
#brew install fzf

brew install git
#brew install imagemagick --with-webp
brew install node # This installs `npm` too using the recommended installation method
#brew install pv
#brew install rename
#brew install tree
#brew install zopfli
#brew install ffmpeg --with-libvpx

brew install terminal-notifier


brew install ncdu # find where your diskspace went

brew install cdargs

brew install tmux

brew install fzf

brew install thefuck
# Remove outdated versions from the cellar
brew cleanup