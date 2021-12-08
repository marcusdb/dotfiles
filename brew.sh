
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

brew install ffmpeg --with-libvpx

brew install terminal-notifier

brew install ncdu # find where your diskspace went

brew install cdargs

brew install tmux

brew install thefuck
# Remove outdated versions from the cellar
brew cleanup