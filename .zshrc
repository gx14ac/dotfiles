# LANGUAGE
export LANG=en_US

# Neofetch
neofetch

# direnv hook
eval "$(direnv hook zsh)"

# GoPath
export GO111MODULE=on
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

#rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# peco

# search .ghq dir.
function peco-src() {
    local selected_dir=$(ghq list | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ~/.ghq/$selected_dir"
        zle accept-line
    fi
    zle redisplay
}
zle -N peco-src
stty -ixon
bindkey '^g' peco-src
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
RPROMPT="%1(v|%F{green}%1v%f|)"

# zsh looks.
PROMPT=">> "
PROMPT="%F{yellow}[snt]%f >> "
RPROMPT="%{${fg[blue]}%}[%~]%{${reset_color}%}"
export LSCOLORS=cxfxcxdxbxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export ZLS_COLORS=$LS_COLORS
export CLICOLOR=true
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'

# git completion.
fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit -u

# search zsh_history.
function peco-select-history() {
  BUFFER=$(\history -n 1 | tac | peco)
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# zsh History.
HISTFILE=~/.zshrc_history
HISTSIZE=1000000
SAVEHIST=1000000
HISTTIMEFORMAT='%y/%m/%d %H:%M:%S ';
HISTIGNORE=ls:la:history
setopt share_history
setopt hist_ignore_all_dups

# hub command.
function git(){hub "$@"}

# alias.
alias gs='git status'
alias gco='git commit'
alias gcm='git commit -m'
alias git-remove-local-branch='git branch --merged | grep -v 'master' | grep -v 'develop''
alias hb='hub browse'
alias hi='hub issue'
alias tf='terraform'
alias ll="ls -al"
alias ss="screen -S"
alias sr="screen -r"
alias sls="screen -ls"
alias emacs="emacs &"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/shinta/google-cloud-sdk/path.zsh.inc' ]; then . '/home/shinta/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/shinta/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/shinta/google-cloud-sdk/completion.zsh.inc'; fi
