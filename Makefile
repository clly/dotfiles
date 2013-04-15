#############################
#
#	Makefile for McSquibbly's dotfiles
#
#############################

BASHRC=./bashrc
BASHPROFILE=./bashprofile
NEWSHELL='which bash'
RCDOT=.bashrc
PROFILEDOT=.bashprofile
BIN=bin

all: shell profile rc install

shell: $(NEWSHELL)
	chsh -s $(SHELL)

profile: $(PROFILE)
	
	
rc: $(BASHRC)

bin: $(HOME)/bin/*
	@cp $(BIN)/* ~/bin
	@chmod -R 700 $(HOME)/$@
	@echo "Moving binaries to ~/bin"

install: $(BASHPROFILE) $(BASHRC)
	cp $(BASHRC) $(HOME)/$(RCDOT)
	cp $(BASHPROFILE) $(HOME)/$(PROFILEDOT)
