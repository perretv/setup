# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.profile
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.zprofile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install starship shell & utilities
brew install curl git htop starship wget zsh

# CPU architecture
export CPUTYPE="$(uname -m)"

# OS specific commands
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    export OSNAME="Linux"
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

# Install antigen
test -d ~/.antigen || {
    mkdir ~/.antigen;
    curl -L git.io/antigen > ~/.antigen/antigen.zsh;
}

# Install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +'PluginInstall --sync' +qa

# Install powerline fonts
git clone https://github.com/powerline/fonts.git --depth=1
./fonts/install.sh
rm -rf fonts
