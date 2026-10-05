# Day 2 - live-build lifecycle

## Goal

Understand the build pipeline before customizing it.

## Learn

```
lb config
  -> bootstrap
  -> chroot
  -> binary
  -> ISO
```

Understand the difference between configuration, package installation, chroot customization, and ISO generation.

## Commands

```bash
sudo ./scripts/clean.sh
sudo lb config
lb --version
```

Inspect the generated configuration after `lb config`.

## Task

Run configuration without starting a full build. Record which generated directories and files appear.

## Done when

You can explain why `lb config` prepares the build and `lb build` performs the actual build.
