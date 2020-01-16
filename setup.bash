#!/usr/bin/env bash
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

if [[ $os == 'Ubuntu' ]]; then
#    sudo add-apt-repository ppa:wireshark-dev/stable
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install git
fi

# install dotfiles
if [[ -d $HOME/.dot ]]; then
    pushd $HOME/.dot; git pull; popd
else
    git clone git@github.com:clly/dotfiles.git .dot
fi

# install packages
sudo $pkg install -y docker.io python-pip neovim vlc x264 tmux gnupg2 curl ack rsnapshot git virtualbox-qt
sudo pip install docker-compose
sudo usermod -G docker -a $(id -un)

# install rust
curl https://sh.rustup.rs -Ssf > rust-setup.sh
bash rust-setup.sh -y

# install golang


# install intellij
if [[ ! -f /var/local/idea/bin/idea.sh ]]; then
    mkdir /tmp/idea
    curl -L https://download.jetbrains.com/idea/ideaIU-2019.1.tar.gz > /tmp/idea/ideaIU-2019.1.tar.gz
    tar -C /tmp/idea -xvf /tmp/idea/*.tar.gz
    cd /tmp/idea/$(ls --hide *.tar.gz /tmp/idea)
    sudo rsync -av --progress * /var/local/idea/
    /var/local/idea/bin/idea.sh
else
    echo "idea is already installed"
fi

# install chrome
cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y --fix-broken ./google-chrome-stable_current_amd64.deb
rm -fv ./google-chrome-stable_current_amd64.deb 

# install brave
sudo apt install -y apt-transport-https curl

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

# install neovim init.vim
mkdir -p ~/.config/nvim
if [[ -f $HOME/.dot/vimrc ]]; then
    cp $HOME/.dot/vimrc ~/.config/nvim/init.vim
fi
# install ansible via docker
if ! grep -q activate $HOME/.profile; then
    echo -e "if [[ -f $HOME/.dot/activate ]]; then\n    source $HOME/.dot/activate;\nfi" >> $HOME/.profile
fi

if ! grep -q activate $HOME/.bash_profile; then
    echo -e "if [[ -f $HOME/.dot/activate ]]; then\n    source $HOME/.dot/activate;\nfi" >> $HOME/.profile
fi
