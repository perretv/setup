# Antigen zsh plugins
# ----------------
source $HOME/.antigen/antigen.zsh
antigen use oh-my-zsh
antigen bundle colored-man-pages
antigen bundle command-not-found
antigen bundle esc/conda-zsh-completion
antigen bundle git
antigen bundle git-extras
antigen bundle git-flow
antigen bundle kubectl
antigen bundle npm
antigen bundle pip
antigen bundle pep8
antigen bundle pyenv
antigen bundle python
antigen bundle sudo
antigen bundle systemd
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh_reload
antigen apply
# Starship shell
# ----------------
eval "$(starship init zsh)"
# zsh
# ----------------
setopt no_share_history
# Aliases
# ----------------
alias ll='ls -ltrh'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias h='history'
# Environment variables
# ----------------
export VISUAL=vim
export EDITOR="$VISUAL"
export PATH=$HOME/miniforge3/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
# Miniforge3
# ----------------
. $HOME/miniforge3/etc/profile.d/conda.sh
