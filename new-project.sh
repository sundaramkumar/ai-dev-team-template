#!/usr/bin/env bash
# Kick-start a project: AI dev team + application template + knowledge wiki + requirements intake.
# Usage: new-project.sh <project-folder> [--no-wiki] [--no-app-template]
#   <project-folder>     new or existing folder (created if missing). Existing files are NEVER overwritten.
#   --no-wiki            skip the knowledge/ wiki (it is added by default)
#   --no-app-template    skip cloning the application template (repo set in app-template.conf)
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
T="$HERE/template"
W="$HERE/wiki"

usage() { sed -n '2,6p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit "${1:-1}"; }

WIKI=1; APPTPL=1; DEST=""
for a in "$@"; do
  case "$a" in
    --no-wiki) WIKI=0 ;;
    --wiki) WIKI=1 ;;
    --no-app-template) APPTPL=0 ;;
    -h|--help) usage 0 ;;
    -*) echo "Unknown option: $a" >&2; usage 1 ;;
    *) DEST="$a" ;;
  esac
done
[ -n "$DEST" ] || usage 1

mkdir -p "$DEST"
DEST="$(cd "$DEST" && pwd)"
NAME="$(basename "$DEST")"
echo "Kick-starting project in: $DEST"

copy() {  # copy <src> <dest>; never overwrite
  mkdir -p "$(dirname "$2")"
  if [ -e "$2" ]; then echo "  skip (exists): ${2#"$DEST"/}"; else cp "$1" "$2"; echo "  added:         ${2#"$DEST"/}"; fi
}
copy_tree() {  # copy_tree <src-dir> <dest-dir>
  ( cd "$1" && find . -type f ! -name .DS_Store | sort ) | while IFS= read -r f; do
    copy "$1/${f#./}" "$2/${f#./}"
  done
}

echo "[1/3] AI dev team"
NAME_ESC="$(printf '%s' "$NAME" | sed 's/[&/\]/\\&/g')"
TMP="$(mktemp)"; sed "s/{{PROJECT_NAME}}/$NAME_ESC/g" "$T/CLAUDE.md" > "$TMP"
copy "$TMP" "$DEST/CLAUDE.md"; rm -f "$TMP"
copy "$T/TASKS.md"                       "$DEST/TASKS.md"
copy "$T/docs/BRIEF.md"                  "$DEST/docs/BRIEF.md"
copy "$T/docs/REQUIREMENTS.md"           "$DEST/docs/REQUIREMENTS.md"
copy "$T/docs/requirements/.gitkeep"     "$DEST/docs/requirements/.gitkeep"
copy "$T/dot-gitignore"                  "$DEST/.gitignore"
copy_tree "$T/dot-claude"                "$DEST/.claude"

echo "[2/3] Knowledge wiki"
if [ "$WIKI" = 1 ]; then
  copy_tree "$W/knowledge"  "$DEST/knowledge"
  copy_tree "$W/dot-claude" "$DEST/.claude"
  if ! grep -q '^# Knowledge wiki' "$DEST/CLAUDE.md"; then
    cat "$W/CLAUDE.wiki.md" >> "$DEST/CLAUDE.md"; echo "  updated:       CLAUDE.md (wiki section)"
  fi
else echo "  skipped (--no-wiki)"; fi

echo "[3/3] Application template"
APP_NOTE=""
if [ "$APPTPL" = 1 ]; then
  : "${APP_TEMPLATE_REPO:=}"; : "${APP_TEMPLATE_BRANCH:=}"
  [ -f "$HERE/app-template.conf" ] && . "$HERE/app-template.conf"
  [ -n "$APP_TEMPLATE_BRANCH" ] || APP_TEMPLATE_BRANCH=main
  REPO="$APP_TEMPLATE_REPO"
  if [ -z "$REPO" ]; then
    echo "  skipped (no repo set in app-template.conf)"
  else
    TD="$(mktemp -d)"; SRC=""; SRC_NOTE=""
    export GIT_TERMINAL_PROMPT=0
    if [ -n "$REPO" ]; then
      if git clone -q --depth 1 --branch "$APP_TEMPLATE_BRANCH" "$REPO" "$TD/src" 2>/dev/null; then :
      else
        case "$REPO" in
          https://github.com/*)
            SSH="git@github.com:${REPO#https://github.com/}"
            git clone -q --depth 1 --branch "$APP_TEMPLATE_BRANCH" "$SSH" "$TD/src" 2>/dev/null || true ;;
        esac
      fi
    fi
    if [ -d "$TD/src/.git" ]; then
      SRC="$TD/src"; SRC_NOTE="$REPO@$(git -C "$TD/src" rev-parse --short HEAD) ($APP_TEMPLATE_BRANCH) cloned $(date +%F)"
      rm -rf "$TD/src/.git"
    fi
    if [ -n "$SRC" ]; then
      # the template's own CLAUDE.md must not replace ours: keep it for /app-setup to read
      if [ -f "$SRC/CLAUDE.md" ]; then
        mkdir -p "$DEST/docs"; copy "$SRC/CLAUDE.md" "$DEST/docs/APP-TEMPLATE-CLAUDE.md"; rm "$SRC/CLAUDE.md"
      fi
      # merge .gitignore lines instead of skipping them
      if [ -f "$SRC/.gitignore" ]; then
        grep -vxFf "$DEST/.gitignore" "$SRC/.gitignore" >> "$DEST/.gitignore" || true
        rm "$SRC/.gitignore"; echo "  merged:        .gitignore"
      fi
      copy_tree "$SRC" "$DEST"
      mkdir -p "$DEST/docs"; echo "$SRC_NOTE" > "$DEST/docs/.app-template-source"
      APP_NOTE="installed"
    else
      echo "  COULD NOT CLONE $REPO. Check you have access (gh auth login, or an SSH key with access to the org), then re-run (existing files are skipped):"
      echo "     $HERE/new-project.sh \"$DEST\""
      APP_NOTE="failed"
    fi
    rm -rf "$TD"
  fi
else echo "  skipped (--no-app-template)"; fi

[ -d "$DEST/.git" ] || { git init -q "$DEST" && echo "git init done"; }

cat <<MSG

Done. Next:
  1. Put the requirements in $DEST/docs/requirements/ (any format) and/or fill docs/BRIEF.md
  2. cd "$DEST" && claude
  3. Type /agents (expect tech-lead, developer, tester), then /kickoff
     (/kickoff installs the app template's software, reads the requirements, and builds TASKS.md)
MSG
[ "$APP_NOTE" = failed ] && echo "  NOTE: application template was NOT cloned - see message above."
exit 0
