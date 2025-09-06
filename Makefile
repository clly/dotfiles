#############################
#
#	Makefile for clly's dotfiles
#
#############################

BASHRC=bashrc
BASHPROFILE=~/.bash_profile
GITCONFIG=gitconfig
DOTGITCONFIG=~/.gitconfig
NVIMCONFIG=~/.config/nvim
GITCOMPLETION=~/.git-completion.bash
MISECONFIG=~/.config/mise/config.toml
SCRIPTDIR=~/bin/
SCRIPTDEPDIR=bin/
SCRIPTDEPS=$(wildcard bin/*)
SCRIPTS=$(wildcard ~/bin/*)
TFENVSCRIPTS=$(wildcard tfenv/bin/*)
TFENVTARGET=$(TFENVSCRIPTS:tfenv/%=%)

COPY=cp

ifneq ("$(wildcard .makefiles/*.mk)","")
	include .makefiles/*.mk
else
    $(info "no makefiles to load")
endif

include makefiles/*.mk

NVIMSENTINEL=~/.config/nvim/.installed

all: $(DOTGITCONFIG) $(NVIMSENTINEL) $(BASHPROFILE) $(GITCOMPLETION) $(MISECONFIG) $(SCRIPTS)

$(NVIMSENTINEL): $(shell find nvim/.config/nvim -type f)
	@echo "Installing Neovim configuration"
	@mkdir -p $(NVIMCONFIG)
	$(COPY) -r nvim/.config/nvim/. $(NVIMCONFIG)
	@touch $(NVIMSENTINEL)

$(DOTGITCONFIG): $(GITCONFIG)
	@echo "Moving gitconfig to ~/.gitconfig"
	$(COPY) gitconfig ~/.gitconfig

$(BASHPROFILE): bash_profile
	@echo "Copying .bash_profile to home directory"
	$(COPY) bash_profile $(BASHPROFILE)



$(GITCOMPLETION):
	@echo "Retrieving .git-completion"
	@curl -s https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash

$(MISECONFIG): .mise.toml
	@echo "Installing mise configuration"
	@mkdir -p ~/.config/mise
	$(COPY) .mise.toml ~/.config/mise/config.toml

$(SCRIPTS) : $(SCRIPTDEPS)
	if [ -f $(@:$(HOME)/%=%) ]; then \
		$(COPY) $(@:$(HOME)/%=%) $@; \
	fi
#	for script in $?; do \
# 	$(COPY) $$script $(SCRIPTDIR) ; \
#	done

bin/minikube:
	@curl -sLo bin/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64  && chmod +x bin/minikube
	@echo "Minikube installed at ~/bin/minikube"

bin/kubectl:
# install kubectl
	@curl -Lo bin/kubectl https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && chmod +x bin/kubectl
	@echo "Kubectl installed at ~/bin/kubectl"

.PHONY: update-bins
update-bins: bin/minikube bin/kubectl

.PHONY: scripts
scripts: $(SCRIPTS)

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
