#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT_DIR"

ISO=$(find . -maxdepth 1 -type f -name '*.iso' -print | head -n 1)
if [ -z "$ISO" ]; then
    echo "ERROR: no ISO found. Build it first." >&2
    exit 1
fi

sha256sum "$ISO" > SHA256SUMS
printf 'Release artifact: %s\n' "$ISO"
cat SHA256SUMS
