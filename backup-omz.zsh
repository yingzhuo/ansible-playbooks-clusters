#!/usr/bin/env zsh

rm -rf ./.oh-my-zsh
cp -R "$HOME/.oh-my-zsh" ./.oh-my-zsh

rm -rf ./.oh-my-zsh/custom/env.zsh
rm -rf ./.oh-my-zsh/cache/*
rm -rf ./.oh-my-zsh/cache/.zsh-update

# shellcheck disable=SC2038
find ./.oh-my-zsh \
  -type l -or \
  -iname '.git*' -or \
  -iname 'LICENSE*' -or \
  -iname 'example*' -or \
  -iname 'SECURITY*' -or \
  -iname 'lantern*' |
  xargs rm -rf