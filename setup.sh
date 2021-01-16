#!/bin/bash
set -x
sudo -v
# Ask for the administrator password upfront
killall apt apt-get

rm /var/lib/apt/lists/lock
rm /var/cache/apt/archives/lock
rm /var/lib/dpkg/lock*
# Make sure we’re using the latest repositories
apt update

apps=( 
	git
	tmux
	wget
	zsh
    vim
)
apt install -y "${apps[@]}"
# apt install python-pip python-dev build-essential

ZSH=$HOME/.oh-my-zsh
#oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

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

grep -Fq "export SHELL=zsh" $HOME/.bashrc && echo "zsh already default" || cat >> $HOME/.bashrc << EndOfMessage

if [[ \$- == *i* ]]; then
    export SHELL=zsh
    zsh -l
fi
EndOfMessage
zsh