#!/bin/sh
set -e

BIN_DIR="$HOME/.local/bin"
SHORTCUTS="dr da di drm dun df dl dc dcl"

echo "Removing di shortcuts from $BIN_DIR..."

for cmd in $SHORTCUTS; do
  rm -f "$BIN_DIR/$cmd"
done

# Detect active shell profile (same logic as install)
SHELL_NAME=$(basename "$SHELL")
PROFILE_FILE=""

if [ "$SHELL_NAME" = "zsh" ]; then
  if [ -n "$ZSH_VERSION" ]; then
    PROFILE_FILE="$HOME/.zshrc"
  else
    PROFILE_FILE="$HOME/.zprofile"
  fi
elif [ "$SHELL_NAME" = "bash" ]; then
  if shopt -q login_shell 2>/dev/null; then
    PROFILE_FILE="$HOME/.bash_profile"
  else
    PROFILE_FILE="$HOME/.bashrc"
  fi
else
  PROFILE_FILE="$HOME/.profile"
fi

echo "Using profile file: $PROFILE_FILE"

if [ -f "$PROFILE_FILE" ]; then
  sed -i.bak '/## added by di installer/,+1d' "$PROFILE_FILE"
  echo "Removed PATH modifications from $PROFILE_FILE"
fi

echo "Uninstallation complete."
echo "Restart your terminal to finalize."
