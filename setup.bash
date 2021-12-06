#!/usr/bin/env bash
set -euo pipefail

source os.bash
if [[ $os == 'Ubuntu' ]]; then
#    sudo add-apt-repository ppa:wireshark-dev/stable
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y git docker.io tmux gnupg2 virtualbox-qt yubico-piv-tool libykpiv-dev libpcsclite-dev openssl libssl-dev curl apt-transport-https shellcheck
fi


sudo usermod -G docker -a $(id -un)
mkdir -p git/clly
#git clone git@github.com:clly/dockerfiles.git git/clly/dockerfiles
#newgrp docker #<<<EOF
#source git/clly/dockerfiles/ansible/scripts.sh
#ansible-playbook -i $HOME/.dot/setup_tasks/hosts $HOME/.dot/setup_tasks/local.yml -K
#EOF

# install intellij
echo "Installing intellij"
if [[ ! -f /var/local/idea/bin/idea.sh ]]; then
    mkdir -p /tmp/idea
    curl -L https://download.jetbrains.com/idea/ideaIU-2021.1.tar.gz > /tmp/idea/ideaIU-2021.1.tar.gz
    tar -C /tmp/idea -xvf /tmp/idea/*.tar.gz
    cd /tmp/idea/$(ls --hide *.tar.gz /tmp/idea)
    sudo rsync -av --progress * /var/local/idea/
    /var/local/idea/bin/idea.sh
else
    echo "idea is already installed"
fi

# install chrome
echo "Install google chrome"
if [ dpkg -l google-chrome-stable>/dev/null ]; then
    cd /tmp
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y --fix-broken ./google-chrome-stable_current_amd64.deb
    rm -fv ./google-chrome-stable_current_amd64.deb
fi

if [ dpkg -l keybase>/dev/null ]; then
    curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
    sudo apt install -y ./keybase_amd64.deb
    run_keybase &
fi

# install brave

curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -

echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update

sudo apt install -y brave-browser

# install visual studio code
wget https://go.microsoft.com/fwlink/?LinkID=760868 -O visual-studio-code.deb
sudo apt install -y --fix-broken ./visual-studio-code.deb
rm -fv ./visual-studio-code.deb

mkdir -p ~/bin
# install minikube
curl -sLo ~/bin/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x ~/bin/minikube
echo "Minikube installed at ~/bin/minikube"

# install kubectl
curl -Lo ~/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
  && chmod +x ~/bin/kubectl
echo "Kubectl installed at ~/bin/kubectl"

# install rust
echo $PWD
bash rust-setup.sh -y
source $HOME/.cargo/env
cargo install starship

