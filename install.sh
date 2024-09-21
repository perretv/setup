#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# CPU architecture
CPUTYPE="$(uname -m)"

# Detect OS
OS="$(uname -s)"
case "$OS" in
    Linux*)     OSNAME="Linux";;
    Darwin*)    OSNAME="MacOSX";;
    *)          echo "Unsupported OS: $OS"; exit 1;;
esac

# Map CPU architecture to expected values for Miniconda installer
if [ "$OSNAME" = "Linux" ]; then
    case "$CPUTYPE" in
        x86_64) ARCH="x86_64";;
        aarch64) ARCH="aarch64";;
        *) echo "Unsupported CPU architecture: $CPUTYPE on $OSNAME"; exit 1;;
    esac
elif [ "$OSNAME" = "MacOSX" ]; then
    case "$CPUTYPE" in
        x86_64) ARCH="x86_64";;
        arm64) ARCH="arm64";;
        *) echo "Unsupported CPU architecture: $CPUTYPE on $OSNAME"; exit 1;;
    esac
fi

echo "OS name: ${OSNAME}"
echo "CPU architecture: $CPUTYPE"

# Install necessary packages and tools
if [ "$OSNAME" = "Linux" ]; then
    # Detect package manager
    if command -v apt-get >/dev/null; then
        PM=apt-get
        sudo apt-get update
        sudo apt-get install -y zsh curl git wget build-essential procps file
    elif command -v yum >/dev/null; then
        PM=yum
        sudo yum groupinstall 'Development Tools' -y
        sudo yum install -y zsh curl git wget procps-ng which file
    elif command -v dnf >/dev/null; then
        PM=dnf
        sudo dnf groupinstall 'Development Tools' -y
        sudo dnf install -y zsh curl git wget procps-ng which file
    elif command -v pacman >/dev/null; then
        PM=pacman
        sudo pacman -Sy --noconfirm base-devel zsh curl git wget procps-ng which file
    else
        echo "Unsupported package manager"
        exit 1
    fi

    # Install Homebrew
    if ! command -v brew >/dev/null; then
        echo "Installing Homebrew..."
        set +e  # Disable 'set -e' to prevent script exit on non-zero status
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        set -e  # Re-enable 'set -e'
        # Configure Homebrew
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.profile
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    # Install GitHub CLI
    if ! command -v gh >/dev/null; then
        brew install gh
    fi

elif [ "$OSNAME" = "MacOSX" ]; then
    # Install Xcode Command Line Tools
    if ! xcode-select -p >/dev/null; then
        xcode-select --install
        # Wait until the installation is complete
        until xcode-select -p >/dev/null; do
            sleep 5
        done
    fi

    # Install Homebrew
    if ! command -v brew >/dev/null; then
        echo "Installing Homebrew..."
        set +e  # Disable 'set -e' to prevent script exit on non-zero status
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        set -e  # Re-enable 'set -e'
        # Configure Homebrew
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.profile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # Install packages via brew
    brew install curl git htop wget hstr gh zsh
else
    echo "Unsupported OS"
    exit 1
fi

# Install Starship prompt
if ! command -v starship >/dev/null; then
    echo "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    export PATH="$HOME/.local/bin:$PATH"
fi

# Install Oh My Zsh & plugins
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Zsh plugins
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# Install Miniconda
if [ ! -d "$HOME/miniconda3" ]; then
    echo "Installing Miniconda..."
    MINICONDA_NAME="Miniconda3-latest-${OSNAME}-${ARCH}.sh"
    wget "https://repo.anaconda.com/miniconda/${MINICONDA_NAME}"
    bash "$MINICONDA_NAME" -b -p "$HOME/miniconda3"
    rm "$MINICONDA_NAME"
    export PATH="$HOME/miniconda3/bin:$PATH"
else
    export PATH="$HOME/miniconda3/bin:$PATH"
fi

# Initialize Conda for Zsh
conda init zsh

# Login to GitHub
if ! gh auth status >/dev/null 2>&1; then
    gh auth login
fi

# Setup Git
gh auth setup-git
read -p "Enter your Git user.name: " GIT_USERNAME
git config --global user.name "$GIT_USERNAME"
read -p "Enter your Git user.email: " GIT_USEREMAIL
git config --global user.email "$GIT_USEREMAIL"
git config --global push.default current

# Install Poetry
if ! command -v poetry >/dev/null; then
    echo "Installing Poetry..."
    curl -sSL https://install.python-poetry.org | python3 -
    export PATH="$HOME/.local/bin:$PATH"
fi

# Copy config files (assuming they are in the same directory as the script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

copy_config_file() {
    local file=$1
    if [ -f "$SCRIPT_DIR/$file" ]; then
        cp "$SCRIPT_DIR/$file" "$HOME/.$file"
    else
        echo "$file not found in script directory"
    fi
}

copy_config_file "vimrc"
copy_config_file "zshrc"
copy_config_file "condarc"

# Copy Matplotlib configuration
if [ "$OSNAME" = "Linux" ]; then
    mkdir -p "$HOME/.config/matplotlib"
    if [ -f "$SCRIPT_DIR/matplotlibrc" ]; then
        cp "$SCRIPT_DIR/matplotlibrc" "$HOME/.config/matplotlib/"
    else
        echo "matplotlibrc not found in script directory"
    fi
elif [ "$OSNAME" = "MacOSX" ]; then
    mkdir -p "$HOME/.matplotlib"
    if [ -f "$SCRIPT_DIR/matplotlibrc" ]; then
        cp "$SCRIPT_DIR/matplotlibrc" "$HOME/.matplotlib/"
    else
        echo "matplotlibrc not found in script directory"
    fi
fi

# Copy IPython configuration
mkdir -p "$HOME/.ipython/profile_default/"
if [ -f "$SCRIPT_DIR/python_configuration.py" ]; then
    cp "$SCRIPT_DIR/python_configuration.py" "$HOME/.ipython/profile_default/"
else
    echo "python_configuration.py not found in script directory"
    touch "$HOME/.ipython/profile_default/python_configuration.py"
fi

# Install Vundle & plugins
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
    vim +PluginInstall +qall
fi

# Install Powerline fonts
if [ ! -d "$SCRIPT_DIR/fonts" ]; then
    git clone https://github.com/powerline/fonts.git --depth=1
    "$SCRIPT_DIR/fonts/install.sh"
    rm -rf "$SCRIPT_DIR/fonts"
fi

# Add Zsh to shells if not already present
if ! grep -Fxq "$(command -v zsh)" /etc/shells; then
    command -v zsh | sudo tee -a /etc/shells
fi

echo "Setup complete. Please restart your terminal."
