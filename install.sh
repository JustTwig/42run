#!/bin/sh
# Installs 42run into ~/.local/bin (no sudo needed).
set -e

DIR=$(cd "$(dirname "$0")" && pwd)
BIN="$HOME/.local/bin"

command -v python3 >/dev/null 2>&1 || { echo "install: python3 is required"; exit 1; }
command -v cc >/dev/null 2>&1 || echo "install: warning, no 'cc' found (needed at runtime)"

chmod +x "$DIR/42run"
mkdir -p "$BIN"
ln -sf "$DIR/42run" "$BIN/42run"
echo "linked $BIN/42run -> $DIR/42run"

case ":$PATH:" in
	*":$BIN:"*) ;;
	*)
		LINE='export PATH="$HOME/.local/bin:$PATH"'
		for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
			if [ -f "$rc" ] && ! grep -qF "$LINE" "$rc"; then
				printf '\n# added by 42run\n%s\n' "$LINE" >> "$rc"
				echo "added ~/.local/bin to PATH in $rc"
			fi
		done
		echo "open a new terminal (or 'hash -r') to use 42run"
		;;
esac

command -v norminette >/dev/null 2>&1 || echo "note: norminette not found, the style report will be skipped"
echo "done. try: 42run --help"
