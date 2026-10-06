# Day 5 — airootfs Customization

## Goal

Customize the filesystem that will become the live NebulaOS environment.

## Tasks

1. Inspect profile/airootfs.
2. Create required configuration directories.
3. Add NebulaOS system configuration.
4. Prepare hostname, shell defaults, and other files needed by the live environment.
5. Keep customization inside airootfs rather than modifying the builder VM.

## Commands

    cd ~/nebulaos/archbuild
    find profile/airootfs -maxdepth 3 -type f | sort

Create configuration directories when required:

    mkdir -p profile/airootfs/etc

## Expected result

NebulaOS-specific filesystem configuration is isolated inside profile/airootfs.
