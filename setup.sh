#!/bin/bash
set -x
# Ask for the administrator password upfront

# Make sure we’re using the latest repositories
sudo apt update

apps=( 
	git
	tmux
	wget
	zsh
)

sudo apt install -y "${apps[@]}"
# apt install python-pip python-dev build-essential

wget https://github.com/jingweno/ccat/releases/download/v1.1.0/linux-amd64-1.1.0.tar.gz -O /tmp/ccat-linux-amd64-1.1.0.tar.gz
sudo tar -zxvf /tmp/ccat-linux-amd64-1.1.0.tar.gz -C /usr/local/bin/
sudo ln -sf /usr/local/bin/linux-amd64-1.1.0/ccat /usr/local/bin/ccat

#oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

ssh-keyscan github.com >> /tmp/githubKey
echo "$(ssh-keygen -lf /tmp/githubKey)"  >> ~/.ssh/known_hosts
# zsh-autosugesstions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

#0i0 theme
rm -rf ~/.oh-my-zsh/themes
git clone https://github.com/0i0/0i0.zsh-theme.git ~/.oh-my-zsh/themes

cd "$(dirname "${BASH_SOURCE}")"

git init

git remote add origin https://github.com/0i0/dotfiles-server.git

git fetch --all
git reset --hard origin/master

git pull --recurse-submodules origin master
git submodule update --init --recursive

echo "linking"
# Symlink dotfiles
for file in $(ls -A); do
if [ "$file" != ".git" ] && \
   [ "$file" != "setup.sh" ] && \
   [ "$file" != "remote-setup.sh" ] && \
   [ "$file" != "README.md" ] && \
   [ "$file" != "images" ]; then
    ln -sf $PWD/$file $HOME/
fi
done

cat >> $HOME/.bashrc << EndOfMessage 
if [[ \$- == *i* ]]; then
    export SHELL=zsh
    zsh -l
fi
EndOfMessage