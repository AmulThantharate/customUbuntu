# NebulaOS Build Plan — Week 1, Day 1: Build Environment Setup

## Objective
Establish a clean, isolated, and properly privileged build environment on your host machine (WSL2 or Docker on Ubuntu 24.04 LTS) with all required build dependencies for `live-build`.

---

## 1. Environment Requirements & Constraints

`live-build` is not an ordinary user-space compiler; it constructs an entire operating system image from scratch. The build process requires:
- Linux root privileges (`sudo`) to manage loopback devices and create character/block device nodes (`mknod`).
- Mount isolation for `/proc`, `/sys`, and `/dev` within the chroot jail.
- Modern storage capacity: at least **25 GB of free disk space** for debootstrap packages, chroot uncompressed rootfs, and Squashfs compression.
- At least **4 GB RAM** (8 GB recommended for parallel squashfs compression).

---

## 2. Platform Selection: WSL2 vs. Docker

### Option A: WSL2 (Recommended for Windows Hosts)

> [!WARNING]
> **CRITICAL WSL2 PATH WARNING:**
> You **MUST NOT** run the build inside Windows-mounted paths (e.g., `/mnt/c/`, `/mnt/f/`, or any `/mnt/*`).
> The Windows 9P / DrvFs translation filesystem does not support Linux file capabilities, UNIX socket creation, hardlinks, symlink permissions, or `mknod`. Building on `/mnt/*` will cause `debootstrap` or `dpkg` to fail with `operation not permitted`.
>
> **Always build inside the native Linux ext4 filesystem:** e.g., `/home/<username>/nebulaos` or `/var/tmp/nebulaos`.

#### RUN THIS YOURSELF: WSL2 Toolchain Installation
```bash
# 1. Update APT indices
sudo apt update

# 2. Install live-build and ISO mastering dependencies
sudo apt install -y \
    live-build \
    debootstrap \
    squashfs-tools \
    xorriso \
    grub-pc-bin \
    grub-efi-amd64-bin \
    mtools \
    dosfstools \
    git \
    curl \
    gnupg \
    coreutils

# 3. Create a dedicated build directory on the native ext4 filesystem
mkdir -p ~/nebulaos-build
cd ~/nebulaos-build

# 4. Verify tool versions
lb --version
debootstrap --version
xorriso --version
```

---

### Option B: Docker Container

If building inside Docker, the container must run with `--privileged` and bind-mount `/dev` to allow `live-build` to configure loopback devices (`losetup`).

#### RUN THIS YOURSELF: Docker Build Container Setup
```bash
# 1. Launch a privileged container with Ubuntu 24.04
docker run --privileged -it \
    --name nebulaos-builder \
    -v ${PWD}:/build \
    -w /build \
    ubuntu:24.04 bash

# 2. Inside the container, install build utilities
apt update && apt install -y \
    live-build \
    debootstrap \
    squashfs-tools \
    xorriso \
    grub-pc-bin \
    grub-efi-amd64-bin \
    mtools \
    dosfstools \
    git \
    curl \
    gnupg \
    coreutils

# 3. Verify tools
lb --version
```

---

## 3. Verification & Day 1 Sign-Off

To confirm your environment is ready for Day 2:
1. `lb --version` returns `live-build` version (e.g. `live-build, version 3.0~...` or Debian version `2023...`).
2. `debootstrap` is accessible with root privileges.
3. Your working directory is on an ext4 mount (in WSL2, verify with `df -T .` — type must be `ext4`, NOT `9p` or `drvfs`).

---

## Next Step
Proceed to [Day 2: Live-Build Architecture & Configuration Anatomy](file:///F:/customUbuntu/week1/day2.md).
