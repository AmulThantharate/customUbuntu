# Day 2 — ArchISO Foundation

## Goal

Understand the ArchISO profile and create the starting profile for NebulaOS.

## Tasks

1. Inspect the ArchISO example profiles.
2. Use the releng profile as the starting point.
3. Copy it into the NebulaOS Arch build directory.
4. Inspect packages.x86_64, profiledef.sh, pacman.conf, and airootfs.
5. Understand what each part controls.

## Commands

Inspect available profiles:

    ls /usr/share/archiso/configs/

Create the profile:

    mkdir -p ~/nebulaos/archbuild
    cp -r /usr/share/archiso/configs/releng ~/nebulaos/archbuild/profile

Inspect it:

    cd ~/nebulaos/archbuild
    find profile -maxdepth 2 -type f | sort

## Expected result

The NebulaOS Arch profile exists under archbuild/profile and its major files are understood.
