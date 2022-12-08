#!/bin/bash

# CPU architecture
export CPUTYPE="$(uname -m)"

# OS specific commands
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    export OSNAME="Linux"
    sudo apt install zsh
    mkdir -p ~/.config/matplotlibrc
    cp matplotlibrc ~/.config/matplotlibrc/
elif [[ "$OSTYPE" == "darwin"* ]]; then
    export OSNAME="MacOSX"
    xcode-select --install
    mkdir ~/.matplotlib
    cp matplotlibrc ~/.matplotlib
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install curl git htop wget hstr
fi

echo "OS name: ${OSNAME}"
echo "CPU architecture: $CPUTYPE"

# Install starship shell
curl -sS https://starship.rs/install.sh | sh

# Install oh-my-zsh & plugins
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install miniforge
test -e $HOME/miniforge3 || {
    export MINIFORGE_NAME="Miniforge3-${OSNAME}-${CPUTYPE}.sh";
    wget "https://github.com/conda-forge/miniforge/releases/latest/download/${MINIFORGE_NAME}";
    sh $MINIFORGE_NAME -b; rm $MINIFORGE_NAME;
}
export PATH=$HOME/miniforge3/bin:$PATH

# Install poetry
curl -sSL https://install.python-poetry.org | python3 - -p

# Copy config files if non-existent
test -e ~/.vimrc || cp vimrc ~/.vimrc
test -e ~/.zshrc || cp zshrc ~/.zshrc
test -e ~/.condarc || cp condarc ~/.condarc

# Install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Install powerline fonts
git clone https://github.com/powerline/fonts.git --depth=1
./fonts/install.sh
rm -rf fonts

# Add zsh to shells
command -v zsh | sudo tee -a /etc/shells

# Initialize conda
conda init zsh
