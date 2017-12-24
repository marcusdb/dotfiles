# uncomment to profile prompt startup with zprof
# zmodload zsh/zprof

# history
SAVEHIST=100000

# vim bindings
bindkey -v
# ctrl a + ctrl e behaviour
bindkey -e


fpath=( "$HOME/.zfunctions" $fpath )


# antigen time!
source /usr/local/share/antigen/antigen.zsh

# Don't load the oh-my-zsh's library. Takes too long. No need.
	# antigen use oh-my-zsh

antigen bundle git
antigen bundle extract
antigen bundle pip
antigen bundle lein
antigen bundle brew
antigen bundle brew-cask
antigen bundle robbyrussell/oh-my-zsh plugins/z
antigen bundle command-not-found




# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting




# suggestions
antigen bundle tarruda/zsh-autosuggestions

# colors for all files!
antigen bundle trapd00r/zsh-syntax-highlighting-filetypes

# dont set a theme, because pure does it all
#antigen theme steeef
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure


# Tell Antigen that you're done.
antigen apply

###
#################################################################################################



# bind UP and DOWN arrow keys for history search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

export PURE_GIT_UNTRACKED_DIRTY=0

# Automatically list directory contents on `cd`.
auto-ls () {
	emulate -L zsh;
	# explicit sexy ls'ing as aliases arent honored in here.
	hash gls >/dev/null 2>&1 && CLICOLOR_FORCE=1 gls -aFh --color --group-directories-first || ls
}
chpwd_functions=( auto-ls $chpwd_functions )


# Enable autosuggestions automatically
#zle-line-init() {
#    zle autosuggest-start
#}

#zle -N zle-line-init


# history mgmt
# http://www.refining-linux.org/archives/49/ZSH-Gem-15-Shared-history/
setopt inc_append_history
setopt share_history


zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'


# uncomment to finish profiling
# zprof



# Load default dotfiles
source ~/.bash_profile

