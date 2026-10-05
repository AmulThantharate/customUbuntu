# Day 4 - Build hooks

## Goal

Learn how to execute configuration commands while the image is being built.

## Learn

Hooks are for actions that cannot be expressed cleanly as package lists.

Typical uses:
- create directories
- configure services
- create users
- install local configuration
- prepare defaults

## Task

Inspect any existing hook directories:

```bash
find config/hooks -maxdepth 3 -type f -print 2>/dev/null
```

Design one small hook that is deterministic and safe to run during a build.

## Rules

- Keep hooks idempotent where practical.
- Do not download untrusted scripts and execute them blindly.
- Do not put secrets in hooks.

## Done when

You can explain when a package list is better than a hook.
