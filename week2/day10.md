# NebulaOS Build Plan — Week 2, Day 10: Calamares Installer Full Configuration

## Objective
Configure the complete **Calamares** installation sequence for NebulaOS: assemble `settings.conf`, configure the module execution pipeline (partitioning, user provisioning, locale, unpacking SquashFS, bootloader), and provide a non-expert installer workflow.

---

## 1. Required vs. Optional Calamares Modules

To deliver a reliable installer within our 2-week timeline, we focus on the core modules necessary to turn an empty hard drive into an installed NebulaOS workstation:

| Module | Classification | Responsibility |
| :--- | :--- | :--- |
| `welcome` | **Required** | System requirements pre-check (RAM, disk space, AC power). |
| `locale` & `keyboard` | **Required** | Timezone selection and keyboard layout mapping. |
| `partition` | **Required** | Automatic disk wiping, manual partitioning, and EFI system partition creation. |
| `users` | **Required** | Creates user accounts, passwords, root access, and auto-login settings. |
| `unpackfs` | **Required** | Mounts and extracts `filesystem.squashfs` directly to the target hard drive partition. |
| `bootloader` | **Required** | Installs GRUB EFI to the newly partitioned drive and generates `/boot/grub/grub.cfg`. |
| `services-systemd` | **Required** | Enables systemd services (NetworkManager, Docker) on the installed drive. |
| `oemid` / `netinstall` | *Optional (Omitted)* | Advanced dynamic package downloading over the network during install. Skipping keeps install fully offline-capable. |

---

## 2. Master Installer Orchestration (`/etc/calamares/settings.conf`)

This is the central configuration file that determines the visual pages shown to the user and the exact sequence of background installation tasks.

### RUN THIS YOURSELF: Configure `settings.conf`
Run in `~/nebulaos-build`:

```bash
mkdir -p config/includes.chroot/etc/calamares/modules

cat << 'EOF' > config/includes.chroot/etc/calamares/settings.conf
---
modules-search: [ local, /usr/lib/x86_64-linux-gnu/calamares/modules ]

instances:
- id:       clean_live_user
  module:   shellprocess
  config:   shellprocess_remove_live.conf

sequence:
- show:
  - welcome
  - locale
  - keyboard
  - partition
  - users
  - summary
- exec:
  - partition
  - mount
  - unpackfs
  - machineid
  - fstab
  - locale
  - keyboard
  - localecfg
  - users
  - networkcfg
  - hwclock
  - services-systemd
  - bootloader
  - shellprocess@clean_live_user
  - umount
- show:
  - finished

branding: nebulaos
prompt-install: false
dont-chroot: false
oem-setup: false
disable-cancel: false
disable-cancel-during-exec: false
EOF
```

---

## 3. Configuring Core Modules

### A. Welcome Module (`modules/welcome.conf`)
Ensures the target machine meets basic hardware requirements: at least 2 GB RAM and 20 GB disk space.

```bash
cat << 'EOF' > config/includes.chroot/etc/calamares/modules/welcome.conf
---
showSupportUrl:         true
showKnownIssuesUrl:     false
showReleaseNotesUrl:    true
showDonateUrl:          false

requirements:
    requiredStorage:    20.0
    requiredRam:        2.0
    internetCheckUrl:   http://connectivity-check.ubuntu.com
    check:
        - storage
        - ram
        - power
    required:
        - storage
        - ram
EOF
```

### B. Partitioning Module (`modules/partition.conf`)
Sets up modern GPT partitioning with EFI system partition by default, supporting ext4, Btrfs, or XFS.

```bash
cat << 'EOF' > config/includes.chroot/etc/calamares/modules/partition.conf
---
efiSystemPartition:     "/boot/efi"
efiSystemPartitionSize: 512M
defaultFileSystemType:  "ext4"
availableFileSystemTypes: ["ext4", "btrfs", "xfs"]
enableLuksAutomatedPartitioning: true
defaultPartitionTableType: "gpt"

drawPartitionTable:     true
alwaysShowPartitionLabels: true
initialPartitioningChoice: erase
initialSwapChoice:      small
EOF
```

### C. User Creation Module (`modules/users.conf`)
Ensures newly created accounts automatically join the `docker` and `sudo` groups on the installed system.

```bash
cat << 'EOF' > config/includes.chroot/etc/calamares/modules/users.conf
---
defaultGroups:
    - sudo
    - docker
    - adm
    - cdrom
    - plugdev
    - netdev
    - audio
    - video

autologinGroup: autologin
doAutologin:    false
sudoersGroup:   sudo
setRootPassword: false
doReusePassword: true
EOF
```

### D. Filesystem Unpack Module (`modules/unpackfs.conf`)
Extracts the live filesystem squashfs to the target root mount.

```bash
cat << 'EOF' > config/includes.chroot/etc/calamares/modules/unpackfs.conf
---
unpack:
    - source: "/run/live/medium/casper/filesystem.squashfs"
      sourcefs: "squashfs"
      destination: ""
EOF
```

### E. Bootloader Module (`modules/bootloader.conf`)
Installs GRUB EFI into `/boot/efi` and configures the boot record.

```bash
cat << 'EOF' > config/includes.chroot/etc/calamares/modules/bootloader.conf
---
efiBootLoader: "grub"
kernel: "/vmlinuz"
img: "/initrd.img"
stage1: "/boot/efi"
installEpilogue: true

grubInstall: "grub-install"
grubMkconfig: "grub-mkconfig"
grubCfgPath: "/boot/grub/grub.cfg"
grubProbe: "grub-probe"
efiBootMgr: "efibootmgr"
EOF
```

### F. Post-Install Cleanup Module (`modules/shellprocess_remove_live.conf`)
Removes the live user (`nebula`) and live-only auto-login files from the installed disk, so only the user created in Calamares exists.

```bash
cat << 'EOF' > config/includes.chroot/etc/calamares/modules/shellprocess_remove_live.conf
---
dontChroot: false
timeout: 30
script:
    - "-rm -f /etc/sudoers.d/99-nebula-live"
    - "-rm -f /etc/lightdm/lightdm.conf.d/80-nebula-autologin.conf"
    - "-userdel -r -f nebula"
EOF
```

---

## 4. Verification

Verify all Calamares modules are present:
```bash
ls -l config/includes.chroot/etc/calamares/modules/
```
Output must contain:
- `welcome.conf`
- `partition.conf`
- `users.conf`
- `unpackfs.conf`
- `bootloader.conf`
- `shellprocess_remove_live.conf`

---

## Next Step
Proceed to [Day 11: Custom Package Repositories & Offline Readiness](file:///F:/customUbuntu/week2/day11.md).
