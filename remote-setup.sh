#!/usr/bin/env bash

# [[ -x `command -v wget` ]] && CMD="wget --no-check-certificate -O -"
# [[ -x `command -v curl` ]] >/dev/null 2>&1 && CMD="curl -#L"
CMD="curl -#L"
if [ -z "$CMD" ]; then
  echo "No curl or wget available. Aborting."
else
  echo "Installing dotfiles-server"
  mkdir -p "$HOME/dotfiles-server" && \
  eval "$CMD https://github.com/0i0/dotfiles-server/tarball/master | tar -xzv -C ~/dotfiles-server --strip-components=1 --exclude='{.gitignore}'"
  . "$HOME/dotfiles-server/setup.sh"
fi