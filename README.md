# NebulaOS

**A DevOps-focused Linux distribution built from Ubuntu 24.04 LTS.**

NebulaOS is not a tutorial repository or a collection of weekly exercises. It is an engineering project for building, testing, releasing, and eventually maintaining a real Linux distribution for DevOps and cloud engineering work.

The project uses **Ubuntu 24.04 LTS (Noble)** as its upstream base and **Debian live-build** as the image construction system.

## Vision

NebulaOS should provide a clean Linux workstation for:

- Linux system administration
- Git and GitOps workflows
- Docker and container development
- Kubernetes and OpenShift
- Terraform and infrastructure as code
- Ansible automation
- Helm and cloud-native tooling
- SSH and remote operations
- CI/CD development and troubleshooting
- Observability and SRE workflows
- Network and system debugging

The goal is **not** to install every DevOps tool into the image. The goal is to create a maintainable operating system with a well-defined base, useful defaults, reproducible builds, and an extensible DevOps tool layer.

## Project Architecture

```text
NebulaOS
├── Ubuntu 24.04 LTS
│   └── Linux kernel + Ubuntu package ecosystem
│
├── live-build
│   ├── bootstrap
│   ├── chroot customization
│   ├── package installation
│   └── ISO generation
│
├── NebulaOS system layer
│   ├── OS identity
│   ├── networking
│   ├── users and permissions
│   ├── systemd services
│   └── security defaults
│
├── Desktop layer
│   ├── XFCE
│   ├── LightDM
│   └── NebulaOS branding
│
├── DevOps layer
│   ├── Git
│   ├── containers
│   ├── Kubernetes / OpenShift
│   ├── Terraform
│   ├── Ansible
│   ├── Helm
│   └── troubleshooting / networking tools
│
├── Installer layer
│   └── Calamares
│
└── Release engineering
    ├── validation
    ├── clean builds
    ├── ISO testing
    ├── SHA-256 checksums
    ├── release artifacts
    └── signed releases
```

## Repository Structure

```text
.
├── auto/
│   └── config
├── config/
│   ├── package-lists/
│   ├── hooks/
│   └── includes.chroot/
├── docs/
│   └── learning/
├── scripts/
│   ├── build.sh
│   ├── clean.sh
│   ├── release.sh
│   └── validate.sh
├── .github/
│   └── workflows/
├── PRODUCTION_BUILD.md
├── SECURITY.md
├── VERSION
└── README.md
```

Generated build state and ISO artifacts are intentionally not part of the source tree.

## Build Pipeline

NebulaOS follows the normal live-build image pipeline:

```text
Source repository
      │
      ▼
  lb config
      │
      ▼
 Bootstrap Ubuntu
      │
      ▼
 Install packages
      │
      ▼
 Configure root filesystem
      │
      ▼
 Apply NebulaOS hooks/files
      │
      ▼
 Build SquashFS + boot files
      │
      ▼
   Bootable ISO
      │
      ▼
 VM / hardware testing
      │
      ▼
 Release artifact
```

### Build

From a native Linux build environment:

```bash
./scripts/validate.sh
sudo ./scripts/clean.sh
sudo ./scripts/build.sh
sudo ./scripts/release.sh
```

The maintained configuration is in `auto/config`. Do not recreate the old recursive `auto/build` or `auto/clean` wrappers.

## DevOps Tooling Strategy

NebulaOS will use layers rather than turning the base image into an uncontrolled package dump.

### Base

Keep the base system stable and small:

- Linux kernel
- live-boot components
- systemd
- networking
- SSH client
- Git
- basic shell and diagnostic utilities

### Desktop

Provide a practical graphical workstation:

- XFCE
- terminal
- file manager
- network management
- browser
- audio and desktop utilities

### DevOps

Add and maintain the tools that make NebulaOS useful for cloud engineering:

- Docker / container tooling
- Kubernetes `kubectl`
- OpenShift `oc`
- Helm
- Terraform
- Ansible
- jq / YAML tooling
- tmux
- SSH tooling
- DNS/network troubleshooting utilities

Tool versions and upstream repositories should be pinned or otherwise managed deliberately so that a NebulaOS release remains reproducible and supportable.

## Distribution Engineering Principles

NebulaOS follows these rules:

1. **Ubuntu remains the upstream base.** Do not blindly replace Ubuntu internals.
2. **Configuration belongs in the repository.** Avoid hidden host-specific build state.
3. **Builds must be repeatable.** Clean builds should work from documented inputs.
4. **Prefer declarative configuration.** Use package lists and included files before shell hacks.
5. **Hooks must be deterministic and reviewable.**
6. **No secrets in the repository.**
7. **Use signed upstream packages where possible.**
8. **Test the actual ISO, not only the build scripts.**
9. **Keep the production image maintainable.**
10. **Every release must have traceable source and checksum information.**

## Release Lifecycle

NebulaOS will use a Linux-distribution-style release process:

```text
Development
    ↓
Alpha
    ↓
Beta
    ↓
Feature Freeze
    ↓
Release Candidate
    ↓
Final Release
    ↓
Point Releases / Security Updates
```

A release is not considered finished just because an ISO builds. It must boot, run the desktop, provide networking, install successfully, and pass the release validation checklist.

## Current Status

**Stage:** Development / production build foundation

Current foundation:

- Ubuntu 24.04 LTS base
- live-build configuration
- XFCE desktop package set
- Calamares installer package set
- NebulaOS project identity
- build / clean / release helper scripts
- shell/config validation
- security and production-build documentation

Next engineering focus:

1. Build a reliable DevOps tool layer.
2. Implement NebulaOS system identity and branding.
3. Add deterministic hooks and default configuration.
4. Test the live ISO in a VM.
5. Test installation with Calamares.
6. Add DevOps smoke tests.
7. Establish the Alpha release gate.
8. Move toward Beta and Release Candidate builds.

## Development Workflow

Use short-lived feature branches for changes:

```text
feature
   ↓
validate
   ↓
pull request
   ↓
review
   ↓
master
   ↓
build + test
   ↓
release
```

Examples:

```text
feature/devops-tooling
feature/nebula-branding
feature/installer
feature/security-hardening
feature/observability
feature/release-engineering
```

## Documentation

The repository contains engineering documentation under `docs/` and production build guidance in:

- `PRODUCTION_BUILD.md`
- `SECURITY.md`
- `docs/learning/`

The old `week1/` and `week2/` course folders have been removed. The repository is now organized around the **NebulaOS product and its engineering lifecycle**, not a weekly course structure.

## License

See the repository license for the current licensing terms.
