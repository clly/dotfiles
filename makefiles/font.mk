CWD := $(abspath $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST))))))

.PHONY: fonts/install
fonts/install:
	$(CWD)/scripts/install-fonts.sh
