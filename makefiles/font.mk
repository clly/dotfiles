CWD := $(abspath $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST))))))
fonts/install:
	$(CWD)/scripts/install-fonts.sh
