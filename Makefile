#############################
#
#	Makefile for McSquibbly's dotfiles
#
#############################

BASHRC=./bashrc
BASHPROFILE=./bashprofile
NEWSHELL='which bash'
GITCONFIG=.gitconfig
PROFILEDOT=.bash_profile
BIN=bin

all: shell profile rc install gitconfig

shell: $(NEWSHELL)
	chsh -s $(SHELL)

profile: $(PROFILE)
	@cp gitconfig ~/.gitconfig
	
	
rc: $(BASHRC)

bin: $(HOME)/bin/*
	@cp $(BIN)/* ~/bin
	@chmod -R 700 ~/$@
	@echo "Moving binaries to $(HOME)/bin"

install: $(BASHPROFILE)
	cp $(BASHPROFILE) ~/$(PROFILEDOT)
