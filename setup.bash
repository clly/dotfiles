#!/usr/bin/env bash
set -x
set -euo pipefail

source os.bash
if [[ $os == 'Ubuntu' ]]; then
#    sudo add-apt-repository ppa:wireshark-dev/stable
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y git docker.io tmux gnupg2 virtualbox-qt yubico-piv-tool libykpiv-dev libpcsclite-dev openssl libssl-dev curl apt-transport-https git-lfs miller gh
    sudo usermod -G docker -a $(id -un)

    # install intellij
    echo "Installing intellij"
    if [[ ! -f /var/local/idea/bin/idea.sh ]]; then
        mkdir -p /tmp/idea
        curl -L https://download.jetbrains.com/idea/ideaIU-2024.1.2.tar.gz > /tmp/idea/idea.tar.gz
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
fi

if [[ $os == "Fedora" ]]; then
    sudo curl -O --output-dir "/etc/yum.repos.d/" https://copr.fedorainfracloud.org/coprs/pgdev/ghostty/repo/fedora-41/pgdev-ghostty-fedora-41.repo
    sudo curl -O --output-dir "/etc/pki/rpm-gpg/" https://downloads.1password.com/linux/keys/1password.asc
    sudo cp 1password.repo /etc/yum.repos.d/
    sudo curl --output-dir "/etc/yum.repos.d/" -O https://pkgs.tailscale.com/stable/rhel/9/tailscale.repo
    sudo rpm-ostree override remove firefox firefox-langpacks
    rpm-ostree refresh-md
    rpm-ostree install --idempotent tmux neovim gh gcc-c++ ghostty 1password-cli 1password tailscale treyscale
    paks=(dev.zed.Zed com.jetbrains.IntelliJ-IDEA-Ultimate org.mozilla.firefox)
    for pak in ${paks[@]}; do
        flatpak install flathub $pak
    done
    sudo rpm-ostree apply-live
fi

mkdir -p git/clly

# install rust
echo $PWD
bash rust-setup.sh -y
source $HOME/.cargo/env
cargo install starship
cargo install helix


