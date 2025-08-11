#!/bin/sh
set -e

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Vars
BIN_DIR="$HOME/.local/bin"
SHORTCUTS="dr dt da di drm dun df dl dc dcl di-help"

# Detect shell profile
SHELL_NAME=$(basename "$SHELL")
case "$SHELL_NAME" in
  zsh)  PROFILE_FILE="$HOME/.zshrc" ;;
  bash) PROFILE_FILE="$HOME/.bashrc" ;;
  fish) PROFILE_FILE="$HOME/.config/fish/config.fish" ;;
  *)    PROFILE_FILE="$HOME/.profile" ;;
esac

# Remove shortcuts
echo "${CYAN}🗑 Removing di shortcuts from ${BOLD}$BIN_DIR${RESET}"
for cmd in $SHORTCUTS; do
  if [ -f "$BIN_DIR/$cmd" ]; then
    rm -f "$BIN_DIR/$cmd"
    echo "  Removed $cmd"
  fi
done

# Remove PATH entry
if [ -f "$PROFILE_FILE" ]; then
  # Portable sed for macOS + Linux
  if sed --version >/dev/null 2>&1; then
    sed -i '/# added by di installer/,+1d' "$PROFILE_FILE"
  else
    sed -i '' '/# added by di installer/,+1d' "$PROFILE_FILE"
  fi
  echo "✅ Removed PATH modifications from $PROFILE_FILE"
fi

# Done
echo
echo "${GREEN}✅ Uninstallation complete.${RESET}"
echo "Restart your terminal to finalize."
