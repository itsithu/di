#!/bin/sh
set -e

# CONFIG 
BIN_DIR="$HOME/.local/bin"
SHORTCUTS="dr da di drm dun df dl dc dcl di-help"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
BOLD="\033[1m"
RESET="\033[0m"

# FUNCTIONS 
detect_profile() {
  if [ -n "$ZSH_VERSION" ]; then
    echo "$HOME/.zshrc"
  elif [ -n "$BASH_VERSION" ]; then
    if shopt -q login_shell 2>/dev/null; then
      echo "$HOME/.bash_profile"
    else
      echo "$HOME/.bashrc"
    fi
  else
    shell_name=$(basename "${SHELL:-$(ps -p $$ -o comm=)}")
    case "$shell_name" in
      zsh) echo "$HOME/.zshrc" ;;
      bash) echo "$HOME/.bashrc" ;;
      *) echo "$HOME/.profile" ;;
    esac
  fi
}

remove_path_from_profile() {
  PROFILE_FILE="$1"
  if [ -f "$PROFILE_FILE" ]; then
    # Portable sed for macOS + Linux
    if sed --version >/dev/null 2>&1; then
      sed -i '/## added by di installer/,+1d' "$PROFILE_FILE"
    else
      sed -i '' '/## added by di installer/,+1d' "$PROFILE_FILE"
    fi
    echo "✅ Removed PATH modifications from $PROFILE_FILE"
  fi
}

# UNINSTALL START 
echo "${CYAN}🗑 Removing di shortcuts from ${BOLD}$BIN_DIR${RESET}"
for cmd in $SHORTCUTS; do
  if [ -f "$BIN_DIR/$cmd" ]; then
    rm -f "$BIN_DIR/$cmd"
    echo "  Removed $cmd"
  fi
done

PROFILE_FILE=$(detect_profile)
echo "🔍 Using profile file: $PROFILE_FILE"
remove_path_from_profile "$PROFILE_FILE"

echo
echo "${GREEN}✅ Uninstallation complete.${RESET}"
echo "Restart your terminal to finalize."
