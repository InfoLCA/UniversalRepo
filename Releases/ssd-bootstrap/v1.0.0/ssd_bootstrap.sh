#!/usr/bin/env bash
set -euo pipefail

# NovaCore SSD Bootstrap (v1: user-space hygiene, non-destructive)
# Usage:
#   DRY_RUN=1 ./ssd_bootstrap.sh --target /Volumes/Workspace
#   ./ssd_bootstrap.sh --target /Volumes/Workspace
#
# What it does (v1):
#  - Validates target volume basics (exists, writable)
#  - Creates FAANG hygiene: .gitignore, .nova/{manifests,logs,keys,docs,archive,status}
#  - Archives macOS system folders into .nova/archive/<date> (requires sudo)
#  - Creates sentinel .NOVACORE_OK and readmes
#  - Prints a verification summary; never formats or partitions disks

TARGET=""
DRY="${DRY_RUN:-0}"
DATE_TAG="$(date +%Y-%m-%d)"
ARCHIVE_SUB=".nova/archive/${DATE_TAG}"
RED='\033[0;31m'; GRN='\033[0;32m'; YEL='\033[0;33m'; NC='\033[0m'

log(){ printf "%b[bootstrap]%b %s\n" "$YEL" "$NC" "$*" ; }
ok(){  printf "%b[ok]%b %s\n" "$GRN" "$NC" "$*" ; }
err(){ printf "%b[err]%b %s\n" "$RED" "$NC" "$*" >&2; }

run(){ if [ "$DRY" = "1" ]; then echo "DRY: $*"; else eval "$@"; fi; }

while [ $# -gt 0 ]; do
  case "$1" in
    --target) TARGET="$2"; shift 2;;
    -h|--help) sed -n '1,120p' "$0"; exit 0;;
    *) err "Unknown arg: $1"; exit 2;;
  esac
done
# shellcheck disable=SC2086

if [ -z "${TARGET}" ]; then
  err "Missing --target <path>"
  exit 2
fi

if [ ! -d "$TARGET" ]; then
  err "Target does not exist: $TARGET"
  exit 2
fi

if [ ! -w "$TARGET" ]; then
  err "Target not writable: $TARGET"
  exit 2
fi

log "Target: $TARGET"
[ "$DRY" = "1" ] && log "DRY_RUN mode enabled"

# 1) Create hygiene folders
for d in \
  "$TARGET/.nova" \
  "$TARGET/.nova/manifests" \
  "$TARGET/.nova/logs" \
  "$TARGET/.nova/keys" \
  "$TARGET/.nova/docs" \
  "$TARGET/.nova/status" \
  "$TARGET/$ARCHIVE_SUB" \
; do
  run "mkdir -p \"$d\""
done
ok "Created .nova structure"

# 2) .gitignore (FAANG macOS hygiene)
GITIGNORE_CONTENT='.DS_Store
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems'
if [ ! -f "$TARGET/.gitignore" ]; then
  run "printf '%s\n' \"$GITIGNORE_CONTENT\" > \"$TARGET/.gitignore\""
  ok "Wrote .gitignore"
else
  ok ".gitignore already present (skipped)"
fi

# 3) Sentinel & readme stubs
run "printf '%s\n' \"OK $(date -u +%FT%TZ)\" > \"$TARGET/.NOVACORE_OK\""
run "chmod 0644 \"$TARGET/.NOVACORE_OK\""
for rd in "$TARGET/.nova/README.md" "$TARGET/.nova/docs/README.md" "$TARGET/.nova/status/README.md"; do
  if [ ! -f "$rd" ]; then
    run "printf '%s\n' '# NovaCore internal area' > \"$rd\""
  fi
done
ok "Sentinel and internal READMEs prepared"

# 4) Archive macOS system folders (best-effort, requires sudo for some)
SYS_ITEMS=( ".DocumentRevisions-V100" ".Spotlight-V100" ".fseventsd" ".TemporaryItems" )
moved_any=0
for item in "${SYS_ITEMS[@]}"; do
  src="$TARGET/$item"
  if [ -e "$src" ]; then
    dest="$TARGET/$ARCHIVE_SUB/"
    if [ "$DRY" = "1" ]; then
      echo "DRY: sudo mv \"$src\" \"$dest\""
      moved_any=1
    else
      if sudo -n true 2>/dev/null || sudo -v; then
        sudo mkdir -p "$dest"
        if sudo mv "$src" "$dest" 2>/dev/null; then
          ok "Archived $item -> $ARCHIVE_SUB/"
          moved_any=1
        else
          err "Could not move $item (permissions locked by macOS). Safe to leave."
        fi
      else
        err "sudo not available; skipping $item"
      fi
    fi
  fi
done
[ "$moved_any" = 1 ] && ok "System folders archived (where possible)"

# 5) Summary / verification
echo "---- SUMMARY ----"
echo "Target: $TARGET"
echo "DRY_RUN: $DRY"
echo "Created: $TARGET/.nova/* and $TARGET/$ARCHIVE_SUB if needed"
echo "Sentinel: $TARGET/.NOVACORE_OK"
echo "Ignore file: $TARGET/.gitignore"
echo "-----------------"

# 6) Post-check hints
echo "Next checks:"
echo "  find \"$TARGET/.nova\" -type d | wc -l"
echo "  ls -la \"$TARGET\" | head -30"
echo "  test -f \"$TARGET/.NOVACORE_OK\" && echo OK_sentinel"

ok "Bootstrap completed."
