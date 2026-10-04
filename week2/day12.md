# NebulaOS Build Plan — Week 2, Day 12: Secure Boot MOK Signing & Persistent USB Storage

## Objective
Implement enterprise hardening and portability features: verify Secure Boot compatibility using Ubuntu's signed `shimx64.efi`, configure out-of-tree kernel module signing via MOK (Machine Owner Key), enable USB live persistent storage (`casper-rw`), and prepare GPG keys for final release verification.

---

## 1. Secure Boot & The Ubuntu Shim Chain of Trust

### How Secure Boot Works on NebulaOS
Ubuntu provides a Microsoft-signed first-stage bootloader: `shimx64.efi`. When Secure Boot is enabled in UEFI:
1. UEFI firmware verifies `shimx64.efi` using Microsoft's third-party UEFI CA key stored in motherboard NVRAM.
2. `shimx64.efi` contains Canonical's CA public certificate, which it uses to verify `grubx64.efi`.
3. `grubx64.efi` verifies the Canonical-signed Linux kernel (`vmlinuz`).
4. The kernel will only load signed kernel modules (`.ko`).

As long as we use Ubuntu's official signed `shim-signed` and `grub-efi-amd64-signed` packages and the standard `linux-generic` kernel, **NebulaOS boots out-of-the-box on UEFI Secure Boot systems without disabling Secure Boot.**

---

## 2. Signing Out-of-Tree Kernel Modules with MOK

If you install third-party DKMS kernel modules (e.g. proprietary GPU drivers or custom VPN kernel modules), the kernel will refuse to load them under Secure Boot unless signed with a custom **Machine Owner Key (MOK)** enrolled in the system's firmware.

### RUN THIS YOURSELF: Generate and Enroll a MOK Key
Run on the machine where DKMS modules are compiled:

```bash
# 1. Install mokutil and sbsigntool
sudo apt install -y mokutil sbsigntool openssl

# 2. Generate an X.509 MOK keypair
openssl req -new -x509 -newkey rsa:2048 \
    -keyout MOK.priv \
    -outform DER -out MOK.der \
    -nodes -days 3650 \
    -subj "/CN=NebulaOS Kernel Module Signing Key/"

# 3. Sign an out-of-tree kernel module (.ko)
# sudo sbsign --key MOK.priv --cert MOK.der /path/to/module.ko --output /path/to/module.ko

# 4. Enroll the MOK certificate into system NVRAM
sudo mokutil --import MOK.der
# Enter a one-time enrollment password when prompted
```

Upon next reboot, the blue `MokManager` screen will appear. Select **Enroll MOK**, confirm the key fingerprint, enter the password, and reboot. The kernel will now load your custom signed modules.

---

## 3. Persistent Storage Mode (Casper Persistence)

In a standard live boot, all changes (installed packages, files saved, docker containers) reside in RAM and disappear upon shutdown.
With **persistence enabled**, Casper redirects write operations from the RAM overlay to a persistent partition labeled `casper-rw` (or a file named `casper-rw`).

### How to Prepare a USB Drive for Live Persistence

To create a bootable USB drive where Docker images and files survive reboots:

#### RUN THIS YOURSELF: Partition USB for Live Persistence
Assuming your USB stick is detected as `/dev/sdb` (**WARNING: verify device name carefully via `lsblk`**):

```bash
# 1. Write the hybrid ISO directly to the USB drive
sudo dd if=nebulaos-24.04-minimal-amd64.iso of=/dev/sdb bs=4M status=progress conv=fsync

# 2. Create a persistent partition in the remaining free space
# (Using parted to create an ext4 partition labeled casper-rw)
sudo parted /dev/sdb --script mkpart primary ext4 4000MB 100%

# 3. Format the new partition as ext4 with the mandatory label "casper-rw"
# (Assuming the partition is /dev/sdb3)
sudo mkfs.ext4 -F -L casper-rw /dev/sdb3
```

When booting the USB drive from the GRUB menu, highlight the boot entry, press `e`, add the kernel parameter `persistent` to the `linux` line, and press `F10`:
```text
linux /casper/vmlinuz boot=casper quiet splash persistent ---
```
Every container pulled with `docker pull` or file saved in `/home/nebula` will now persist across reboots!

---

## 4. GPG Release Key Generation

To establish authenticity for NebulaOS releases, you sign checksums with an official GPG key.

### RUN THIS YOURSELF: Generate GPG Signing Key
```bash
# Generate a dedicated GPG keypair for NebulaOS releases
gpg --batch --gen-key << 'EOF'
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: NebulaOS Release Signing Authority
Name-Email: release@nebulaos.dev
Expire-Date: 2y
%no-protection
%commit
EOF

# Export the public key for end-user distribution
gpg --armor --export release@nebulaos.dev > nebulaos-release.asc
echo "GPG Key Created: nebulaos-release.asc"
```

---

## Next Step
Proceed to [Day 13: Comprehensive QA Testing Matrix & Boot Troubleshooting](file:///F:/customUbuntu/week2/day13.md).
