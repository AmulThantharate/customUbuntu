# NebulaOS Build Plan — Week 2, Day 14: Release Engineering & Distribution

## Objective
Package, sign, tag, and publish the official **NebulaOS v0.1.0** release: generate SHA-256 checksums, apply cryptographic GPG signatures, publish release notes, and provide end-user flashing and boot instructions.

---

## 1. Cryptographic Verification & Release Integrity

Before distributing any ISO to the public or your team, you must generate a SHA-256 checksum and a detached GPG cryptographic signature.

### RUN THIS YOURSELF: Checksum and Signature Generation

Run inside the directory containing your final `nebulaos-24.04-amd64.iso`:

```bash
# 1. Generate SHA-256 checksum
sha256sum nebulaos-24.04-amd64.iso > SHA256SUMS

# 2. Sign the checksums file with your release GPG key
gpg --armor --detach-sign --output SHA256SUMS.gpg SHA256SUMS

# 3. Verify the signature locally
gpg --verify SHA256SUMS.gpg SHA256SUMS
```

End users can verify their download using:
```bash
# Verify integrity
sha256sum -c SHA256SUMS --ignore-missing

# Verify authenticity
gpg --import nebulaos-release.asc
gpg --verify SHA256SUMS.gpg SHA256SUMS
```

---

## 2. Git Tagging & Repository Milestone

To freeze the exact build recipe for v0.1.0:

### RUN THIS YOURSELF: Git Release Commands
```bash
# Initialize repo if not already done
git init
git add .
git commit -m "feat: complete NebulaOS v0.1.0 live-build recipe"

# Create signed git release tag
git tag -s v0.1.0 -m "NebulaOS v0.1.0 - DevOps & Cloud Workstation (Ubuntu 24.04 Noble LTS)"

# Push to remote (adjust remote URL as needed)
# git remote add origin git@github.com:nebulaos/nebulaos.git
# git push origin main --tags
```

---

## 3. Official Release Notes Draft (v0.1.0)

```markdown
# NebulaOS v0.1.0 (Noble Edition) — Initial Public Release

We are proud to announce the first release of **NebulaOS v0.1.0**, a specialized Ubuntu 24.04 LTS-based distribution engineered specifically for DevOps engineers, Site Reliability Engineers (SREs), and cloud architects.

### Highlights & Features:
- **Base**: Ubuntu 24.04 LTS (Noble Numbat) with Linux Kernel 6.8+ (x86_64).
- **Desktop**: Lightweight, resource-efficient XFCE 4.18 desktop (< 500 MB RAM idle).
- **Installer**: Seamless Calamares 3.3 graphical installer with automated GPT/EFI partitioning and LUKS full-disk encryption support.
- **Pre-loaded Cloud & DevOps Toolchain**:
  - **Docker Engine & Docker Compose**: Configured out-of-the-box for passwordless live user operation.
  - **Kubernetes**: `kubectl` v1.31 and `helm` v3.
  - **Infrastructure as Code**: HashiCorp `terraform` and `ansible`.
  - **Diagnostic Utilities**: `jq`, `yq`, `tmux`, `htop`, `wireguard-tools`, `nmap`, `net-tools`.
- **Identity & Theming**: Custom NebulaOS deep-space dark theme, branded shell prompt with dynamic git branch detection, and informative MOTD.
- **Boot Support**: Native UEFI Secure Boot support (Canonical signed shim) and Legacy BIOS support.

### Checksums:
- File: `nebulaos-24.04-amd64.iso`
- SHA256: *(Generated during Day 14 build)*
```

---

## 4. Hosting Strategy: GitHub Releases vs. Self-Hosting

The generated hybrid ISO will typically range between **2.2 GB and 3.5 GB**.

| Hosting Option | Pros | Cons | Recommendation |
| :--- | :--- | :--- | :--- |
| **GitHub Releases** | Free, high-speed CDN, integrated with Git tags, easy for users. | **2 GB per file limit** on standard uploads. Files over 2 GB require Git LFS or splitting into chunks. | **Best if compressed under 2 GB**, or use multi-part archive (`split -b 1900M`). |
| **Cloudflare R2 / AWS S3** | No file size limits, custom domain downloads, full download telemetry. | Minor bandwidth or storage costs (R2 has zero egress fee). | **Recommended for production ISO distribution.** |
| **Self-Hosted Nginx / MinIO** | Total sovereignty over storage and distribution. | You pay for server bandwidth. | Great for internal team/enterprise intranet distribution. |

---

## 5. End-User Sharing & Flashing Guide

Include these instructions when distributing NebulaOS to engineers:

### Writing to USB Drive

#### Option A: Cross-Platform GUI (balenaEtcher or Rufus)
1. Download [balenaEtcher](https://etcher.balena.io/) or [Rufus](https://rufus.ie/) (Windows).
2. Select `nebulaos-24.04-amd64.iso`.
3. Select your USB drive (minimum 8 GB).
4. In Rufus, ensure **"Write in DD Image mode"** is selected. Click **Start**.

#### Option B: Linux / macOS Terminal (`dd`)
```bash
sudo dd if=nebulaos-24.04-amd64.iso of=/dev/sdX bs=4M status=progress conv=fsync
```
*(Replace `/dev/sdX` with your target USB block device. Double check with `lsblk`)*

### Booting NebulaOS on Hardware
1. Insert the USB drive into the target computer.
2. Power on the machine and immediately press the Boot Selection key for your vendor:
   - **Dell**: `F12`
   - **Lenovo**: `F12` or `Fn + F12`
   - **HP**: `F9` or `Esc` then `F9`
   - **ASUS / Acer**: `F8` or `F12`
3. Select the UEFI USB device from the boot list.
4. Select **"Try or Install NebulaOS"** from the GRUB menu.

---

## 6. Congratulations!

You have completed the full 2-week engineering roadmap for **NebulaOS**. You now have a complete, reproducible live-build specification, custom branding, DevOps stack, Calamares installer, and distribution pipeline.
