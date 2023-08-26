#!/usr/bin/env bash

while [ TRUE ]
do
  eval "$@"
  echo
  echo "Watching files for changes..."
  inotifywait \
    --exclude '(\.metals/.*)|(\.git/.*)|(\..*\.swp)' \
    -e modify \
    -e close_write \
    -e moved_to \
    -e moved_from \
    -e move \
    -e move_self \
    -e create \
    -e delete \
    -e delete_self \
    -e unmount \
    -qqr .
done

