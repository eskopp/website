#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_REPO="https://github.com/tom2almighty/hugo-narrow.git"
THEME_DIR="$REPO_DIR/themes/hugo-narrow"

cd "$REPO_DIR"

tmpdir="$(mktemp -d)"
cleanup() {
  rm -rf "$tmpdir"
}
trap cleanup EXIT

tag="$(
  git ls-remote --tags --refs "$THEME_REPO" \
    | awk -F/ '{print $3}' \
    | grep -E '^v[0-9]+(\.[0-9]+)*$' \
    | sort -V \
    | tail -n1
)"

if [[ -z "${tag:-}" ]]; then
  echo "Konnte keinen Release-Tag finden."
  exit 1
fi

echo "Updating hugo-narrow to ${tag}..."

git clone --depth 1 --branch "$tag" "$THEME_REPO" "$tmpdir/hugo-narrow"
rm -rf "$tmpdir/hugo-narrow/.git"

mkdir -p "$THEME_DIR"

rsync -a --delete \
  --exclude '.git' \
  --exclude 'exampleSite/' \
  "$tmpdir/hugo-narrow/" "$THEME_DIR/"

git add "$THEME_DIR"

if git diff --cached --quiet; then
  echo "Keine Änderungen im Theme."
else
  git commit -m "Update vendored hugo-narrow theme to ${tag}"
  echo "Theme auf ${tag} aktualisiert und committet."
fi
