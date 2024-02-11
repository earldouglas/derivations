#!/usr/bin/env bash

shopt -s nullglob globstar

prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_files=( "$prefix"/**/*.gpg )
password_files=( "${password_files[@]#"$prefix"/}" )
password_files=( "${password_files[@]%.gpg}" )

password=$(printf '%s\n' "${password_files[@]}" | dmenu "$@")

[[ -n $password ]] || exit

if [[ "$password" == */2fa ]]
then
  pass show "$password" 2>/dev/null | xargs oathtool --totp -b | xargs | xclip -i -sel clipboard
else
  pass show -c "$password" 2>/dev/null
fi
