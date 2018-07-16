#!/usr/bin/env bash

set -euo pipefail

id=$(lsb_release --id)
case $id in
    "Ubuntu")
        pkg=$(which apt)
        os="Ubuntu"
        ;;
    *)
        echo "unknown os"
        exit 1
        ;;
esac

# install packages
$pkg install -y docker.io pyton-pip neovim vlc x264 tmux
pip install docker-compose
usermod -G docker -a $(id -un)

if [[ $os == 'Ubuntu' ]]; then
    sudo add-apt-repository ppa:wireshark-dev/stable
    sudo apt-get update
fi

# install rust
curl https://sh.rustup.rs -Ssf > rust-setup.sh
bash rust-setup.sh

# install golang


# install intellij
mkdir /tmp/idea
curl -L https://download.jetbrains.com/idea/ideaIU-2018.1.5.tar.gz > /tmp/idea/ideaIU-2018.1.5.tar.gz
tar -C /tmp/idea -xvf /tmp/idea/*.tar.gz
cd /tmp/idea/$(ls -d --hide *.tar.gz *)
rsync -av --progress * /var/local/idea/
/var/local/idea/bin/idea.sh
