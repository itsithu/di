#!/bin/sh
set -e

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Vars
BIN_DIR="$HOME/.local/bin"
SHORTCUTS="dr da di drm dun df dl dc dcl"
COMMANDS="run add install remove uninstall fmt lint cache clean"
REPO_URL="https://github.com/itsithu/di"
ISSUES_URL="https://github.com/itsithu/di/issues"
X_URL="https://x.com/itsithu"

echo "📦 Installing di shortcuts to $BIN_DIR..."
mkdir -p "$BIN_DIR"

# Clean up old shortcuts
echo "🧹 Cleaning up old di shortcuts..."
for cmd in $SHORTCUTS di-help; do
  if [ -f "$BIN_DIR/$cmd" ]; then
    rm -f "$BIN_DIR/$cmd"
    echo "  Removed old $cmd"
  fi
done

# Install shortcuts
i=1
for cmd in $SHORTCUTS; do
  deno_cmd=$(echo "$COMMANDS" | cut -d' ' -f"$i")
  cat > "$BIN_DIR/$cmd" <<EOF
#!/bin/sh
deno $deno_cmd "\$@"
EOF
  chmod +x "$BIN_DIR/$cmd"
  i=$((i+1))
done

# Install di-help
cat > "$BIN_DIR/di-help" <<'EOF'
#!/bin/sh
cat <<HELP
di — Tiny CLI wrapper for Deno commands
---------------------------------------
Shortcuts:
  dr    → deno run
  da    → deno add
  di    → deno install
  drm   → deno remove
  dun   → deno uninstall
  df    → deno fmt
  dl    → deno lint
  dc    → deno cache
  dcl   → deno clean

Project:
  GitHub: https://github.com/itsithu/di
  Issues: https://github.com/itsithu/di/issues
  Author: @itsithu (X/Twitter)
HELP
EOF
chmod +x "$BIN_DIR/di-help"

# Detect shell profile
SHELL_NAME=$(basename "$SHELL")
case "$SHELL_NAME" in
  zsh)  PROFILE_FILE="$HOME/.zshrc" ;;
  bash) PROFILE_FILE="$HOME/.bashrc" ;;
  fish) PROFILE_FILE="$HOME/.config/fish/config.fish" ;;
  *)    PROFILE_FILE="$HOME/.profile" ;;
esac

echo "🔍 Using profile file: $PROFILE_FILE"

# Add PATH if not already present
if [ ! -f "$PROFILE_FILE" ] || ! grep -q '## added by di installer' "$PROFILE_FILE"; then
  printf '\n# added by di installer\nexport PATH="%s:$PATH"\n' "$BIN_DIR" >> "$PROFILE_FILE"
  echo "✅ Added $BIN_DIR to PATH in $PROFILE_FILE"
else
  echo "✅ PATH already modified in $PROFILE_FILE"
fi

# Export PATH for current session
export PATH="$BIN_DIR:$PATH"

# Done
echo
echo "${GREEN}✨ Installation complete!${RESET}"
echo "${BOLD}Installed commands:${RESET}"
for cmd in $SHORTCUTS; do echo "  $cmd"; done
echo "  di-help"
echo
echo "${BOLD}Next steps:${RESET}"
echo "  - Restart your terminal or run: ${CYAN}source $PROFILE_FILE${RESET}"
echo "  - Run ${CYAN}di-help${RESET} to see all shortcuts"
echo
echo "${BOLD}Project links:${RESET}"
echo "  GitHub:  $REPO_URL"
echo "  Issues:  $ISSUES_URL"
echo "  Follow:  $X_URL"
