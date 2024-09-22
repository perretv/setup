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

        # Build a list of packages to install
        packages=()
        for pkg in zsh curl git wget build-essential procps file; do
            if ! dpkg -s "$pkg" >/dev/null 2>&1; then
                packages+=("$pkg")
            fi
        done

        if [ ${#packages[@]} -ne 0 ]; then
            sudo apt-get install -y "${packages[@]}"
        else
            echo "All required packages are already installed."
        fi

    elif command -v yum >/dev/null; then
        PM=yum

        # Check if Development Tools group is installed
        if ! yum groupinfo 'Development Tools' | grep -q 'Installed Groups'; then
            sudo yum groupinstall 'Development Tools' -y
        else
            echo "Development Tools group already installed."
        fi

        # Build a list of packages to install
        packages=()
        for pkg in zsh curl git wget procps-ng which file; do
            if ! rpm -q "$pkg" >/dev/null 2>&1; then
                packages+=("$pkg")
            fi
        done

        if [ ${#packages[@]} -ne 0 ]; then
            sudo yum install -y "${packages[@]}"
        else
            echo "All required packages are already installed."
        fi

    elif command -v dnf >/dev/null; then
        PM=dnf

        # Check if Development Tools group is installed
        if ! dnf group list installed | grep -q 'Development Tools'; then
            sudo dnf groupinstall 'Development Tools' -y
        else
            echo "Development Tools group already installed."
        fi

        # Build a list of packages to install
        packages=()
        for pkg in zsh curl git wget procps-ng which file; do
            if ! rpm -q "$pkg" >/dev/null 2>&1; then
                packages+=("$pkg")
            fi
        done

        if [ ${#packages[@]} -ne 0 ]; then
            sudo dnf install -y "${packages[@]}"
        else
            echo "All required packages are already installed."
        fi

    elif command -v pacman >/dev/null; then
        PM=pacman
        sudo pacman -Sy

        # Build a list of packages to install
        packages=()
        for pkg in base-devel zsh curl git wget procps-ng which file; do
            if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
                packages+=("$pkg")
            fi
        done

        if [ ${#packages[@]} -ne 0 ]; then
            sudo pacman -S --noconfirm "${packages[@]}"
        else
            echo "All required packages are already installed."
        fi

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
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.zshrc
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
        echo "Homebrew is already installed."
    fi

    # Install GitHub CLI
    if ! command -v gh >/dev/null; then
        brew install gh
    else
        echo "GitHub CLI (gh) is already installed."
    fi

elif [ "$OSNAME" = "MacOSX" ]; then
    # Install Xcode Command Line Tools
    if ! xcode-select -p >/dev/null; then
        echo "Installing Xcode Command Line Tools..."
        xcode-select --install
        # Wait until the installation is complete
        until xcode-select -p >/dev/null; do
            sleep 5
        done
    else
        echo "Xcode Command Line Tools are already installed."
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
    else
        echo "Homebrew is already installed."
    fi

    # Install packages via brew
    # Build a list of packages to install
    packages=()
    for pkg in curl git htop wget hstr gh zsh; do
        if ! brew list "$pkg" >/dev/null 2>&1 && ! brew list --cask "$pkg" >/dev/null 2>&1; then
            packages+=("$pkg")
        fi
    done

    if [ ${#packages[@]} -ne 0 ]; then
        brew install "${packages[@]}"
    else
        echo "All required brew packages are already installed."
    fi
else
    echo "Unsupported OS"
    exit 1
fi

# Install Starship prompt
if ! command -v starship >/dev/null; then
    echo "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "Starship prompt is already installed."
fi

# Install Oh My Zsh & plugins
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed."
fi

# Install Zsh plugins
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "zsh-autosuggestions plugin is already installed."
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    echo "zsh-syntax-highlighting plugin is already installed."
fi

# Install Miniconda
if ! command -v conda >/dev/null 2>&1; then
    echo "Installing Miniconda..."
    MINICONDA_NAME="Miniconda3-latest-${OSNAME}-${ARCH}.sh"
    wget "https://repo.anaconda.com/miniconda/${MINICONDA_NAME}"
    bash "$MINICONDA_NAME" -b -p "$HOME/miniconda3"
    rm "$MINICONDA_NAME"
    export PATH="$HOME/miniconda3/bin:$PATH"
else
    echo "Conda is already installed."
fi

# Ensure conda is in PATH
if ! command -v conda >/dev/null 2>&1; then
    export PATH="$HOME/miniconda3/bin:$PATH"
fi

# Login to GitHub
if ! gh auth status >/dev/null 2>&1; then
    gh auth login
else
    echo "Already logged in to GitHub CLI."
fi

# Setup Git
GIT_USERNAME="$(git config --global user.name)"
GIT_USEREMAIL="$(git config --global user.email)"
if [ -z "$GIT_USERNAME" ]; then
    read -p "Enter your Git user.name: " GIT_USERNAME
    git config --global user.name "$GIT_USERNAME"
else
    echo "Git user.name is already set to $GIT_USERNAME"
fi
if [ -z "$GIT_USEREMAIL" ]; then
    read -p "Enter your Git user.email: " GIT_USEREMAIL
    git config --global user.email "$GIT_USEREMAIL"
else
    echo "Git user.email is already set to $GIT_USEREMAIL"
fi

# Set push.default to current if not already set
GIT_PUSH_DEFAULT="$(git config --global push.default)"
if [ "$GIT_PUSH_DEFAULT" != "current" ]; then
    git config --global push.default current
    echo "Git push.default set to 'current'."
else
    echo "Git push.default is already set to 'current'."
fi

# Install Poetry
if ! command -v poetry >/dev/null; then
    echo "Installing Poetry..."
    curl -sSL https://install.python-poetry.org | python3 -
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "Poetry is already installed."
fi

# Copy config files (assuming they are in the same directory as the script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

copy_config_file() {
    local file=$1
    if [ -f "$SCRIPT_DIR/$file" ]; then
        if [ ! -f "$HOME/.$file" ]; then
            cp "$SCRIPT_DIR/$file" "$HOME/.$file"
            echo "Copied $file to $HOME/.$file"
        else
            echo "$HOME/.$file already exists. Skipping copy."
        fi
    else
        echo "$file not found in script directory"
    fi
}

copy_config_file "vimrc"
copy_config_file "zshrc"
copy_config_file "condarc"

# Copy Matplotlib configuration
if [ "$OSNAME" = "Linux" ]; then
    TARGET_DIR="$HOME/.config/matplotlib"
elif [ "$OSNAME" = "MacOSX" ]; then
    TARGET_DIR="$HOME/.matplotlib"
fi

if [ -n "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
    if [ -f "$SCRIPT_DIR/matplotlibrc" ]; then
        if [ ! -f "$TARGET_DIR/matplotlibrc" ]; then
            cp "$SCRIPT_DIR/matplotlibrc" "$TARGET_DIR/"
            echo "Copied matplotlibrc to $TARGET_DIR/"
        else
            echo "matplotlibrc already exists in $TARGET_DIR/. Skipping copy."
        fi
    else
        echo "matplotlibrc not found in script directory"
    fi
fi

# Copy IPython configuration
IPYTHON_CONFIG_DIR="$HOME/.ipython/profile_default"
mkdir -p "$IPYTHON_CONFIG_DIR"
if [ -f "$SCRIPT_DIR/python_configuration.py" ]; then
    if [ ! -f "$IPYTHON_CONFIG_DIR/python_configuration.py" ]; then
        cp "$SCRIPT_DIR/python_configuration.py" "$IPYTHON_CONFIG_DIR/"
        echo "Copied python_configuration.py to $IPYTHON_CONFIG_DIR/"
    else
        echo "python_configuration.py already exists in $IPYTHON_CONFIG_DIR/. Skipping copy."
    fi
else
    echo "python_configuration.py not found in script directory"
fi

# Install Vundle & plugins
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
    echo "Installing Vundle..."
    git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
    vim +PluginInstall +qall
else
    echo "Vundle is already installed."
    # Optionally, you can update plugins
    # vim +PluginUpdate +qall
fi

# Install Powerline fonts
if [ ! -d "$HOME/.local/share/fonts" ]; then
    echo "Installing Powerline fonts..."
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts
else
    echo "Fonts directory already exists. Skipping Powerline fonts installation."
fi

# Add Zsh to shells if not already present
ZSH_PATH="$(command -v zsh)"
if ! grep -Fxq "$ZSH_PATH" /etc/shells; then
    echo "Adding zsh to /etc/shells"
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
else
    echo "zsh is already present in /etc/shells."
fi

# Initialize Conda for Zsh
if [ -f "$HOME/.zshrc" ]; then
    if ! grep -q 'conda initialize' "$HOME/.zshrc"; then
        conda init zsh
        echo "Initialized conda for zsh."
    else
        echo "Conda is already initialized in zsh."
    fi
else
    # If .zshrc doesn't exist, run conda init zsh
    conda init zsh
    echo "Initialized conda for zsh."
fi

echo "Setup complete. Please restart your terminal."
