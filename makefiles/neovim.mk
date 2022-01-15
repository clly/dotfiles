CWD := $(abspath $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST))))))
XDG_DATA_HOME ?= $(HOME)/.local/share
AUTOLOAD := $(XDG_DATA_HOME)/nvim/site/autoload/
PLUG := $(CWD)/../../.vim/autoload/plug.vim
VENDOR := $(CWD)/../vendor/plug.vim

.PHONY: neovim/vendor-plug
neovim/vendor-plug: ## download and vendor vim-plug
	@curl --location --output $(CWD)/../vendor/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

.PHONY: neovim/install-plug
neovim/install-plug: $(PLUG)

$(VENDOR): neovim/vendor-plug

$(PLUG): $(VENDOR)
	@mkdir -p $(AUTOLOAD)/
	@echo cp $<


