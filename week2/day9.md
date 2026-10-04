# NebulaOS Build Plan — Week 2, Day 9: First-Boot Welcome Experience & Systemd Automation

## Objective
Implement a pleasant onboarding experience for engineers booting NebulaOS: write a first-boot welcome script, trigger it with a systemd oneshot unit, and place a prominent "Install NebulaOS" shortcut on the live user's desktop.

---

## 1. The Welcome Architecture

When a DevOps engineer boots the live ISO:
1. LightDM logs in user `nebula` into XFCE automatically.
2. A systemd oneshot service (`nebulaos-firstboot.service`) checks if this is a live boot and displays an interactive welcome dialog / terminal summary.
3. The desktop features an icon: **Install NebulaOS to Disk** (`install-nebulaos.desktop`).

---

## 2. Desktop Launcher for Calamares

The live desktop needs a desktop icon that launches Calamares with root privileges via `pkexec`.

### RUN THIS YOURSELF: Create Desktop Launcher
Run in `~/nebulaos-build`:

```bash
mkdir -p config/includes.chroot/etc/skel/Desktop/

cat << 'EOF' > config/includes.chroot/etc/skel/Desktop/install-nebulaos.desktop
[Desktop Entry]
Type=Application
Version=1.0
Name=Install NebulaOS
GenericName=Live System Installer
Comment=Install NebulaOS 24.04 permanently to your computer
Exec=pkexec calamares
Icon=calamares
Terminal=false
Categories=System;
StartupNotify=true
EOF

chmod +x config/includes.chroot/etc/skel/Desktop/install-nebulaos.desktop
```

---

## 3. First-Boot Welcome Script (`/usr/local/bin/nebulaos-welcome.sh`)

This script displays a quick overview of pre-installed DevOps tools and provides direct launch commands.

### RUN THIS YOURSELF: Create Welcome Script
```bash
mkdir -p config/includes.chroot/usr/local/bin

cat << 'EOF' > config/includes.chroot/usr/local/bin/nebulaos-welcome.sh
#!/bin/bash
# NebulaOS Welcome Dialog / Console Banner

if [ -f /var/run/nebulaos-welcomed ]; then
    exit 0
fi

touch /var/run/nebulaos-welcomed

# Check if GUI is running
if [ -n "$DISPLAY" ] && command -v zenity >/dev/null 2>&1; then
    zenity --info --title="Welcome to NebulaOS 24.04 LTS" \
        --width=450 --height=250 \
        --text="<b>Welcome to NebulaOS!</b>\n\nYour specialized DevOps & Cloud Engineering workstation.\n\n• <b>Docker:</b> Active & ready (non-root access enabled)\n• <b>Kubernetes:</b> kubectl v1.31 & Helm pre-installed\n• <b>IaC:</b> Terraform & Ansible ready to run\n\nTo install NebulaOS to your hard drive, double-click <b>Install NebulaOS</b> on the desktop."
fi
EOF

chmod +x config/includes.chroot/usr/local/bin/nebulaos-welcome.sh
```

---

## 4. Systemd Oneshot Service (`nebulaos-firstboot.service`)

### RUN THIS YOURSELF: Create Systemd Service
```bash
mkdir -p config/includes.chroot/etc/systemd/system

cat << 'EOF' > config/includes.chroot/etc/systemd/system/nebulaos-firstboot.service
[Unit]
Description=NebulaOS First-Boot Initialization
After=network.target lightdm.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/nebulaos-welcome.sh

[Install]
WantedBy=graphical.target
EOF
```

---

## 5. Desktop Hook (`03-desktop-setup.hook.chroot`)

We write a hook to copy skeleton desktop shortcuts to the `nebula` live user and enable the firstboot unit.

### RUN THIS YOURSELF: Create Desktop Hook
```bash
cat << 'EOF' > config/hooks/live/03-desktop-setup.hook.chroot
#!/bin/sh
set -e

echo "=== NebulaOS Hook: Configuring Live Desktop ==="

# Populate desktop folder for nebula user
if id -u nebula >/dev/null 2>&1; then
    mkdir -p /home/nebula/Desktop
    cp /etc/skel/Desktop/install-nebulaos.desktop /home/nebula/Desktop/
    chown -R nebula:nebula /home/nebula/Desktop
    chmod +x /home/nebula/Desktop/install-nebulaos.desktop
fi

# Enable first-boot service
systemctl enable nebulaos-firstboot.service || true

echo "=== Desktop hook completed ==="
EOF

chmod +x config/hooks/live/03-desktop-setup.hook.chroot
```

---

## Next Step
Proceed to [Day 10: Calamares Installer Full Configuration](file:///F:/customUbuntu/week2/day10.md).
