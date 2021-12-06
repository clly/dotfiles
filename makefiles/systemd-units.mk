KEYS_SERVICE=~/.config/systemd/user/authorized_keys.service
KEYS_TIMER=~/.config/systemd/user/authorized_keys.timer
CWD := $(abspath $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST))))))

.PHONY: keys/install
keys/install: $(KEYS_SERVICE) $(KEYS_TIMER)
	systemctl --user daemon-reload
	systemctl --user enable authorized_keys.timer
	systemctl --user enable authorized_keys.service
	touch ~/.config/keys.env
	systemctl --user restart authorized_keys.timer

.PHONY: keys/uninstall
keys/uninstall:
	systemctl --user stop authorized_keys.timer
	systemctl --user disable authorized_keys.timer
	systemctl --user disable authorized_keys.service
	@rm -v $(KEYS_SERVICE)
	@rm -v $(KEYS_TIMER)
	systemctl --user daemon-reload


$(KEYS_SERVICE): $(CWD)/../config/systemd/authorized_keys.service
	# $< is the first prerequisite
	# $@ is the filename of the target of the rule
	cp $< $@
	systemctl --user daemon-reload

$(KEYS_TIMER): $(CWD)/../config/systemd/authorized_keys.timer
	cp $< $@
	systemctl --user daemon-reload
