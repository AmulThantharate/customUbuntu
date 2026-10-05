#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT_DIR"

fail=0

check_file() {
    if [ ! -f "$1" ]; then
        echo "MISSING: $1"
        fail=1
    fi
}

check_file auto/config
check_file config/package-lists/nebula-base.list.chroot
check_file config/package-lists/nebula-desktop.list.chroot
check_file config/package-lists/nebula-installer.list.chroot

for f in auto/config scripts/*.sh; do
    [ -f "$f" ] || continue
    if ! sh -n "$f"; then
        echo "SHELL SYNTAX ERROR: $f"
        fail=1
    fi
done

if grep -R --line-number --fixed-strings 'lb build' auto 2>/dev/null; then
    echo "ERROR: auto/ must not recursively invoke lb build."
    fail=1
fi

if grep -R --line-number --fixed-strings 'lb clean' auto 2>/dev/null; then
    echo "ERROR: auto/ must not recursively invoke lb clean."
    fail=1
fi

if grep -R --line-number --fixed-strings -- '--bootloaders' auto 2>/dev/null; then
    echo "ERROR: unsupported bootloader override found in auto/config."
    fail=1
fi

exit "$fail"
