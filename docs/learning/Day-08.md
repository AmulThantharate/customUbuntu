# Day 8 - Boot and NebulaOS branding

## Goal

Create the full NebulaOS identity from power-on through login.

## Branding chain

```
Firmware
  -> GRUB / boot menu
  -> boot splash
  -> Linux kernel
  -> LightDM
  -> XFCE desktop
  -> About / OS information
```

## Learn

- GRUB menu labels
- ISO volume label
- Plymouth or equivalent splash configuration
- `/etc/os-release`
- LightDM branding
- desktop branding
- Calamares branding

## Important

Do not blindly replace every occurrence of Ubuntu. Ubuntu is the upstream distribution and package ecosystem; branding must not break package management or diagnostics.

## Task

Make the visible product identity say NebulaOS where appropriate and verify:

```bash
cat /etc/os-release
```

Then boot the ISO and observe every stage.

## Done when

A user can recognize NebulaOS from boot menu through desktop without compromising the underlying Ubuntu package ecosystem.
