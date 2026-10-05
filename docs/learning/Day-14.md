# Day 14 - Final NebulaOS release

## Goal

Perform a clean end-to-end release candidate build.

## Final sequence

```bash
./scripts/validate.sh
sudo ./scripts/clean.sh
sudo ./scripts/build.sh
sudo ./scripts/release.sh
```

Then test the resulting ISO in a fresh VM.

## Release gate

The release candidate should pass:
- shell/config validation
- clean build
- ISO generation
- BIOS/UEFI tests as applicable
- live desktop test
- networking test
- Calamares installation test
- installed-system boot test
- basic package smoke tests
- SHA-256 generation
- documentation review

## Final task

Create a release checklist and record failures. Fix the root cause, rebuild from clean state, and repeat the tests.

## Done when

You can give someone the repository and release artifact and explain exactly how NebulaOS was built, tested, and verified.
