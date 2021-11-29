#!/bin/zsh

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install starship shell & utilities
brew install htop wget curl zsh starship

# OS specific commands
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    export OSNAME="Linux"
    sudo apt install zsh git curl
    mkdir -p ~/.config/matplotlibrc
    cp matplotlibrc ~/.config/matplotlibrc/
elif [[ "$OSTYPE" == "darwin"* ]]; then
    export OSNAME="MacOSX"
    xcode-select --install
    mkdir ~/.matplotlib
    cp matplotlibrc ~/.matplotlib
fi
echo "OS name: ${OSNAME}"
echo "CPU architecture: $CPUTYPE"

# Install miniforge
test -e ~/miniforge3 || {
    export MINIFORGE_NAME="Miniforge3-${OSNAME}-${CPUTYPE}.sh";
    wget "https://github.com/conda-forge/miniforge/releases/latest/download/${MINIFORGE_NAME}";
    sh $MINIFORGE_NAME -b; rm $MINIFORGE_NAME;
}

# Install poetry
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python -

# Copy config files if non-existent
test -e ~/.vimrc || cp vimrc ~/.vimrc
test -e ~/.zshrc || cp zshrc ~/.zshrc

# Install antigen
test -d ~/.antigen || {
    mkdir ~/.antigen;
    curl -L git.io/antigen > ~/.antigen/antigen.zsh;
}

# Install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PlugInstall +qall >/dev/null 2>&1

# Install powerline fonts
git clone https://github.com/powerline/fonts.git --depth=1
./fonts/install.sh
rm -rf fonts
