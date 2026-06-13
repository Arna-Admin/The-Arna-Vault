#!/usr/bin/env bash
set -euo pipefail

VAULT_DIR="$HOME/storage/shared/Documents/Obsidian/The-Arna-Vault"

echo "=== [1/3] Verifying Local IPFS Daemon Process ==="
if ! ipfs id &>/dev/null; then
    echo "CRITICAL ERROR: IPFS subsystem offline."
    echo "Action Required: Start the daemon inside Window 2."
    exit 1
fi

echo "=== [2/3] Logging Local Git Version Snapshot ==="
cd "$VAULT_DIR"
git add .
if ! git diff --cached --quiet; then
    git commit -m "Vault Sync Pipeline: $(date +'%Y-%m-%d %H:%M:%S')"
else
    echo "No modifications detected. Skipping history inflation."
fi

echo "=== [3/3] Compiling and Pinning Clean Directory Tree ==="
RAW_HASH=$(ipfs add -r -Q \
  --cid-version=1 \
  --raw-leaves=true \
  --ignore=".git" \
  --ignore="node_modules" \
  --ignore="build_broadcast.sh" \
  --ignore=".obsidian" \
  --ignore=".trash" \
  --ignore="package.json" \
  --ignore="package-lock.json" \
  "$VAULT_DIR")

if [ -z "$RAW_HASH" ]; then
    echo "CRITICAL BUILD ERROR: IPFS engine returned an empty token."
    exit 1
fi

ipfs cid format -b base32 "$RAW_HASH" >/dev/null
ipfs pin add "$RAW_HASH" >/dev/null

echo "=== Accelerating Content Route Propagation Across Swarm ==="
ipfs routing provide "$RAW_HASH" >/dev/null 2>&1 || true

echo "======================================================================="
echo "                         BROADCAST COMPLETE                            "
echo "======================================================================="
echo "Sterilized Folder CIDv1: ${RAW_HASH}"
echo "-----------------------------------------------------------------------"
echo "Local Device Loopback:   http://127.0.0.1:8080/ipfs/${RAW_HASH}/"
echo "Public Gateway Proxy 1:  https://dweb.link/ipfs/${RAW_HASH}/"
echo "Public Gateway Proxy 2:  https://ipfs.io/ipfs/${RAW_HASH}/"
echo "======================================================================="
