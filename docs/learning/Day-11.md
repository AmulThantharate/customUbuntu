# Day 11 - Reproducible builds

## Goal

Make the repository usable by another developer on a clean Linux build host.

## Learn

- required host dependencies
- native Linux filesystems
- deterministic configuration
- clean builds
- generated artifacts versus source files

## Commands

```bash
./scripts/validate.sh
sudo ./scripts/clean.sh
sudo ./scripts/build.sh
```

## Task

Clone the repository into a clean build environment and reproduce the build without copying generated build directories from another machine.

## Done when

The build depends on documented inputs rather than hidden files in your home directory.
