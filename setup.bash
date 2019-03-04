#!/usr/bin/env bash
set -x
set -euo pipefail

id=$(lsb_release --id)
case $id in
    *Ubuntu)
        pkg=$(which apt)
        os="Ubuntu"
        ;;
    *)
        echo "unknown os"
        exit 1
        ;;
esac

# install packages
sudo $pkg install -y docker.io python-pip neovim vlc x264 tmux gnupg2 curl ack
sudo pip install docker-compose
sudo usermod -G docker -a $(id -un)

if [[ $os == 'Ubuntu' ]]; then
    sudo add-apt-repository ppa:wireshark-dev/stable
    sudo apt-get update
fi

# install rust
#curl https://sh.rustup.rs -Ssf > rust-setup.sh
bash rust-setup.sh

# install golang


# install intellij
mkdir /tmp/idea
curl -L https://download.jetbrains.com/idea/ideaIU-2018.1.5.tar.gz > /tmp/idea/ideaIU-2018.1.5.tar.gz
tar -C /tmp/idea -xvf /tmp/idea/*.tar.gz
cd /tmp/idea/$(ls --hide *.tar.gz /tmp/idea)
sudo rsync -av --progress * /var/local/idea/
/var/local/idea/bin/idea.sh

# install chrome
cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install --fix-broken ./google-chrome-stable_current_amd64.deb

echo "if [[ -f $HOME/.dot/activate ]]; then\n    source $HOME/.dot/activate; fi" >> $HOME/.profile
