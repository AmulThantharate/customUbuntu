# NebulaOS build troubleshooting

## Day 4 build findings

### Noble was not propagated into generated live-build state

The maintained `auto/config` explicitly sets:

- `--distribution noble`
- `--parent-distribution noble`
- `--parent-debian-installer-distribution noble`
- `--debian-installer none`
- `--debian-installer-distribution noble`

After changing live-build configuration, regenerate the generated configuration before building:

```sh
sudo ./scripts/clean.sh
sudo ./auto/config
sudo ./scripts/validate.sh
```

Do not manually edit generated files under `config/`.

### Ubuntu Universe packages were unavailable

The build initially generated APT sources containing only `main` and `restricted`. That made packages such as XFCE, Calamares, Podman, Buildah and other DevOps tooling appear unavailable.

The maintained configuration now sets both:

```
--archive-areas "main restricted universe multiverse"
--parent-archive-areas "main restricted universe multiverse"
```

The generated configuration should contain:

```
LB_ARCHIVE_AREAS="main restricted universe multiverse"
LB_PARENT_ARCHIVE_AREAS="main restricted universe multiverse"
```

### External DevOps CLIs

Terraform, Helm and the upstream Kubernetes CLI distribution are intentionally not listed in the Ubuntu-native package manifest yet. Their installation should be handled through dedicated, version-pinned external package sources rather than assuming arbitrary package names exist in the Ubuntu Noble archive.

This keeps the first Alpha build dependent only on the configured Ubuntu archives. External tool integration can be added as a separate release-engineering change.

## Build log behavior

Build logs are stored under `build-logs/`.

For live monitoring from another terminal:

```sh
tail -f build-logs/*.log
```

The build script now returns a non-zero status when `lb config` or `lb build` fails; it no longer reports a successful build merely because `tee` completed successfully.
