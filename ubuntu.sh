cp vimrc .vimrc
cp zshrc .zshrc
cp condarc .condarc
cd $HOME
mkdir .antigen
sudo apt install zsh
curl -L git.io/antigen > .antigen/antigen.zsh
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PlugInstall +qall
