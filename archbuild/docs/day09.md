# Day 9 — DevOps Package Layer

## Goal

Turn the base Arch ISO into the DevOps-focused NebulaOS environment.

## Tasks

Add and verify the required DevOps tools in packages.x86_64.

Target categories:

- Git
- container tooling
- kubectl
- OpenShift oc
- Helm
- Terraform
- Ansible
- jq
- YAML/JSON tools
- tmux
- SSH and networking tools

Review package availability before adding each package.

## Commands

    cd ~/nebulaos/archbuild
    nano profile/packages.x86_64

Review the final package list:

    cat profile/packages.x86_64

## Expected result

The profile contains a deliberate DevOps toolset instead of an arbitrary collection of packages.
