# Day 12 — Build, Clean and Validate Scripts

## Goal

Stop relying on manually repeated commands and make the Arch build repeatable.

## Tasks

Create:

    archbuild/scripts/build.sh
    archbuild/scripts/clean.sh
    archbuild/scripts/validate.sh

The build script should run mkarchiso using the repository profile and output directory.

The clean script should remove generated build/output state safely.

The validate script should check the profile structure, required files, executable scripts, and expected build artifacts.

## Expected result

The Arch NebulaOS build can be run through predictable repository scripts.
