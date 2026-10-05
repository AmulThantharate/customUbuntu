# Day 13 - Security

## Goal

Understand the security model of a Linux distribution.

## Learn

- APT repository signatures
- GPG keys
- sudo and least privilege
- users/groups
- file permissions
- systemd services
- AppArmor
- SSH hardening
- firewall concepts
- ISO checksum and signing

## Rules

- Never commit private signing keys.
- Never embed passwords or tokens in the repository.
- Do not execute remote scripts without reviewing and pinning their source.
- Prefer upstream signed packages.

## Task

Review the build tree for secrets and unnecessary privileged operations. Read `SECURITY.md`.

## Done when

You can explain how package authenticity, release integrity, and runtime privilege are protected.
