/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    sudo apt install zsh git curl
    mkdir -p ~/.config/matplotlibrc
    cp matplotlibrc ~/.config/matplotlibrc/
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -b
    rm Miniconda3-latest-Linux-x86_64.sh
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir ~/.matplotlib
    cp matplotlibrc ~/.matplotlib
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
    bash Miniconda3-latest-MacOSX-x86_64.sh -b
    rm Miniconda3-latest-MacOSX-x86_64.sh
fi
cp vimrc ~/.vimrc
cp zshrc ~/.zshrc
cp condarc ~/.condarc
mkdir ~/.vscode
cd ~
# Install antigen
mkdir .antigen
curl -L git.io/antigen > .antigen/antigen.zsh
# Install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PlugInstall +qall
# Install powerline fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts
