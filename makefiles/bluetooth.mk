.PHONY: bluetooth/install-pipewire
bluetooth/install-pipewire: ## install pipewire service
	sudo add-apt-repository ppa:pipewire-debian/pipewire-upstream && \
	sudo apt update && \
	sudo apt install -y pipewire libspa-0.2-bluetooth pipewire-audio-client-libraries

.PHONY: bluetooth/enable-pipewire
bluetooth/enable-pipewire: bluetooth/install-pipewire bluetooth/disable-pulseaudio ## enable pipewire in ubuntu
	systemctl --user daemon-reload
	systemctl --user start pipewire-pulse
	systemctl --user --now enable pipewire-media-session.service pipewire-pulse
	systemctl --user restart pipewire


.PHONY: bluetooth/disable-pipewire 
bluetooth/disable-pipewire: ## disable pipewire in ubuntu
	systemctl --user stop pipewire
	systemctl --user disable pipewire-media-session.service

.PHONY: bluetooth/disable-pulseaudio
bluetooth/disable-pulseaudio: ## disable pulseaudio, usually in favor of pipewire
	systemctl --user --now disable pulseaudio.service pulseaudio.socket
	systemctl --user mask pulseaudio

.PHONY: bluetooth/enable-pulseaudio
bluetooth/enable-pulseaudio: bluetoothctl/disable-pipewire ## enable pulseaudio
	systemctl --user unmask pulseaudio
	systemctl --user --now enable pulseaudio.service pulseaudio.socket

