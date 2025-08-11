#!/bin/sh
set -e

# CONFIG
BIN_DIR="$HOME/.local/bin"
SHORTCUTS="dr da di drm dun df dl dc dcl"
COMMANDS="run add install remove uninstall fmt lint cache clean"
REPO_URL="https://github.com/itsithu/di"
ISSUES_URL="$REPO_URL/issues"
X_URL="https://x.com/itsithu"

# COLORS
GREEN="\033[1;32m"
CYAN="\033[1;36m"
BOLD="\033[1m"
RESET="\033[0m"

# FUNCTIONS
detect_profile() {
  # 1) interactive shell vars
  if [ -n "$ZSH_VERSION" ]; then
    echo "$HOME/.zshrc"; return
  elif [ -n "$BASH_VERSION" ]; then
    if shopt -q login_shell 2>/dev/null; then
      echo "$HOME/.bash_profile"
    else
      echo "$HOME/.bashrc"
    fi
    return
  fi

  # 2) $SHELL env
  if [ -n "$SHELL" ]; then
    case "$(basename "$SHELL")" in
      zsh)  echo "$HOME/.zshrc"; return ;;
      bash) echo "$HOME/.bashrc"; return ;;
      fish) echo "$HOME/.config/fish/config.fish"; return ;;
      ksh)  echo "$HOME/.kshrc"; return ;;
    esac
  fi

  # 3) parent process walk (works for `curl | sh`)
  pid=$$
  max_depth=10
  i=0
  while [ "$i" -lt "$max_depth" ]; do
    parent=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
    [ -z "$parent" ] && break
    cmd=$(ps -o comm= -p "$parent" 2>/dev/null | awk '{print $1}' | xargs basename)
    case "$cmd" in
      -*) cmd=$(echo "$cmd" | sed 's/^-//') ;;
    esac
    case "$cmd" in
      zsh)  echo "$HOME/.zshrc"; return ;;
      bash) echo "$HOME/.bashrc"; return ;;
      fish) echo "$HOME/.config/fish/config.fish"; return ;;
      ksh)  echo "$HOME/.kshrc"; return ;;
    esac
    pid=$parent
    i=$((i+1))
  done

  # 4) fallback
  echo "$HOME/.profile"
}

add_path_to_profile() {
  PROFILE_FILE="$1"
  case ":$PATH:" in
    *":$BIN_DIR:"*)
      echo "✅ $BIN_DIR already in PATH"
      ;;
    *)
      if ! grep -q '## added by di installer' "$PROFILE_FILE" 2>/dev/null; then
        printf '\n## added by di installer\nexport PATH="%s:$PATH"\n' "$BIN_DIR" >> "$PROFILE_FILE"
        echo "✅ Added $BIN_DIR to PATH in $PROFILE_FILE"
      else
        echo "✅ PATH already modified in $PROFILE_FILE"
      fi
      ;;
  esac
}

# INSTALL START
echo "${CYAN}📦 Installing di shortcuts to ${BOLD}$BIN_DIR${RESET}"
mkdir -p "$BIN_DIR"

# Cleanup old shortcuts
echo "🧹 Cleaning up old di shortcuts..."
for file in $SHORTCUTS di-help; do
  if [ -f "$BIN_DIR/$file" ]; then
    rm -f "$BIN_DIR/$file"
    echo "  Removed old $file"
  fi
done

# Install shortcuts
i=1
for cmd in $SHORTCUTS; do
  deno_cmd=$(echo $COMMANDS | cut -d' ' -f$i)
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

# Detect profile
PROFILE_FILE=$(detect_profile)
echo "🔍 Using profile file: $PROFILE_FILE"

# Ensure profile exists
[ -f "$PROFILE_FILE" ] || touch "$PROFILE_FILE"

# Add path if needed
add_path_to_profile "$PROFILE_FILE"

# Apply to current shell
export PATH="$BIN_DIR:$PATH"

# DONE
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
