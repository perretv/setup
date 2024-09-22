# Oh My Zsh configuration
# -----------------------
export ZSH="$HOME/.oh-my-zsh"

# Detect OS for OS-specific plugins
case "$(uname -s)" in
    Darwin*)
        OSNAME="MacOS"
        ;;
    Linux*)
        OSNAME="Linux"
        ;;
    *)
        OSNAME="Other"
        ;;
esac

# Oh My Zsh plugins
# -----------------
plugins=(
    git
    npm
    pip
    poetry
    python
    terraform
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Include OS-specific plugins
if [ "$OSNAME" = "MacOS" ]; then
    plugins+=(brew macos)
elif [ "$OSNAME" = "Linux" ]; then
    plugins+=(docker)
fi

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Starship prompt
# ---------------
eval "$(starship init zsh)"

# Zsh options
# -----------
setopt no_share_history       # Don't share command history between sessions
setopt hist_ignore_dups       # Ignore duplicate commands in history
setopt hist_ignore_space      # Ignore commands that start with a space

# Aliases
# -------
alias ll='ls -alFh'           # Detailed listing with sizes in human-readable format
alias la='ls -A'              # List all except . and ..
alias l='ls -CF'              # List in columns
alias rm='rm -i'              # Prompt before removing files
alias mv='mv -i'              # Prompt before moving files
alias cp='cp -i'              # Prompt before copying files
alias h='history'             # Shortcut for history command
alias grep='grep --color=auto' # Highlight search results

# Environment variables
# ---------------------
export VISUAL=vim
export EDITOR="$VISUAL"
export PATH="$HOME/.local/bin:$PATH"

# Load fzf if installed
# ---------------------
if [ -f "$HOME/.fzf.zsh" ]; then
    source "$HOME/.fzf.zsh"
fi

# Custom functions
# ----------------
# Add any custom functions here

# End of .zshrc
