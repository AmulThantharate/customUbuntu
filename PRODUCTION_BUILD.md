# NebulaOS Production Build Baseline

This branch is the production-hardening baseline for NebulaOS.

## Design rules

1. `auto/config` may call `lb config noauto`.
2. `auto/build` and `auto/clean` must not invoke the same `lb` command recursively.
3. Build orchestration lives in `scripts/`, not in `auto/`.
4. The first release is conservative: Ubuntu 24.04 Noble, amd64, XFCE, LightDM, Calamares and core networking/tooling.
5. Third-party repositories are added only after the base ISO is proven to boot and install.
6. Release artifacts are checksummed; signing keys stay outside Git.

## Required host packages

    sudo apt update
    sudo apt install -y live-build debootstrap squashfs-tools xorriso grub-pc-bin grub-efi-amd64-bin mtools dosfstools git curl gnupg shellcheck

Use a native Linux filesystem for the build directory. Avoid Windows-mounted filesystems.

## Build

    sudo sh scripts/clean.sh
    sudo sh scripts/build.sh

The wrapper calls `lb config` and `lb build` itself. It is intentionally outside `auto/`.

## Validate

    sh scripts/validate.sh

The validation script checks shell syntax and blocks the recursion patterns that previously caused the build to loop.

## Release

After boot/install testing:

    sh scripts/release.sh

This creates `SHA256SUMS`. For public releases, sign that checksum file with a release key stored outside the repository.

## Release gate

Do not label an ISO production-ready until these pass:

- BIOS boot test
- UEFI boot test
- Live desktop test
- Network test
- Package/version smoke tests
- Calamares installation test
- Installed-system reboot test
- Installed-system network test
- Non-root Docker test, if Docker is included
- Checksum verification
- Clean rebuild from a fresh checkout
