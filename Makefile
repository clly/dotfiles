#############################
#
#	Makefile for McSquibbly's dotfiles
#
#############################

BASHRC=./bashrc
BASHPROFILE=./bashprofile
SHELL='which bash'
RCDOT=.bashrc
PROFILEDOT=.bashprofile

all: shell profile rc install

shell: $(SHELL)
	chsh -s $(SHELL)

profile: $(PROFILE)
	
	
rc: $(BASHRC)

install: $(BASHPROFILE) $(BASHRC)
	cp $(BASHRC) $(HOME)/$(RCDOT)
	cp $(BASHPROFILE) $(HOME)/$(PROFILEDOT)