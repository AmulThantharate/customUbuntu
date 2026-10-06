# Day 1 — Arch Builder Setup

## Goal

Prepare the Arch Linux builder VM that will be used to build NebulaOS with ArchISO.

## Tasks

1. Create the Arch Linux builder VM with VirtualBox/Vagrant.
2. Boot into Arch Linux.
3. Update the system.
4. Install the ArchISO and testing tools.
5. Verify that the build tools work.
6. Create the Arch NebulaOS workspace.

## Commands

Update Arch:

    sudo pacman -Syu

Install build and test tools:

    sudo pacman -S --needed archiso git qemu-desktop

Verify:

    mkarchiso -h
    qemu-system-x86_64 --version
    git --version

Create the workspace:

    mkdir -p ~/nebulaos/archbuild
    cd ~/nebulaos/archbuild

## Expected result

The Arch builder VM is ready and mkarchiso runs successfully.

## Do not do yet

Do not customize packages, branding, or DevOps tooling on Day 1. Those are handled on later days.
