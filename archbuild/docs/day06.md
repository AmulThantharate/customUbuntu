# Day 6 — Users, systemd, Networking and SSH

## Goal

Make the live environment practical and secure for DevOps work.

## Tasks

1. Configure the default user and sudo access.
2. Configure NetworkManager.
3. Configure SSH where appropriate.
4. Enable required systemd services through the profile.
5. Review permissions and avoid unnecessary root access.
6. Verify the resulting configuration before building.

## Commands

Inspect the systemd-related profile content:

    find profile/airootfs/etc/systemd -type f 2>/dev/null | sort

Inspect user configuration:

    find profile/airootfs/etc -maxdepth 3 -type f | sort

## Expected result

The live system has a deliberate user, networking, service, and permission configuration.
