#!/usr/bin/env bash
# Instala las skills de este repo en ~/.claude/skills (Mac/Linux/Git Bash)
set -euo pipefail
REPO="$(cd "$(dirname "$0")" && pwd)"
TARGET="$HOME/.claude/skills"
mkdir -p "$TARGET"

# 1. Skills locales
for d in "$REPO"/skills/*/; do
  name="$(basename "$d")"
  rm -rf "$TARGET/$name"
  cp -r "$d" "$TARGET/$name"
  echo "OK  $name"
done

# 2. Skills de repos externos
clone_or_pull() {
  if [ -d "$TARGET/$1/.git" ]; then git -C "$TARGET/$1" pull --ff-only
  else git clone --single-branch --depth 1 "$2" "$TARGET/$1"; fi
  echo "OK  $1 (git)"
}
clone_or_pull gstack     https://github.com/garrytan/gstack.git
clone_or_pull n8n-skills https://github.com/czlonkowski/n8n-skills.git
(cd "$TARGET/gstack" && ./setup) || echo "WARN: gstack setup fallo, correlo a mano"

echo; echo "Listo. Reinicia Claude Code para que tome las skills."
