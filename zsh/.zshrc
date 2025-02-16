
# The following lines were added by compinstall

zstyle ':completion:*' completer _list _expand _complete _ignored _match _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle :compinstall filename '/home/rosario/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=20000
SAVEHIST=20000


# vi keymap ...
bindkey -v
# ... with Ctrl-A and Ctrl-E
bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line

# End of lines configured by zsh-newuser-install
#

export JAVA_HOME="/usr/lib/jvm/java-21-openjdk"

# my custom aliases
source ~/common_aliases.zsh

# git aliases 
source ~/.config/git/git.zsh

# zoxide
eval "$(zoxide init zsh)"

# fzf 
source ~/.config/fzf/fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
