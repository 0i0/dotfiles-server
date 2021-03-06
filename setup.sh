#!/bin/bash
sudo -v
sudo -l && SUDO=YES 

# Ask for the administrator password upfront
${SUDO:+"sudo"} killall apt apt-get

${SUDO:+"sudo"} rm /var/lib/apt/lists/lock
${SUDO:+"sudo"} rm /var/cache/apt/archives/lock
${SUDO:+"sudo"} rm /var/lib/dpkg/lock*

# Make sure we’re using the latest repositories
${SUDO:+"sudo"} apt update

apps=( 
	git
	tmux
	wget
	zsh
    vim
)

${SUDO:+"sudo"} apt install -y "${apps[@]}"

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

# micro
curl https://getmic.ro | bash
${SUDO:+"sudo"} mv micro /usr/local/bin/micro
mkdir -p $HOME/.config/micro/colorschemes/
curl -o $HOME/.config/micro/colorschemes/bananablueberry.micro https://raw.githubusercontent.com/0i0/banana-blueberry-themes/master/micro/bananablueberry.micro  


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
    rm ${HOME}/${file} 2&>/dev/null
    ln -sf $PWD/$file $HOME/
fi
done

# symlink .config folder
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install coreutils
    /usr/local/opt/coreutils/libexec/gnubin/cp -as $PWD/.config/ $HOME
else
    cp -as $PWD/.config/ $HOME
fi

grep -Fq "export SHELL=zsh" $HOME/.bashrc && echo "zsh already default" || cat >> $HOME/.bashrc << EndOfMessage

if [[ \$- == *i* ]]; then
    export SHELL=zsh
    zsh -l
fi
EndOfMessage

${SUDO:+"sudo"} chsh -s /bin/zsh $USER