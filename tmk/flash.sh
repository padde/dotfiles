#!/bin/bash
set -euo pipefail

BASE_DIR="$HOME/.tmk"
KEYMAP_DIR="$BASE_DIR"
DEFAULT_KEYMAP="padde"
DEFAULT_KEYBOARD="hhkb"

function say() { echo -e "[$1m$2[0m"; }

mkdir -p "$BASE_DIR"

say 33 "Installing dependencies..."

# TMK Controller sources
if [ -d "$BASE_DIR/src" ]; then
  (cd "$BASE_DIR/src" && git pull --quiet)
else
  git clone --quiet https://github.com/tmk/tmk_keyboard.git "$BASE_DIR/src"
fi
(cd "$BASE_DIR/src" && git clean -fd --quiet)

# Homebrew packages
if [ ! "$(command -v avr-gcc)" ]; then
  brew tap osx-cross/avr
  brew install avr-gcc
fi
if [ ! "$(command -v dfu-programmer)" ]; then
  brew install dfu-programmer
fi

KEYBOARD_BASE_DIR="$BASE_DIR/src/keyboard"

while true; do
  read -rp "Keyboard [$DEFAULT_KEYBOARD]: " KEYBOARD
  KEYBOARD=${KEYBOARD:-$DEFAULT_KEYBOARD}
  KEYBOARD_DIR="$KEYBOARD_BASE_DIR/$KEYBOARD"
  if [ ! -d "$KEYBOARD_DIR" ]; then
    say 31 "Unknown keyboard type. Available options:"
    find "$KEYBOARD_BASE_DIR" -type d -depth 1 -exec basename {} \; | sort | column

  else
    break;
  fi
done

while true; do
  read -rp "Keymap [$DEFAULT_KEYMAP]: " KEYMAP
  KEYMAP=${KEYMAP:-$DEFAULT_KEYMAP}
  KEYMAP_FILE="keymap_$KEYMAP.c"
  if [ ! -f "$KEYMAP_DIR/$KEYMAP_FILE" ] && [ ! -f "$KEYBOARD_DIR/$KEYMAP_FILE" ]; then
    say 31 "Keymap not found. Available options:"
    # shellcheck disable=SC2185
    find -L "$KEYMAP_DIR" "$KEYBOARD_DIR" -name "keymap_*.c" -type f -depth 1 | sed -e 's/^.*\/keymap_\(.*\).c$/\1/' | sort | column
  else
    break;
  fi
done

cd "$KEYBOARD_DIR"

if [ ! -f "$KEYMAP_FILE" ]; then
  say 33 "Moving custom keymap into place..."
  ln -s "$KEYMAP_DIR/$KEYMAP_FILE" "$KEYMAP_FILE"
fi

say 33 "Compiling firmware..."
make KEYMAP="$KEYMAP"

say 33 "Flashing firmware..."
say 31 "+--------------------------------------+"
say 31 "| PRESS RESET BUTTON TO START FLASHING |"
say 31 "+--------------------------------------+"
make dfu

say 32 "DONE! Have a nice day and don't work too hard! 🚀"
