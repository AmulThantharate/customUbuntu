# Day 2 - live-build lifecycle

## Goal

Understand the build pipeline and verify that the repository's maintained `auto/config` is compatible with the installed live-build version.

## Important: do not delete `auto/`

The `auto/` directory is part of the live-build configuration. In this project, `auto/config` is intentionally maintained and calls:

```text
lb config noauto ...
```

Do **not** run:

```bash
rm -rf auto/
```

and do not put `lb config` inside `auto/config`. That would create recursion.

The project also deliberately does **not** use the unsupported `--bootloaders` option because the target build environment uses live-build `3.0~a57-1`.

## First, make sure you are on the maintained branch

If you are following the production-ready repository:

```bash
git status
git branch --show-current
git pull --ff-only
```

Then inspect:

```bash
grep -n -- '--bootloaders' auto/config || true
cat auto/config
lb --version
```

The maintained `auto/config` should contain `lb config noauto` and should **not** contain `--bootloaders`.

## Build lifecycle

```
lb config
  -> bootstrap
  -> chroot
  -> binary
  -> ISO
```

Understand the difference between configuration, package installation, chroot customization, and ISO generation.

## Commands

From the repository root:

```bash
sudo ./scripts/clean.sh
sudo lb config
```

`lb config` will execute the maintained `auto/config`. The script itself uses `lb config noauto`, which prevents live-build from recursively executing `auto/config`.

If configuration succeeds, inspect the generated configuration and directories.

## If you see this error

```
lb config: unrecognized option '--bootloaders'
```

Stop. Do **not** delete `auto/`.

Your local checkout is using an old `auto/config`. Restore the repository version:

```bash
git restore auto/config
```

If your branch does not contain the production-ready `auto/config`, update your checkout first:

```bash
git fetch origin
git checkout master
git pull --ff-only
```

Then verify:

```bash
grep -n -- '--bootloaders' auto/config || true
```

The command should produce no output.

## Task

Run configuration without starting a full ISO build. Record which generated directories and files appear.

Then explain:

1. Why `lb config` invokes `auto/config`.
2. Why `auto/config` uses `lb config noauto`.
3. Why `--bootloaders` is omitted from this project's maintained configuration.
4. What `lb build` does after configuration.

## Done when

You can explain why `lb config` prepares the build, why the `auto/config` wrapper is non-recursive, and how `lb build` performs the actual build.