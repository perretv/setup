cd $HOME
mkdir .antigen
brew install zsh
curl -L git.io/antigen > .antigen/antigen.zsh
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
mv vimrc .vimrc
mv zshrc .zshrc
mv condarc .condarc
vim +PlugInstall +qall
