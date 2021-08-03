#############################
#
#	Makefile for McSquibbly's dotfiles
#
#############################

BASHRC=bashrc
BASHPROFILE=~/.bash_profile
GITCONFIG=gitconfig
DOTGITCONFIG=~/.gitconfig
VIMRC=~/.config/nvim/init.vim
GITCOMPLETION=~/.git-completion.bash
SCRIPTDIR=~/bin/
SCRIPTDEPDIR=bin/
SCRIPTDEPS=$(wildcard bin/*)
SCRIPTS=$(wildcard ~/bin/*)
TFENVSCRIPTS=$(wildcard tfenv/bin/*)
TFENVTARGET=$(TFENVSCRIPTS:tfenv/%=%)

COPY=cp

all: $(DOTGITCONFIG) $(VIMRC) $(BASHPROFILE) $(GITCOMPLETION) $(SCRIPTS)

$(VIMRC): vimrc
	@mkdir -p ~/.config/nvim
	@echo "Moving vimrc to ~/.config/nvim/init.vim"
	$(COPY) vimrc $(VIMRC)

$(DOTGITCONFIG): $(GITCONFIG)
	@echo "Moving gitconfig to ~/.gitconfig"
	$(COPY) gitconfig ~/.gitconfig

$(BASHPROFILE): bash_profile
	@echo "Copying .bash_profile to home directory"
	$(COPY) bash_profile $(BASHPROFILE)	



$(GITCOMPLETION): 
	@echo "Retrieving .git-completion"
	@curl -s https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash

$(SCRIPTS) : $(SCRIPTDEPS)
	$(COPY) -r $(SCRIPTDEPDIR)* $(SCRIPTDIR)


bin/minikube:
	@curl -sLo bin/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64  && chmod +x bin/minikube
	@echo "Minikube installed at ~/bin/minikube"

bin/kubectl:
# install kubectl
	@curl -Lo bin/kubectl https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && chmod +x bin/kubectl
	@echo "Kubectl installed at ~/bin/kubectl"

.PHONY: update-bins
update-bins: bin/minikube bin/kubectl

.PHONY: terraform
terraform: $(TFENVTARGET)

$(TFENVTARGET): $(TFENVSCRIPTS)
	@ln -s ../tfenv/$@ $@

#$(TFENVTARGET): $(TFENVSCRIPTS)
#	echo $(COPY) $? bin/

.PHONY: $(GITCOMPLETION)

.PHONY: testvars
testvars:
	@echo $(SCRIPTS)
	@echo $(SCRIPTDEPS)
