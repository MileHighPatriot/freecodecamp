#!/usr/bin/env bash
# Copy freeCodeCamp "Save to GitHub" repos into labs/<name>/ and archive the leftovers.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OWNER="MileHighPatriot"
PARENT="freecodecamp"
LABS="$ROOT/labs"
mkdir -p "$LABS"

# Repos this collector must never treat as FCC labs.
skip() {
  case "$1" in
    "$PARENT"|game-of-thrones-map|scamadace-owens-exposed|summit-frame-build|texas-holdem|swedish-learn|high-country)
      return 0
      ;;
  esac
  return 1
}

imported=0
while IFS=$'\t' read -r name desc archived; do
  [ -n "$name" ] || continue
  skip "$name" && continue
  [ "$archived" = "true" ] && continue

  is_fcc=0
  printf '%s' "$desc" | grep -qi 'freecodecamp' && is_fcc=1
  if [ "$is_fcc" -eq 0 ]; then
    case "$name" in
      html-*|css-*|js-*|javascript-*|build-a-*|lab-*|workshop-*) is_fcc=1 ;;
    esac
  fi
  [ "$is_fcc" -eq 1 ] || continue

  dest="$LABS/$name"
  tmp="$(mktemp -d)"
  echo "Importing $name → labs/$name/"
  git clone --depth 1 "https://github.com/$OWNER/$name.git" "$tmp/repo"
  rm -rf "$tmp/repo/.git"
  rm -rf "$dest"
  mkdir -p "$dest"
  cp -R "$tmp/repo"/. "$dest/"
  rm -rf "$tmp"

  # Point the old repo at this folder, then archive it so it leaves the active list.
  gh repo edit "$OWNER/$name" \
    --description "Moved into $OWNER/$PARENT/labs/$name (freeCodeCamp)" \
    --homepage "https://github.com/$OWNER/$PARENT/tree/main/labs/$name" \
    >/dev/null
  gh repo archive "$OWNER/$name" --yes
  imported=$((imported + 1))
done < <(gh repo list "$OWNER" --limit 200 --json name,description,isArchived \
  --jq '.[] | [.name, (.description // ""), (.isArchived|tostring)] | @tsv')

if [ "$imported" -eq 0 ]; then
  echo "No new freeCodeCamp repos to import."
else
  echo "Imported $imported lab(s) into $LABS"
  echo "Commit and push from $ROOT when you are ready."
fi
