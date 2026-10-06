# Day 4 — ISO Profile Configuration

## Goal

Configure the ArchISO profile and repository behavior for NebulaOS.

## Tasks

1. Review profiledef.sh.
2. Set the ISO metadata appropriate for NebulaOS.
3. Review pacman.conf.
4. Make sure the configured repositories are appropriate for the Arch builder.
5. Keep the profile reproducible and easy to understand.

## Commands

    cd ~/nebulaos/archbuild
    nano profile/profiledef.sh
    nano profile/pacman.conf

Inspect:

    sed -n '1,240p' profile/profiledef.sh
    sed -n '1,240p' profile/pacman.conf

## Expected result

The profile has explicit NebulaOS ISO configuration and a known package repository configuration.
