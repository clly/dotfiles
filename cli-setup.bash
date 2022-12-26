#!/usr/bin/env bash

set -eEof pipefail
source os.bash
if [[ $os == 'Ubuntu' ]]; then
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add -
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list

    # docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

    sudo apt update
    sudo apt install -y make neovim tailscale build-essential libssl-dev pkg-config nomad docker-ce docker-ce-cli containerd.io shellcheck
    
    sudo usermod -G docker -a $(id -un)
    sudo tailscale up
fi

# install dotfiles
if [[ -d $HOME/.dot ]]; then
    pushd $HOME/.dot; git pull; popd
else
    git clone git@github.com:clly/dotfiles.git .dot
fi


curl https://sh.rustup.rs -Ssf > rust-setup.sh
bash rust-setup.sh -y

source $HOME/.cargo/env
cargo install starship

mkdir -p ~/.config/nvim
if [[ -f $HOME/.dot/vimrc ]]; then
    cp $HOME/.dot/vimrc ~/.config/nvim/init.vim
fi


if [[ -f $HOME/.bash_profile ]]; then
    echo -e "if [[ -f $HOME/.dot/activate ]]; then\n    source $HOME/.dot/activate;\nfi" >> $HOME/.bash_profile
elif ! grep -q activate $HOME/.profile; then
    echo -e "if [[ -f $HOME/.dot/activate ]]; then\n    source $HOME/.dot/activate;\nfi" >> $HOME/.profile
fi


