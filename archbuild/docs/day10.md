# Day 10 — DevOps and Network Testing

## Goal

Verify that the DevOps tools actually work inside the ISO.

## Tasks

1. Boot the newly built ISO.
2. Check Git.
3. Check container tooling.
4. Check kubectl.
5. Check OpenShift oc.
6. Check Helm.
7. Check Terraform.
8. Check Ansible.
9. Check jq and tmux.
10. Test DNS, routes, interfaces, and SSH client functionality.

## Example checks

    git --version
    kubectl version --client
    oc version --client
    helm version
    terraform version
    ansible --version
    jq --version
    tmux -V
    ip addr
    ip route
    getent hosts archlinux.org

## Expected result

The important DevOps commands are installed and executable, and basic networking works.
