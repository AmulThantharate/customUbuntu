# NebulaOS Build Plan — Week 2, Day 13: QA Testing Matrix & Boot Troubleshooting

## Objective
Execute a rigorous 8-stage manual Quality Assurance (QA) verification matrix on the generated NebulaOS ISO, and master debugging techniques for live-build build logs and Casper boot failures.

---

## 1. Comprehensive QA Testing Matrix

Run these validation tests on your release candidate ISO (`nebulaos-24.04-amd64.iso`):

| Test ID | Test Category | Target Environment | Pass Criteria |
| :--- | :--- | :--- | :--- |
| **TC-01** | **BIOS Boot Test** | VM (Legacy BIOS mode) | Syslinux / GRUB menu loads; live system boots to desktop. |
| **TC-02** | **UEFI Boot Test** | VM (OVMF / UEFI mode) | GRUB EFI menu loads; seamless transition to graphical XFCE session. |
| **TC-03** | **Secure Boot Test** | Real PC / VM with Secure Boot | Kernel boots without "Signature verification failed" or policy violation. |
| **TC-04** | **Branding Verification** | Live Session Terminal | `cat /etc/os-release` displays NebulaOS; prompt shows `nebula@nebulaos`. |
| **TC-05** | **DevOps Tool Presence** | Live Session Terminal | `docker --version`, `kubectl version`, `terraform -version`, `helm version`, `ansible --version` all execute with exit code 0. |
| **TC-06** | **Docker Daemon Check** | Live Session Terminal | `docker run --rm hello-world` succeeds as non-root user `nebula` without `sudo`. |
| **TC-07** | **Calamares Installation** | VM (Clean virtual disk) | Installer completes partitioning, filesystem unpack, and bootloader install; VM reboots cleanly into installed system. |
| **TC-08** | **USB Persistence Test** | Real Hardware USB | File created in `/home/nebula/test.txt` survives reboot when `persistent` flag is used. |

---

## 2. Boot Failure Diagnostics & Signatures

If a test fails during boot, use these signatures and log files to isolate the root cause:

### Failure Signature 1: Initramfs BusyBox Shell Prompt
```text
(initramfs) Unable to find a medium containing a live file system
```
- **Root Cause**: Casper could not locate the USB drive or optical drive containing `/casper/filesystem.squashfs`.
- **Diagnostic Step**: Inside the BusyBox shell, check:
  ```sh
  ls /dev/sd* /dev/nvme* /dev/sr*
  cat /var/log/casper.log
  ```
- **Resolution**: Verify ISO burning command. If using a USB stick, write using `dd` or `balenaEtcher` (raw block write), not ISO file drag-and-drop.

---

### Failure Signature 2: Kernel Panic on Mount
```text
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
```
- **Root Cause**: The initramfs is missing the driver for your host storage controller (AHCI/NVMe) or `casper` initramfs hooks were omitted during `update-initramfs`.
- **Diagnostic Step**: Check `config/package-lists/` to ensure `casper` and `linux-generic` are listed in the same manifest.
- **Resolution**: Rebuild with `sudo lb clean && sudo lb build`.

---

### Failure Signature 3: Graphical Desktop Hangs at Black Screen / Cursor
```text
systemd[1]: Started Light Display Manager.
(Screen stays black with blinking cursor)
```
- **Root Cause**: Display server (Xorg) driver crash or missing permissions on `/var/log/lightdm`.
- **Diagnostic Step**: Switch to virtual console with `Ctrl + Alt + F2`, log in with user `nebula` (password `nebula`), and inspect:
  ```bash
  cat /var/log/Xorg.0.log | grep -E '\(EE\)|\(WW\)'
  journalctl -u lightdm.service -b
  ```
- **Resolution**: Ensure `xserver-xorg-video-all` and `xfce4` are fully installed.

---

### Failure Signature 4: Calamares Fails During `unpackfs`
```text
Installation Failed: The source filesystem could not be unpacked.
```
- **Root Cause**: The path in `config/includes.chroot/etc/calamares/modules/unpackfs.conf` does not match the actual mount point of the live ISO squashfs.
- **Diagnostic Step**: Check where Casper mounted the live medium in the running session:
  ```bash
  df -h | grep squashfs
  cat /var/log/calamares.log
  ```
- **Resolution**: In Ubuntu live images, Casper mounts the squashfs at `/cdrom/casper/filesystem.squashfs` or `/run/live/medium/casper/filesystem.squashfs`. Ensure `unpackfs.conf` points to the correct location.

---

## 3. Interpreting `live-build` Build Logs

When `sudo lb build` terminates prematurely on your build host:
```bash
# Search for fatal errors in build log
grep -in "error:" build.log
grep -in "E: " build.log
grep -in "failed" build.log
```
- If `E: Sub-process /usr/bin/dpkg returned an error code (1)`: Scroll up 20 lines to find the package whose pre/post-inst script threw an error.
- If `xorriso : FAILURE : ...`: Out of disk space or bad file permissions in `binary/`.

---

## Next Step
Proceed to [Day 14: Release Engineering, Checksums, GPG Signing & Distribution](file:///F:/customUbuntu/week2/day14.md).
