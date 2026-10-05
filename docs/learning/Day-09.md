# Day 9 - ISO boot testing

## Goal

Test the ISO like a distribution maintainer.

## Test matrix

- BIOS/legacy boot if supported
- UEFI boot
- live desktop
- keyboard and mouse
- display
- networking
- audio
- terminal
- shutdown
- reboot

## Commands inside the live system

```bash
uname -a
cat /etc/os-release
ip addr
systemctl --failed
df -h
```

## Task

Test the ISO in a fresh VM. Record failures instead of fixing them blindly.

## Done when

The ISO reliably reaches the live desktop and basic hardware/network functions work in the target VM.
