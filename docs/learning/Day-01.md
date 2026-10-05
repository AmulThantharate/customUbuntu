# Day 1 - Repository and live-build architecture

## Goal

Understand how the NebulaOS repository becomes a bootable Linux ISO.

## Learn

- live-build and its `lb` command
- `auto/config`
- `config/package-lists/`
- `config/hooks/`
- `config/includes.chroot/`
- build artifacts
- why `auto/build` and `auto/clean` must not recursively call themselves

## Commands

```bash
cd ~/nebulaos-build
lb --version
find auto config scripts -maxdepth 3 -type f | sort
cat auto/config
cat PRODUCTION_BUILD.md
```

## Task

Trace the path from `auto/config` to the final ISO and identify where packages, files, hooks, branding, and release checks belong.

## Done when

You can explain the purpose of `auto/`, `config/`, `scripts/`, and the generated build directories without guessing.
