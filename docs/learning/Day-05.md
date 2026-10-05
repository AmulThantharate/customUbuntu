# Day 5 - Files and system customization

## Goal

Learn how files become part of the generated root filesystem.

## Learn

`config/includes.chroot/` represents files that should exist inside the target filesystem.

Useful locations include:
- `/etc/`
- `/etc/skel/`
- `/usr/local/bin/`
- application configuration directories

## Task

Design a small `nebula-info` command that prints the OS name and version. Place it in the correct include path and make it executable.

## Verify

After building:

```bash
nebula-info
cat /etc/os-release
```

## Done when

You understand the difference between files on the build host and files included in the target OS.
