#!/bin/sh
# Removes the 42run command. Delete the repo folder yourself to remove everything.
rm -f "$HOME/.local/bin/42run"
echo "removed ~/.local/bin/42run"
echo "the PATH line in your shell rc (marked '# added by 42run') is harmless, remove it if you like"
