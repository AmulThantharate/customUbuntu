# NebulaOS Build Plan — Week 1, Day 6: Distro Identity, MOTD, Shell Prompt & Visual Branding

## Objective
Replace all default Ubuntu branding with the custom **NebulaOS** identity: customize `/etc/os-release`, configure an engineer-focused `/etc/motd`, craft an informative bash prompt, set up the desktop wallpaper, and customize GRUB and Plymouth splash screens.

---

## 1. Operating System Identity (`/etc/os-release`)

Tools like `hostnamectl`, `neofetch`, `fastfetch`, and Calamares read `/etc/os-release` to identify the operating system.

### RUN THIS YOURSELF: Configure OS Release & Issues
Execute inside `~/nebulaos-build`:

```bash
mkdir -p config/includes.chroot/etc

# 1. Distro definition
cat << 'EOF' > config/includes.chroot/etc/os-release
NAME="NebulaOS"
VERSION="24.04 LTS (Noble Numbat)"
ID=nebulaos
ID_LIKE="ubuntu debian"
PRETTY_NAME="NebulaOS 24.04 LTS (DevOps Workstation)"
VERSION_ID="24.04"
HOME_URL="https://nebulaos.dev"
SUPPORT_URL="https://nebulaos.dev/support"
BUG_REPORT_URL="https://github.com/nebulaos/nebulaos/issues"
PRIVACY_POLICY_URL="https://nebulaos.dev/privacy"
VERSION_CODENAME=noble
UBUNTU_CODENAME=noble
LOGO=nebulaos-logo
EOF

# 2. TTY console banners
cat << 'EOF' > config/includes.chroot/etc/issue
NebulaOS 24.04 LTS \n \l

EOF

cp config/includes.chroot/etc/issue config/includes.chroot/etc/issue.net
```

---

## 2. Branded MOTD (Message of the Day)

When an engineer opens a terminal or logs in via SSH, an informative ASCII banner with quick status commands is presented.

### RUN THIS YOURSELF: Configure Custom MOTD
```bash
cat << 'EOF' > config/includes.chroot/etc/motd
  _   _      _             _         ___  ____  
 | \ | | ___| |__  _   _  | | __ _  / _ \/ ___| 
 |  \| |/ _ \ '_ \| | | | | |/ _` || | | \___ \ 
 | |\  |  __/ |_) | |_| | | | (_| || |_| |___) |
 |_| \_|\___|_.__/ \__,_| |_|\__,_| \___/|____/ 
 NebulaOS 24.04 LTS — Cloud & DevOps Workstation

 Available DevOps Tooling:
   docker    : $(docker --version 2>/dev/null || echo "pre-installed")
   kubectl   : $(kubectl version --client --output=yaml 2>/dev/null | grep gitVersion | awk '{print $2}' || echo "pre-installed")
   terraform : $(terraform version 2>/dev/null | head -n1 || echo "pre-installed")
   helm      : $(helm version --short 2>/dev/null || echo "pre-installed")
   ansible   : $(ansible --version 2>/dev/null | head -n1 || echo "pre-installed")

 Type 'calamares' or click the desktop icon to install NebulaOS to disk.
EOF
```

---

## 3. Branded DevOps Bash Prompt (`/etc/profile.d/nebulaos-prompt.sh`)

Engineers benefit from having hostname, user, git branch (when in a repo), and exit codes visible directly in their shell prompt.

### RUN THIS YOURSELF: Shell Prompt Setup
```bash
mkdir -p config/includes.chroot/etc/profile.d

cat << 'EOF' > config/includes.chroot/etc/profile.d/nebulaos-prompt.sh
# NebulaOS Custom Shell Prompt for DevOps Engineers
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Cyan and Deep Blue Theme
if [ "$USER" = "root" ]; then
    PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;33m\]$(parse_git_branch)\[\033[00m\]# '
else
    PS1='\[\033[01;36m\]\u@nebulaos\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;33m\]$(parse_git_branch)\[\033[00m\]$ '
fi
EOF

chmod +x config/includes.chroot/etc/profile.d/nebulaos-prompt.sh
```

---

## 4. Visual Assets: Wallpaper, GRUB & Plymouth

### A. Default Desktop Wallpaper
XFCE wallpaper is configured under `/usr/share/backgrounds/nebulaos/`. We place a clean SVG vector wallpaper.

#### RUN THIS YOURSELF: Wallpaper Installation
```bash
mkdir -p config/includes.chroot/usr/share/backgrounds/nebulaos/
mkdir -p config/includes.chroot/usr/share/pixmaps/

# Generate an elegant deep-space SVG wallpaper
cat << 'EOF' > config/includes.chroot/usr/share/backgrounds/nebulaos/nebulaos-wallpaper.svg
<svg xmlns="http://www.w3.org/2000/svg" width="1920" height="1080" viewBox="0 0 1920 1080">
  <defs>
    <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#0a0e17" />
      <stop offset="50%" stop-color="#111927" />
      <stop offset="100%" stop-color="#0f172a" />
    </linearGradient>
    <linearGradient id="accent" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#00f2fe" />
      <stop offset="100%" stop-color="#4facfe" />
    </linearGradient>
  </defs>
  <rect width="1920" height="1080" fill="url(#bg)" />
  <circle cx="960" cy="540" r="320" fill="none" stroke="url(#accent)" stroke-width="2" opacity="0.3" />
  <circle cx="960" cy="540" r="260" fill="none" stroke="url(#accent)" stroke-width="1.5" stroke-dasharray="10 15" opacity="0.4" />
  <text x="960" y="530" font-family="sans-serif" font-size="64" font-weight="bold" fill="#ffffff" text-anchor="middle" letter-spacing="4">NebulaOS</text>
  <text x="960" y="580" font-family="sans-serif" font-size="20" fill="#00f2fe" text-anchor="middle" letter-spacing="8">CLOUD &amp; DEVOPS WORKSTATION</text>
</svg>
EOF

# Install Distro Logo Icon
cp config/includes.chroot/usr/share/backgrounds/nebulaos/nebulaos-wallpaper.svg \
   config/includes.chroot/usr/share/pixmaps/nebulaos-logo.svg
```

### B. GRUB Bootloader Splash Screen
During binary stage, GRUB displays a splash image if placed in the boot configuration.
- Path in live-build: `config/includes.binary/boot/grub/splash.png` or `config/includes.chroot/usr/share/images/desktop-base/desktop-grub.png`.
- Format: 640x480 or 1024x768 PNG.

### C. Plymouth Boot Splash Theme
To brand the early splash before X11 starts:
- Path: `config/includes.chroot/usr/share/plymouth/themes/nebulaos/`
- Set default Plymouth theme in a hook script via: `update-alternatives --set default.plymouth /usr/share/plymouth/themes/nebulaos/nebulaos.plymouth`.

---

## 5. Verification Checklist

After rebuilding the ISO, verify your branding took effect:
- [ ] `cat /etc/os-release`: NAME is `"NebulaOS"`, ID is `nebulaos`.
- [ ] `hostnamectl`: Operating System displays `NebulaOS 24.04 LTS`.
- [ ] Terminal launch: Branded prompt `user@nebulaos:~$` and MOTD banner display.
- [ ] Desktop background: `nebulaos-wallpaper.svg` displays on live session startup.

---

## Next Step
Proceed to [Day 7: Calamares Installer Branding & Graphics](file:///F:/customUbuntu/week1/day7.md).
