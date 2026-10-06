# Day 8 — ISO Testing and Debugging

## Goal

Boot and validate the first ISO before expanding it.

## Tasks

1. Boot the ISO with QEMU.
2. Check that the live system starts.
3. Check login/user access.
4. Check networking.
5. Check filesystem access.
6. Check important commands.
7. Fix failures and rebuild.

## Command

Use the ArchISO test helper when available:

    run_archiso -i ./out/*.iso

If needed, test directly with QEMU.

## Checks

    ip addr
    ip route
    systemctl --failed
    id
    uname -a

## Expected result

The base ISO boots and the fundamental Linux environment works.
