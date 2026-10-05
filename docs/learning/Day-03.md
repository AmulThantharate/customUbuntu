# Day 3 - Package customization

## Goal

Control which software is installed into NebulaOS.

## Learn

Package lists under `config/package-lists/` are declarative inputs to the image.

Current lists include:
- base system
- desktop
- installer

## Commands

```bash
cat config/package-lists/nebula-base.list.chroot
cat config/package-lists/nebula-desktop.list.chroot
cat config/package-lists/nebula-installer.list.chroot
./scripts/validate.sh
```

## Task

Add one small, useful package such as `htop`, `tree`, or `tmux`. Build the ISO and verify it exists in the live environment.

## Rule

Do not add every DevOps tool to the base image. Keep the base image maintainable.

## Done when

You can explain the difference between a package list and a configuration hook.
