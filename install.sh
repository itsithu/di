#!/bin/sh
set -e

BIN_DIR="$HOME/.local/bin"
SHORTCUTS="dr da di drm dun df dl dc dcl"
COMMANDS="run add install remove uninstall fmt lint cache clean"

echo "Installing di shortcuts to $BIN_DIR..."
mkdir -p "$BIN_DIR"

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

# Detect active shell
SHELL_NAME=$(basename "$SHELL")
echo "Detected shell: $SHELL_NAME"

# Determine config file to update
PROFILE_FILE=""

if [ "$SHELL_NAME" = "zsh" ]; then
  # Login or interactive?
  if [ -n "$ZSH_VERSION" ]; then
    # Interactive
    PROFILE_FILE="$HOME/.zshrc"
  else
    PROFILE_FILE="$HOME/.zprofile"
  fi
elif [ "$SHELL_NAME" = "bash" ]; then
  # Check if interactive login shell
  if shopt -q login_shell 2>/dev/null; then
    PROFILE_FILE="$HOME/.bash_profile"
  else
    PROFILE_FILE="$HOME/.bashrc"
  fi
else
  # Fallback to .profile
  PROFILE_FILE="$HOME/.profile"
fi

echo "Using profile file: $PROFILE_FILE"

# Add PATH export if not already there
if [ -f "$PROFILE_FILE" ]; then
  if ! grep -q '## added by di installer' "$PROFILE_FILE"; then
    printf '\n## added by di installer\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$PROFILE_FILE"
    echo "Added $BIN_DIR to PATH in $PROFILE_FILE"
  else
    echo "PATH already modified in $PROFILE_FILE"
  fi
else
  # Create profile file with PATH export
  echo -e "## added by di installer\nexport PATH=\"$HOME/.local/bin:\$PATH\"" > "$PROFILE_FILE"
  echo "Created $PROFILE_FILE and added PATH export"
fi

# Export PATH in current shell session to use immediately
export PATH="$HOME/.local/bin:$PATH"
echo "Exported $BIN_DIR to PATH in current shell session."

echo "Installation complete."
echo "To use shortcuts in new terminals, restart your terminal or run:"
echo "  source $PROFILE_FILE"
