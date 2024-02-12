#!/bin/bash

# CPU architecture
export CPUTYPE="$(uname -m)"

# OS specific commands
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    export OSNAME="Linux"
    sudo apt install zsh
    mkdir -p ~/.config/matplotlibrc
    cp matplotlibrc ~/.config/matplotlibrc/
    # Homebrew config
    sudo mkdir -p /home/linuxbrew
    sudo chown "$(whoami)" /home/linuxbrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> $HOME/.profile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    # Instal GitHub CLI
    type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y
elif [[ "$OSTYPE" == "darwin"* ]]; then
    export OSNAME="MacOSX"
    xcode-select --install
    mkdir ~/.matplotlib
    cp matplotlibrc ~/.matplotlib
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install curl git htop wget hstr gh
fi

echo "OS name: ${OSNAME}"
echo "CPU architecture: $CPUTYPE"

# Install starship shell
curl -sS -o install_starship.sh https://starship.rs/install.sh
sudo sh install_starship.sh


# Install oh-my-zsh & plugins
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install miniconda
test -e $HOME/miniconda3 || {
    export MINICONDA_NAME="Miniconda3-latest-${OSNAME}-${CPUTYPE}.sh";
    wget "https://repo.anaconda.com/miniconda/${MINICONDA_NAME}";
    sh $MINICONDA_NAME -b; rm $MINICONDA_NAME;
}
export PATH=$HOME/miniconda3/bin:$PATH

# Login to GitHub
gh auth login

# Setup git
gh auth setup-git
git config --global user.email "valentin.perret@unity3d.com"
git config --global user.name "Valentin Perret"
git config --global push.default current

# Install poetry
curl -sSL https://install.python-poetry.org | python3 - -p

# Copy config files
cp vimrc ~/.vimrc
cp zshrc ~/.zshrc
cp condarc ~/.condarc
mkdir ~/.ipython/profile_default/ && cp python_configuration.py ~/.ipython/profile_default/

# Install Vundle & plugins
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall


# Install powerline fonts
git clone https://github.com/powerline/fonts.git --depth=1
./fonts/install.sh
rm -rf fonts

# Add zsh to shells
command -v zsh | sudo tee -a /etc/shells

# Initialize conda
conda init zsh
