#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT_DIR"

if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: run as root: sudo ./scripts/build.sh" >&2
    exit 1
fi

command -v lb >/dev/null 2>&1 || {
    echo "ERROR: live-build is not installed." >&2
    exit 1
}

mkdir -p build-logs
LOG="build-logs/build-$(date -u +%Y%m%dT%H%M%SZ).log"

echo "==> NebulaOS build"
echo "    source: $ROOT_DIR"
echo "    live-build: $(lb --version)"
echo "    log: $LOG"

lb config 2>&1 | tee "$LOG"
lb build 2>&1 | tee -a "$LOG"

echo "==> Build finished"
ls -lh ./*.iso 2>/dev/null || true
