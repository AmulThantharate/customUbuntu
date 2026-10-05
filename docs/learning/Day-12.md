# Day 12 - Release engineering

## Goal

Turn a tested ISO into a traceable release artifact.

## Learn

```
source
 -> validation
 -> build
 -> test
 -> checksum
 -> release
```

## Commands

```bash
sudo ./scripts/build.sh
sudo ./scripts/release.sh
cat SHA256SUMS
```

## Task

Record:
- NebulaOS version
- source commit
- build date
- ISO filename
- SHA-256 checksum
- test result

## Future

Learn signed releases, GitHub Releases, SBOM generation, and provenance after the basic release process is stable.

## Done when

Every released ISO can be identified and its checksum independently verified.
