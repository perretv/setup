if [[ "$OSTYPE" == "linux-gnu" ]]; then
    sudo apt install zsh git curl
    mkdir -p ~/.config/matplotlibrc
    cp matplotlibrc ~/.config/matplotlibrc/
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew  install git curl
    mkdir ~/.matplotlib
    cp matplotlibrc ~/.matplotlib
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
