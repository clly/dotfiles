#############################
#
#	Makefile for McSquibbly's dotfiles
#
#############################

BASHRC=bashrc
BASHPROFILE=~/.bash_profile
GITCONFIG=gitconfig
DOTGITCONFIG=~/.gitconfig
VIMRC=~/.vimrc
GITCOMPLETION=~/.git-completion.bash

all: $(DOTGITCONFIG) $(VIMRC) $(BASHPROFILE) $(GITCOMPLETION)

$(VIMRC): vimrc
	@echo "Moving vimrc to ~/.vimrc"
	@cp vimrc ~/.vimrc

$(DOTGITCONFIG): $(GITCONFIG)
	@echo "Moving gitconfig to ~/.gitconfig"
	@cp gitconfig ~/.gitconfig

$(BASHPROFILE): bash_profile
	@echo "Copying .bash_profile to home directory"
	@cp bash_profile $(BASHPROFILE)	

$(GITCOMPLETION): 
	@echo "Retrieving .git-completion"
	@curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash

.PHONY: $(GITCOMPLETION)
