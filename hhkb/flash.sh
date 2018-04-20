#!/bin/bash
set -euo pipefail

BASE_DIR="$HOME/.hhkb"
KEYMAP="padde"

function say() { echo -e "[$1m$2[0m"; }

mkdir -p "$BASE_DIR"

if [ -d "$BASE_DIR/src" ]; then
  say 33 "Updating sources..."
  (cd "$BASE_DIR/src" && git pull --quiet)
else
  say 33 "Downloading sources..."
  git clone --quiet https://github.com/tmk/tmk_keyboard.git "$BASE_DIR/src"
fi
(cd "$BASE_DIR/src" && git clean -fd --quiet)

KEYMAP_FILE="keymap_$KEYMAP.c"
if [ ! \( -L "$BASE_DIR/src/keyboard/hhkb/$KEYMAP_FILE" \) ]; then
  say 33 "Moving custom keymap into place..."
  ln -s "$BASE_DIR/$KEYMAP_FILE" "$BASE_DIR/src/keyboard/hhkb/$KEYMAP_FILE"
fi

say 33 "Installing dependencies..."
if [ ! "$(command -v avr-gcc)" ]; then
  brew tap osx-cross/avr
  brew install avr-gcc
fi

if [ ! "$(command -v dfu-programmer)" ]; then
  brew install dfu-programmer
fi

say 33 "Compiling firmware..."
(
  cd "$BASE_DIR/src/keyboard/hhkb"
  make KEYMAP="padde"
)

say 33 "Flashing firmware..."
say 31 "+--------------------------------------+"
say 31 "| PRESS RESET BUTTON TO START FLASHING |"
say 31 "+--------------------------------------+"
(
  cd "$BASE_DIR/src/keyboard/hhkb"
  make dfu
)

say 32 "DONE! Have a nice day and don't work too hard! 🚀"
