# oh-my-zsh
# ----------------
export ZSH="$HOME/.oh-my-zsh"
# oh-my-zsh plugins
# ----------------
plugins=(
	brew
	docker
	git
	macos
	npm
	pip
	poetry
	python
	terraform
	zsh-autosuggestions
	zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh
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
export PATH=$HOME/.local/bin:$PATH
