# NebulaOS Build Plan — Week 1, Day 4: Minimal Working ISO Build & Boot Validation

## Objective
Execute your first live ISO build using `sudo lb build`, inspect build progress, and boot the resulting `.iso` image in a virtual machine (QEMU / VirtualBox) to validate the live boot chain.

---

## 1. Running the First Build

### RUN THIS YOURSELF: Execute Minimal Build

Inside your build directory (`~/nebulaos-build`):

```bash
# 1. Regenerate configuration
sudo lb clean --purge
sudo lb config

# 2. Build the live ISO (logging all output to build.log)
sudo lb build 2>&1 | tee build.log
```

> [!NOTE]
> **Expected Duration:** The first build downloads ~400–700 MB of Debian/Ubuntu packages via `debootstrap` and compresses them. It typically takes **5 to 15 minutes** depending on your network connection and CPU speed.

### What Happens Behind the Scenes:
1. `P: Running debootstrap...`: Downloads the base filesystem into `chroot/`.
2. `P: Configuring package repository...`: Sets up official Ubuntu Noble mirrors.
3. `P: Begin installing packages...`: Installs `linux-generic`, `casper`, `systemd`, and minimal tools.
4. `P: Begin creating filesystem.squashfs...`: Compresses the chroot into `binary/live/filesystem.squashfs` with high-ratio XZ/GZIP compression.
5. `P: Begin executing binary_grub-efi...`: Embeds GRUB EFI binaries and creates EFI boot images.
6. `P: Begin executing binary_iso...`: Generates the final hybrid ISO: `live-image-amd64.hybrid.iso`.

---

## 2. Renaming the Generated ISO

To ensure the artifact is clearly branded:

### RUN THIS YOURSELF: Rename ISO
```bash
if [ -f live-image-amd64.hybrid.iso ]; then
    mv live-image-amd64.hybrid.iso nebulaos-24.04-minimal-amd64.iso
    echo "SUCCESS: Created nebulaos-24.04-minimal-amd64.iso"
    ls -lh nebulaos-24.04-minimal-amd64.iso
fi
```

---

## 3. Testing the ISO in a Virtual Machine

### Test Option A: QEMU (Fastest Linux CLI VM)
If you have QEMU installed on your host or WSL2 (with GUI/VNC enabled):

#### RUN THIS YOURSELF: QEMU Launch
```bash
# BIOS Boot Test
qemu-system-x86_64 \
    -m 2048 \
    -smp 2 \
    -cdrom nebulaos-24.04-minimal-amd64.iso \
    -boot d \
    -enable-kvm

# UEFI Boot Test (Requires ovmf package)
qemu-system-x86_64 \
    -m 2048 \
    -smp 2 \
    -bios /usr/share/ovmf/OVMF.fd \
    -cdrom nebulaos-24.04-minimal-amd64.iso \
    -boot d \
    -enable-kvm
```

### Test Option B: VirtualBox / VMware / Hyper-V (Windows Host)
1. Copy `nebulaos-24.04-minimal-amd64.iso` to your Windows host directory.
2. In VirtualBox:
   - **Type**: Linux
   - **Version**: Ubuntu (64-bit)
   - **RAM**: 2048 MB (2 GB)
   - **Processors**: 2 vCPUs
   - **Storage**: Attach `nebulaos-24.04-minimal-amd64.iso` to the virtual optical drive.
   - **System -> Motherboard**: Enable EFI (special OSes only) to test UEFI.
3. Start the VM.

---

## 4. What a Successful First Boot Looks Like

```text
[ GRUB Bootloader Menu ]
* Try or Install NebulaOS (Live)
  NebulaOS (Safe Graphics)

(Kernel initialization messages scroll)
casper: Searching for live medium...
casper: Found live medium at /dev/sr0
casper: Mounting filesystem.squashfs on /root...
systemd: Reached target Basic System.
systemd: Started Network Name Resolution.

Welcome to Ubuntu 24.04 LTS! (Will be branded NebulaOS in Day 6)
nebula-live login:
```

### Key Validation Checks:
1. **No Kernel Panic**: System successfully boots without hanging on initramfs.
2. **Casper Medium Discovery**: The live filesystem is mounted automatically in RAM.
3. **Login Available**: A prompt appears allowing login as user `ubuntu` or `root` (or auto-login).

---

## 5. Troubleshooting Early Boot Failures

| Symptom | Cause | Solution |
| :--- | :--- | :--- |
| `Kernel panic - not syncing: VFS: Unable to mount root fs` | Missing `casper` or kernel flavor mismatch | Ensure `casper` and `linux-generic` are in `config/package-lists/minimal.list.chroot`. |
| `(initramfs) Unable to find a medium containing a live file system` | SquashFS image missing or corrupted ISO creation | Re-run `lb clean --binary` and ensure `xorriso` didn't exit with errors. |
| Black screen on UEFI boot | Missing GRUB EFI boot files in binary stage | Verify `grub-efi-amd64-bin` is installed on host and `--bootloaders "grub-efi"` is specified in `auto/config`. |

---

## Next Step
Proceed to [Day 5: DevOps Package Set & Third-Party Repositories](file:///F:/customUbuntu/week1/day5.md).
