# Day 13 — Release Validation

## Goal

Validate the ISO as a release candidate rather than only checking that it builds.

## Tasks

Test:

- ISO creation
- SHA-256 checksum
- QEMU boot
- VirtualBox boot
- BIOS/UEFI boot
- live login
- networking
- important systemd services
- base Linux commands
- DevOps commands
- user permissions
- filesystem behavior

Generate a checksum, for example:

    sha256sum ./out/*.iso

Record failures and fix them before Day 14.

## Expected result

The ISO passes the defined release checks or has a documented list of remaining issues.
