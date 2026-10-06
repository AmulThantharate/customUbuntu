# Day 14 — Clean Build and Arch Release Candidate

## Goal

Prove that NebulaOS Arch can be rebuilt cleanly and produce a release candidate.

## Tasks

1. Start from a clean build state.
2. Run the repository clean script.
3. Run the repository validation script.
4. Run the build script.
5. Generate SHA-256 checksums.
6. Boot-test the final ISO.
7. Confirm the expected DevOps tools are present.
8. Record the final ISO name, size, checksum, and known limitations.

## Final flow

    ./scripts/clean.sh
    ./scripts/validate.sh
    ./scripts/build.sh
    sha256sum ./out/*.iso

## Expected result

A clean, reproducible NebulaOS Arch ISO is produced and validated as a release candidate.
