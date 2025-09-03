#!/usr/bin/env bash
set -euo pipefail
SCRIPT="$(cd "$(dirname "$0")/../Scripts" && pwd)/ssd_bootstrap.sh"
TARGET="/tmp/test_ssd_$$"
mkdir -p "$TARGET"
DRY_RUN=1 "$SCRIPT" --target "$TARGET" >"$TARGET/out.log" 2>&1
grep -q "Bootstrap completed" "$TARGET/out.log" && echo "[ok] bootstrap smoke test passed" || { echo "[err] smoke test failed"; cat "$TARGET/out.log"; exit 1; }
rm -rf "$TARGET"
