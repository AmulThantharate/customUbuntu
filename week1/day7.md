# NebulaOS Build Plan — Week 1, Day 7: Calamares Installer Branding & Graphics

## Objective
Configure the visual identity of the **Calamares** graphical installer: set up `branding.desc`, inject custom stylesheet (`stylesheet.qss`), install distro logos, and configure the installation slideshow.

---

## 1. Timeline & Complexity Tradeoff Flag

> [!WARNING]
> **Engineering Decision: Full Custom QML Slideshow vs. SVG/HTML Slideshow**
> - **Full Custom QML/C++ Theme**: Writing custom QML animated widgets takes 4–6 additional developer days and risks Qt version incompatibilities across Ubuntu library updates.
> - **Recommended Fast Alternative**: Use Calamares's native **HTML/QTextBrowser or Image Slideshow** with custom CSS styling (`stylesheet.qss`) and high-resolution SVG/PNG slide cards.
> - **Timeline Impact**: Saves ~4 days, keeping the project strictly within our 2-week target.

---

## 2. Calamares Branding Directory Structure

Calamares reads its branding definition from `/etc/calamares/branding/<brand-name>/`. For NebulaOS, this directory is placed in the live-build overlay:

```text
config/includes.chroot/etc/calamares/branding/nebulaos/
├── branding.desc          # Branding configuration & metadata
├── stylesheet.qss         # Qt stylesheet (colors, margins, fonts, buttons)
├── nebulaos-logo.svg      # Sidebar and header logo
├── nebulaos-icon.svg      # Window & dock icon
└── slideshow/             # HTML / PNG slides displayed during installation
    ├── slide1.html        # "Welcome to NebulaOS"
    ├── slide2.html        # "Built-in Docker & Kubernetes Toolchain"
    └── slide3.html        # "Automated Cloud Infrastructure with Terraform"
```

---

## 3. Configuring `branding.desc`

### RUN THIS YOURSELF: Create Branding Descriptor

Inside `~/nebulaos-build`:

```bash
mkdir -p config/includes.chroot/etc/calamares/branding/nebulaos/slideshow

cat << 'EOF' > config/includes.chroot/etc/calamares/branding/nebulaos/branding.desc
---
componentName: nebulaos
welcomeStyleCalamares: false
welcomeExpandingLogo: true
windowExpanding: normal
windowSize: 850px,560px
windowPlacement: center

strings:
    productName:         "NebulaOS"
    shortProductName:    "NebulaOS"
    version:             "24.04 LTS"
    shortVersion:        "24.04"
    versionedName:       "NebulaOS 24.04 LTS"
    shortVersionedName:  "NebulaOS 24.04"
    bootloaderEntryName: "NebulaOS"
    productUrl:          "https://nebulaos.dev"
    supportUrl:          "https://nebulaos.dev/support"
    bugReportUrl:        "https://github.com/nebulaos/nebulaos/issues"
    releaseNotesUrl:     "https://nebulaos.dev/releases/24.04"

images:
    productLogo:         "nebulaos-logo.svg"
    productIcon:         "nebulaos-logo.svg"
    productWelcome:      "nebulaos-logo.svg"

slideshow:               "slideshow.qml"

style:
   SidebarBackground:    "#0a0e17"
   SidebarText:          "#ffffff"
   SidebarTextCurrent:   "#00f2fe"
   SidebarBackgroundCurrent: "#111927"
EOF
```

---

## 4. Crafting the Qt Stylesheet (`stylesheet.qss`)

Calamares uses Qt stylesheets to style buttons, progress bars, sidebars, and input fields. We provide a modern deep space dark theme.

### RUN THIS YOURSELF: Create Stylesheet
```bash
cat << 'EOF' > config/includes.chroot/etc/calamares/branding/nebulaos/stylesheet.qss
/* NebulaOS Calamares Dark Space Theme */

QWidget {
    background-color: #0f172a;
    color: #e2e8f0;
    font-family: "DejaVu Sans", "Sans Serif";
    font-size: 13px;
}

QDialog, QMainWindow {
    background-color: #0a0e17;
}

/* Sidebar Styling */
#sidebarApp {
    background-color: #0a0e17;
    border-right: 1px solid #1e293b;
    padding: 12px;
}

/* Primary Action Buttons */
QPushButton {
    background-color: #1e293b;
    border: 1px solid #334155;
    border-radius: 4px;
    padding: 8px 18px;
    color: #ffffff;
    font-weight: bold;
}

QPushButton:hover {
    background-color: #00f2fe;
    color: #0a0e17;
    border: 1px solid #00f2fe;
}

QPushButton:pressed {
    background-color: #0284c7;
    color: #ffffff;
}

QPushButton:disabled {
    background-color: #1e293b;
    color: #64748b;
    border: 1px solid #1e293b;
}

/* Progress Bar during installation */
QProgressBar {
    background-color: #1e293b;
    border: 1px solid #334155;
    border-radius: 4px;
    text-align: center;
    color: #ffffff;
    height: 18px;
}

QProgressBar::chunk {
    background-color: qlineargradient(x1:0, y1:0, x2:1, y2:0, stop:0 #00f2fe, stop:1 #4facfe);
    border-radius: 3px;
}

/* Text & Line Edits */
QLineEdit, QComboBox {
    background-color: #1e293b;
    border: 1px solid #334155;
    border-radius: 4px;
    padding: 6px;
    color: #ffffff;
}

QLineEdit:focus, QComboBox:focus {
    border: 1px solid #00f2fe;
}
EOF
```

---

## 5. Distro Installation Slideshow

We embed clean HTML presentation slides displayed while the live filesystem is unpacked to disk:

### RUN THIS YOURSELF: Create Slideshow Cards
```bash
# Slide 1: Welcome
cat << 'EOF' > config/includes.chroot/etc/calamares/branding/nebulaos/slideshow/slide1.html
<!DOCTYPE html>
<html>
<head>
<style>
  body { background-color: #0f172a; color: #f8fafc; font-family: sans-serif; padding: 40px; }
  h1 { color: #00f2fe; font-size: 32px; }
  p { font-size: 16px; line-height: 1.6; color: #94a3b8; }
</style>
</head>
<body>
  <h1>Welcome to NebulaOS</h1>
  <p>NebulaOS is engineered specifically for DevOps practitioners, cloud architects, and site reliability engineers.</p>
  <p>Everything you need to orchestrate containers, provision multi-cloud infrastructure, and monitor systems is ready out-of-the-box.</p>
</body>
</html>
EOF

# Slide 2: DevOps Stack
cat << 'EOF' > config/includes.chroot/etc/calamares/branding/nebulaos/slideshow/slide2.html
<!DOCTYPE html>
<html>
<head>
<style>
  body { background-color: #0f172a; color: #f8fafc; font-family: sans-serif; padding: 40px; }
  h1 { color: #00f2fe; font-size: 32px; }
  li { font-size: 16px; line-height: 1.8; color: #cbd5e1; }
</style>
</head>
<body>
  <h1>Pre-Packaged Cloud Tooling</h1>
  <ul>
    <li><b>Docker Engine & Compose:</b> Production container runtime enabled for non-root users.</li>
    <li><b>Kubernetes (kubectl & Helm):</b> Direct cluster access and helm chart management.</li>
    <li><b>Terraform:</b> Multi-cloud declarative infrastructure provisioning.</li>
    <li><b>Ansible:</b> Agentless configuration management and automation.</li>
  </ul>
</body>
</html>
EOF

# Copy Logo
cp config/includes.chroot/usr/share/backgrounds/nebulaos/nebulaos-wallpaper.svg \
   config/includes.chroot/etc/calamares/branding/nebulaos/nebulaos-logo.svg
```

---

## 6. End of Week 1 Summary

Week 1 has established:
1. Isolated build tooling in WSL2/Docker.
2. Complete `live-build` directory structures and reproducible `auto/` wrappers.
3. Package lists for XFCE desktop, DevOps toolchain, and Calamares installer.
4. Third-party APT repositories configured with GPG public verification keys.
5. Operating system identity (`/etc/os-release`, MOTD, prompt, wallpaper).
6. Calamares branding, stylesheet, and installation slideshow.

---

## Next Step
Proceed to **Week 2**, starting with [Day 8: User Creation, Permissions & Systemd Services Hooks](file:///F:/customUbuntu/week2/day8.md).
