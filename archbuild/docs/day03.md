# Day 3 — Base NebulaOS Packages

## Goal

Define the base packages that make the Arch ISO a usable Linux system.

## Tasks

1. Edit profile/packages.x86_64.
2. Keep the base system focused on Linux, networking, shell tools, Git, SSH, and troubleshooting.
3. Review every package before adding it.
4. Avoid adding the full DevOps stack yet.

## Commands

    cd ~/nebulaos/archbuild
    nano profile/packages.x86_64

Add the required base packages and then inspect the file:

    cat profile/packages.x86_64

## Expected result

The package manifest describes the base NebulaOS environment.
