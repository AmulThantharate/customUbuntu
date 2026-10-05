# Day 10 - Calamares installation testing

## Goal

Verify that the live ISO can install a working NebulaOS system.

## Flow

```
ISO
 -> live environment
 -> Calamares
 -> partitioning
 -> filesystem
 -> installed system
 -> reboot
```

## Test

Use a disposable VM disk. Verify:
- EFI boot
- partition creation
- filesystem creation
- installation completion
- first reboot
- installed networking
- installed desktop
- bootloader

## Commands after installation

```bash
uname -a
lsblk
df -h
ip addr
systemctl --failed
```

## Done when

A fresh VM can be installed from the ISO and reboot into the installed NebulaOS system.
