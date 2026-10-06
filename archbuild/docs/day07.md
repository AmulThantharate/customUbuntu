# Day 7 — First Arch NebulaOS ISO

## Goal

Build the first bootable NebulaOS Arch ISO.

## Tasks

1. Create the output directory.
2. Build with mkarchiso.
3. Read the build output.
4. Fix only real build errors.
5. Record the generated ISO name and size.

## Command

From archbuild:

    cd ~/nebulaos/archbuild
    mkdir -p out
    sudo mkarchiso -v -w /tmp/nebulaos-arch-work -o ./out ./profile

Inspect the result:

    ls -lh out/

## Expected result

A bootable NebulaOS Arch ISO is produced.

## Important

Do not add DevOps tooling yet. First get the base ISO building successfully.
