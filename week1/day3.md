# NebulaOS Build Plan — Week 1, Day 3: Minimal Working Config Tree

## Objective
Set up the minimal package list and bootstrap configuration required to produce a valid, bootable live ISO before adding graphical desktops or large DevOps tooling suites.

---

## 1. Why a "Minimal" ISO First?

A common failure mode in custom Linux OS engineering is attempting to configure the desktop, installer, DevOps packages, kernel tweaks, and themes all in the first build. When the build fails (or fails to boot), isolating the error among hundreds of packages is painful.

By building a minimal live base system first:
1. You verify network connectivity to Ubuntu's mirrors and `debootstrap` mechanics.
2. You confirm that `casper` (Ubuntu's live boot generator) successfully discovers the live media and mounts the SquashFS overlay.
3. You verify that GRUB EFI boots cleanly in your virtualization layer (QEMU/VirtualBox/Hyper-V).

---

## 2. Minimal Package List (`config/package-lists/minimal.list.chroot`)

For Ubuntu live systems, `casper` is the heart of the live boot mechanism. It handles:
- Locating the USB/CDROM medium with the SquashFS filesystem.
- Setting up the `overlayfs` root overlay in RAM.
- Creating the default live user session.

### RUN THIS YOURSELF: Create Minimal Package Manifest

Run inside `~/nebulaos-build`:

```bash
mkdir -p config/package-lists

cat << 'EOF' > config/package-lists/minimal.list.chroot
# Core Linux Kernel & Live Boot Engine
casper
discover
laptop-detect
os-prober
linux-generic

# Init system & Core Utilities
systemd
systemd-sysv
dbus
sudo
network-manager
net-tools
iproute2
iputils-ping
curl
wget
ca-certificates
nano
less
pciutils
usbutils
locales
tzdata
EOF
```

---

## 3. Configuring Live-Build Chroot Defaults

In `config/chroot`, we ensure APT doesn't install recommended packages indiscriminately (which inflates image size) and sets the interactive mode to non-interactive during the build.

### RUN THIS YOURSELF: Configure APT Behavior

```bash
# Prevent interactive debconf prompts during build
echo 'APT::Install-Recommends "false";' > config/includes.chroot/etc/apt/apt.conf.d/99recommends
```

---

## 4. Verification

Verify that your config tree looks like this:
```bash
find config/ -maxdepth 2
```
Expected output:
```text
config/
config/common
config/bootstrap
config/chroot
config/binary
config/source
config/package-lists/minimal.list.chroot
config/includes.chroot/etc/apt/apt.conf.d/99recommends
```

---

## Next Step
Proceed to [Day 4: Building and Booting the Minimal Base ISO](file:///F:/customUbuntu/week1/day4.md).
