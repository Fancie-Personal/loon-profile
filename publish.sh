#!/usr/bin/env bash
# Publish Loon.conf: commit + push, refresh the jsDelivr cache that iPhone /
# iPad / tvOS subscribe to, and keep the Gist and iCloud copies in sync.
#
# Usage: ./publish.sh
set -euo pipefail
cd "$(dirname "$0")"

GIST_ID_FILE=".gist-id"
GIST_DESC="Loon profile (Fancie): DNS leak protection + tuned routing"
JSDELIVR_URL="https://cdn.jsdelivr.net/gh/Fancie-Personal/loon-profile@main/Loon.conf"

git add Loon.conf README.md rules plugins scripts publish.sh .gitignore 2>/dev/null || true
if ! git diff --cached --quiet; then
  git commit -m "Update Loon config ($(date +%Y-%m-%d))"
fi
git push origin HEAD

# jsDelivr caches branch refs, so purge it to get the new revision out quickly.
for resource in Loon.conf plugins/domestic-dns.plugin; do
  if curl -sSf -m 30 "https://purge.jsdelivr.net/gh/Fancie-Personal/loon-profile@main/$resource" >/dev/null; then
    echo "jsDelivr cache purged: $resource"
  else
    echo "jsDelivr purge failed: $resource (the cache expires by itself)"
  fi
done

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

Device subscription URL (primary):
  $JSDELIVR_URL
  ${JSDELIVR_URL/cdn.jsdelivr.net/fastly.jsdelivr.net}

Backup:
  https://gist.githubusercontent.com/Fancie-Personal/$gist_id/raw/Loon.conf
EOF

# Copy for 从文件导入 on iPhone / iPad (no GitHub needed).
icloud_dir="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Loon"
if [ -d "$HOME/Library/Mobile Documents/com~apple~CloudDocs" ]; then
  mkdir -p "$icloud_dir"
  cp Loon.conf "$icloud_dir/Loon-iCloud.conf"
  echo "iCloud Drive copy: $icloud_dir/Loon-iCloud.conf"
fi

