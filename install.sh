#!/usr/bin/env bash
# Installs the kit's Claude Code commands (/new-project, /team-access) for the current user. Safe to re-run.
set -euo pipefail
KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CMD="$HOME/.claude/commands"
mkdir -p "$CMD" "$HOME/projects"
chmod +x "$KIT/new-project.sh"
for f in "$KIT"/user-commands/*.md; do
  sed "s|{{KIT}}|$KIT|g" "$f" > "$CMD/$(basename "$f")"
  echo "installed command: /$(basename "$f" .md)"
done
echo "kit folder:     $KIT"
echo "projects go to: $HOME/projects"
echo
echo "tools on this machine:"
for t in git gh bun psql brew; do
  if command -v "$t" >/dev/null 2>&1; then printf '  %-5s ok\n' "$t"; else printf '  %-5s MISSING\n' "$t"; fi
done
echo
echo "gh login: $(gh auth status >/dev/null 2>&1 && echo yes || echo 'not logged in (type: ! gh auth login)')"
echo "Restart Claude Code so /new-project and /team-access appear."
