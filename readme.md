
## Setup MAC

#### hidden files
The long way to show hidden Mac OS X files is as follows:
1. Open Terminal found in Finder > Applications > Utilities.
2. In Terminal, paste the following: defaults write com.apple.finder AppleShowAllFiles YES.
3. Press return.
4. Hold the 'Option/alt' key, then right click on the Finder icon in the dock and click Relaunch.

#### Z jump around
* git clone https://github.com/rupa/z.git ~/code/z
* add . ~/code/z/z.sh to bash_profile

#### the fuck command corrector
brew install thefuck


#### bash_completions IF BASH
* brew install bash-completion
* brew tap homebrew/homebrew-core

#### install software
brew install antigen (if zsh)
# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade


# GNU core utilities (those that come with OS X are outdated)
brew install coreutils
brew install moreutils
# GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew install findutils --default-names  
# GNU `sed`, overwriting the built-in `sed`
brew install gnu-sed --with-default-names

#other
brew install gnu-tar --default-names  
brew install gnu-which --default-names  
brew install gnutls --default-names  
brew install grep --default-names  
brew install binutils  
brew install diffutils  
brew install gzip  
brew install watch  
brew install tmux   
brew install wget  
brew install nmap  
brew install gpg  
brew install htop  


