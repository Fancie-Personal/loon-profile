#!/usr/bin/env bash
# Publish Loon.conf: commit + push to the private repo, then refresh the
# secret gist that iPhone / iPad / tvOS subscribe to.
#
# Usage: ./publish.sh
set -euo pipefail
cd "$(dirname "$0")"

GIST_ID_FILE=".gist-id"
GIST_DESC="Loon profile (Fancie): DNS leak protection + tuned routing"

git add Loon.conf README.md rules plugins publish.sh .gitignore 2>/dev/null || true
if ! git diff --cached --quiet; then
  git commit -m "Update Loon config ($(date +%Y-%m-%d))"
fi
git push origin HEAD

if [ -f "$GIST_ID_FILE" ]; then
  gist_id="$(cat "$GIST_ID_FILE")"
  gh gist edit "$gist_id" --filename Loon.conf Loon.conf >/dev/null
  echo "Gist updated: $gist_id"
else
  gist_url="$(gh gist create --filename Loon.conf --desc "$GIST_DESC" Loon.conf | tail -1)"
  gist_id="${gist_url##*/}"
  printf '%s\n' "$gist_id" > "$GIST_ID_FILE"
  echo "Gist created: $gist_id"
fi

cat <<EOF

Device subscription URL:
  https://ghfast.top/https://gist.githubusercontent.com/Fancie-Personal/$gist_id/raw/Loon.conf
EOF
