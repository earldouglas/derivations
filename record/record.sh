#!/usr/bin/env bash

set -e

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <output.gif> <duration>"
else
  OUTPUT=$1
  DURATION=$2
  XWININFO=$(xwininfo)
  read X < <(awk -F: '/Absolute upper-left X/{print $2}' <<< "$XWININFO")
  read Y < <(awk -F: '/Absolute upper-left Y/{print $2}' <<< "$XWININFO")
  read W < <(awk -F: '/Width/{print $2}' <<< "$XWININFO")
  read H < <(awk -F: '/Height/{print $2}' <<< "$XWININFO")
  W=$(($W + 2)) # Pad for XMonad window border
  H=$(($H + 2)) # Pad for XMonad window border
  byzanz-record \
    -c \
    --verbose \
    --delay=1 \
    --duration=$DURATION \
    --x=$X \
    --y=$Y \
    --width=$W \
    --height=$H \
    "$OUTPUT"
fi

