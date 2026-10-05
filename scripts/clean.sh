#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT_DIR"

if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: run as root: sudo ./scripts/clean.sh" >&2
    exit 1
fi

lb clean --purge
rm -rf build-logs
rm -f ./*.iso ./*.img ./*.sha256
