# Antigen
# ----------------
source $HOME/.antigen/antigen.zsh
antigen use oh-my-zsh
antigen theme https://github.com/denysdovhan/spaceship-prompt spaceship
antigen bundle git
antigen bundle git-extras
antigen bundle git-flow
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle npm
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle kubectl
antigen apply
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
# Exports
# ----------------
export SPACESHIP_CHAR_PREFIX="machine-name "
export SPACESHIP_CONDA_VERBOSE=true
export VISUAL=vim
export EDITOR="$VISUAL"
export PATH=$HOME/anaconda3/bin:$PATH
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
export CUDA_HOME=$CUDA_HOME:/usr/local/cuda
# Anaconda
# ----------------
. $HOME/anaconda3/etc/profile.d/conda.sh
# Startup
# ----------------
df -h /
