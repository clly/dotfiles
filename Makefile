#############################
#
#	Makefile for McSquibbly's dotfiles
#
#############################

BASHRC=bashrc
BASHPROFILE=~/.bash_profile
NEWSHELL='which bash'
GITCONFIG=gitconfig
DOTGITCONFIG=~/.gitconfig
BINFILES := $(shell find bin -type f)
HOMEBINFILES := $(shell find ~/bin -type f)
VIMRC=~/.vimrc

all: $(DOTGITCONFIG) $(HOMEBINFILES) $(VIMRC) $(BASHPROFILE)

shell: $(NEWSHELL)
	chsh -s $(SHELL)

$(VIMRC): vimrc
	@echo "Moving vimrc to ~/.vimrc"
	@cp vimrc ~/.vimrc

$(DOTGITCONFIG): $(GITCONFIG)
	@echo "Moving gitconfig to ~/.gitconfig"
	@cp gitconfig ~/.gitconfig

$(BASHPROFILE): bash_profile
	@echo "Copying .bash_profile to home directory"
	@cp bash_profile $(BASHPROFILE)	
	
$(HOMEBINFILES): $(BINFILES)
	@echo "Copying bin to ~/bin..."
	@cp -r bin ~/
	@chmod -R 700 ~/bin
	@chown -R connor ~/bin

