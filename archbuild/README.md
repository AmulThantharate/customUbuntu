# NebulaOS Arch Build

This directory contains the Arch Linux based NebulaOS build track.

The existing repository root remains the Ubuntu/live-build implementation. The Arch implementation is intentionally isolated under `archbuild/` so the two build systems do not interfere with each other.

## Goal

Build and understand a custom Arch Linux based NebulaOS ISO in 14 days using **archiso** and **mkarchiso**.

The target is a real bootable live ISO, not only a tutorial exercise.

## Build architecture

```
archbuild/
├── README.md
├── profile/
│   ├── packages.x86_64
│   ├── profiledef.sh
│   ├── pacman.conf
│   └── airootfs/
├── scripts/
│   ├── build.sh
│   ├── clean.sh
│   └── validate.sh
└── docs/
    ├── day01.md
    ├── day02.md
    ├── ...
    └── day14.md
```

The profile is based on ArchISO's shipped profiles rather than inventing a separate image-building system.

## Recommended builder

Use a dedicated Arch Linux builder VM.

Suggested starting resources:

- 4 vCPUs
- 8–10 GB RAM
- 40+ GB free disk
- VirtualBox
- Network access during package installation/build

The builder itself should be Arch Linux so that the ArchISO tooling matches the target environment.

## Day 1 — Arch builder setup

Install a clean Arch Linux VM and update it:

```bash
sudo pacman -Syu
```

Install the basic build tooling:

```bash
sudo pacman -S --needed archiso git qemu-desktop
```

Verify:

```bash
mkarchiso -h
```

Create the local workspace:

```bash
mkdir -p ~/nebulaos/archbuild
cd ~/nebulaos/archbuild
```

## Day 2 — Study the official archiso profile

ArchISO provides `releng` and `baseline` profiles.

For a first custom distribution, use `releng` as the starting point:

```bash
cp -r /usr/share/archiso/configs/releng profile
```

Inspect it:

```bash
find profile -maxdepth 2 -type f | sort
```

Read:

```bash
less /usr/share/doc/archiso/README.profile.rst
```

Do not modify everything at once. Understand the profile first.

## Day 3 — Package selection

The live system packages are controlled by:

```text
profile/packages.x86_64
```

Packages are listed one per line.

Start with a small base and add tools deliberately. Examples for a DevOps-oriented system include:

```text
base
linux
linux-firmware
networkmanager
openssh
git
curl
wget
jq
vim
nano
tmux
htop
rsync
bash-completion
```

Avoid adding large collections until the first minimal ISO works.

## Day 4 — ISO identity and profile configuration

Study and configure:

```text
profile/profiledef.sh
profile/pacman.conf
```

Set the ArchISO profile's ISO name, label, publisher and related metadata according to the current archiso profile format.

Keep the configuration compatible with the installed archiso version.

## Day 5 — Customize the live filesystem

The:

```text
profile/airootfs/
```

directory becomes the root filesystem of the live image.

Use it to add NebulaOS files such as:

```text
/etc/motd
/etc/issue
/etc/skel/
/etc/nebulaos/
/usr/local/bin/
```

Do not put generated build artifacts into `airootfs/`.

## Day 6 — Users, permissions and systemd

Learn how the live environment is configured.

Practice:

- users and groups
- sudo
- file ownership
- systemd services
- NetworkManager
- SSH

Any custom permissions should be represented through the profile's supported permission configuration rather than fixing them manually after the ISO is generated.

## Day 7 — First Arch NebulaOS ISO

Build the first ISO:

```bash
sudo mkarchiso -v \
  -w /tmp/nebulaos-arch-work \
  -o ./out \
  ./profile
```

The generated ISO should appear in:

```text
archbuild/out/
```

Check:

```bash
ls -lh out/
```

At this point the priority is simply:

**build → boot → inspect → fix**

Do not add major features before the first ISO boots.

## Day 8 — Boot and test with QEMU

Install the QEMU tooling if not already installed.

Use the ArchISO helper when available:

```bash
run_archiso -i ./out/*.iso
```

Test:

- ISO boots
- kernel loads
- filesystem mounts
- shell works
- networking works
- packages are present

## Day 9 — DevOps layer

Expand `packages.x86_64` with the DevOps tools that are appropriate for the Arch edition.

Organize packages by purpose rather than creating one huge unexplained list.

Test each tool inside the live ISO.

## Day 10 — Networking and troubleshooting

Build the operational layer around:

- NetworkManager
- SSH
- DNS tools
- IP inspection
- socket inspection
- routing
- firewall/network troubleshooting

Test commands such as:

```bash
ip addr
ip route
ss -tulpn
ping
curl
ssh
```

## Day 11 — NebulaOS identity and branding

Add the NebulaOS identity to the Arch edition:

- hostname defaults
- MOTD
- release information
- package metadata where appropriate
- shell configuration
- documentation

Keep branding separate from upstream Arch files where possible.

## Day 12 — Build automation

Create:

```text
archbuild/scripts/build.sh
archbuild/scripts/clean.sh
archbuild/scripts/validate.sh
```

The build script should invoke `mkarchiso` rather than duplicating archiso's internal implementation.

A basic build command is:

```bash
sudo mkarchiso -v -w /tmp/nebulaos-arch-work -o ./out ./profile
```

## Day 13 — Validation

Validate the ISO before calling it a release.

Check:

```bash
ls -lh out/
file out/*.iso
sha256sum out/*.iso
```

Boot the ISO in QEMU and VirtualBox.

Verify:

- BIOS/legacy boot where supported by the profile
- UEFI boot
- live environment
- networking
- expected packages
- NebulaOS configuration
- clean shutdown/reboot

## Day 14 — Clean build and release candidate

Perform a clean build from the profile:

```bash
sudo ./scripts/clean.sh
sudo ./scripts/build.sh
```

Then validate the generated artifacts.

Generate checksums:

```bash
sha256sum out/*.iso > out/SHA256SUMS
```

The result should be a reproducible, documented Arch-based NebulaOS build process.

## Important commands

### Build

```bash
sudo mkarchiso -v -w /tmp/nebulaos-arch-work -o ./out ./profile
```

### Clean work directory

Only remove a work directory after checking that no mount bindings remain:

```bash
findmnt
```

Then remove the appropriate work directory.

### Test

```bash
run_archiso -i ./out/*.iso
```

## What you should understand after 14 days

By the end of this track you should understand:

1. Arch Linux package management
2. archiso profile structure
3. `packages.x86_64`
4. `profiledef.sh`
5. `pacman.conf`
6. `airootfs/`
7. live-system customization
8. kernel/initramfs handling through archiso
9. ISO generation with `mkarchiso`
10. QEMU/VirtualBox ISO testing
11. build automation
12. validation and checksums
13. DevOps package integration
14. release-oriented ISO engineering

## Important distinction from the Ubuntu build

The Ubuntu NebulaOS build uses:

```text
live-build → lb config → lb build
```

The Arch NebulaOS build uses:

```text
archiso profile → mkarchiso → ISO
```

Do not mix the two build systems.

## Sources

This track follows the current ArchWiki archiso guidance and the current `mkarchiso(1)` documentation. See the official ArchISO documentation before changing profile internals, because profile formats and package versions can evolve.
