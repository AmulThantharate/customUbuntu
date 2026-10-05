# NebulaOS DevOps Linux Plan

NebulaOS is being developed as a real DevOps-focused Linux distribution built from Ubuntu 24.04 LTS.

## Engineering layers

1. Base system — kernel, system services, networking, certificates, shells and core utilities.
2. Desktop — lightweight graphical environment and administration tools.
3. DevOps layer — Git, containers, Kubernetes tooling, Helm, Terraform, Ansible and related operational utilities.
4. Installer — Calamares and disk-management support.
5. Release engineering — validation, ISO builds, checksums, testing and release gates.

## Alpha priorities

- Keep the base image stable and maintainable.
- Add DevOps tooling in a dedicated package list instead of mixing it into the base layer.
- Prefer distribution-managed packages where practical.
- Handle external vendor tools through controlled, versioned installation logic.
- Add smoke tests for core DevOps commands.
- Boot-test the generated ISO in a VM.
- Validate installation through Calamares before declaring an Alpha release.

## Release path

Development → Alpha → Beta → Feature Freeze → Release Candidate → Final Release → Point/Security Releases

## Build gate

Before an Alpha build:

```text
./scripts/validate.sh
sudo ./scripts/clean.sh
sudo ./scripts/build.sh
sudo ./scripts/release.sh
```

The build must produce a bootable ISO, a SHA-256 checksum, and a testable VM artifact before release promotion.