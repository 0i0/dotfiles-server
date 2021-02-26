#!/bin/sh
CMD="curl -L"
if [ -z "$CMD" ]; then
  echo "No curl available. Aborting."
else
  echo -e "\x1b[36m ______     __  __     ______     __  __     __      "
  echo -e "\x1b[32m/\x1b[36m\  __ \ \x1b[32m  /\x1b[36m\ \_\ \ \x1b[32m  /\x1b[36m\  __ \ \x1b[32m  /\x1b[36m\ \_\ \ \x1b[32m  /\x1b[36m\ \     "
  echo -e "\x1b[32m\ \x1b[36m\  __ \ \x1b[32m \ \x1b[36m\  __ \ \x1b[32m \ \x1b[36m\ \\\\\x1b[32m/\x1b[36m\ \ \x1b[32m \ \x1b[36m\____ \ \x1b[32m \ \x1b[36m\_\    "
  echo -e "\x1b[32m \ \x1b[36m\_\ \_\ \x1b[32m \ \x1b[36m\_\ \_\ \x1b[32m \ \x1b[36m\_____\ \x1b[32m \/\x1b[36m\_____\ \x1b[32m \/\x1b[36m\_\   "
  echo -e "\x1b[32m  \/_/\/_/   \/_/\/_/   \/_____/   \/_____/   \/_/   "
  echo -e ""
  echo "Installing dotfiles-server"
  mkdir -p "$HOME/dotfiles-server" && \
  eval "$CMD https://github.com/0i0/dotfiles-server/tarball/master | tar -xzv -C ~/dotfiles-server --strip-components=1 --exclude='{.gitignore}'"
  . "$HOME/dotfiles-server/setup.sh"
fi