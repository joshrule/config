# based on https://github.com/lucasem/config/blob/master/Makefile

files: sh vim
	cp tmux.conf ~/.tmux.conf

vim:
	mkdir -p ~/.config/vim/
	cp vimrc ~/.config/vim/vimrc

sh:
	cp profile ~/.profile
	cp bash_profile ~/.bash_profile
	cp bashrc ~/.bashrc
	source ~/.bash_profile
