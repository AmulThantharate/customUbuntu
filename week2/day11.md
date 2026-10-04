# NebulaOS Build Plan — Week 2, Day 11: Custom Package Repositories & Offline Readiness

## Objective
Provide an offline-ready packaging pipeline: configure a local APT repository using `dpkg-scanpackages` or `reprepro` for proprietary or in-house `.deb` packages, wire it into `live-build`, and bundle essential offline documentation and container images directly inside the ISO.

---

## 1. When is a Custom Repository Needed?

You need a custom repository when:
1. You have internal custom Debian packages (e.g., custom VPN clients, corporate root CAs, proprietary DevOps tools).
2. Packages are not published in official Ubuntu repos or standard public PPAs.
3. You want completely reproducible offline builds without querying public internet mirrors at build time.

If all your packages come from Ubuntu, Docker, Kubernetes, HashiCorp, and Helm, this step is **optional**.

---

## 2. Setting Up a Local Flat Repository with `dpkg-scanpackages`

A "flat" repository is the simplest and fastest way to host custom `.deb` packages directly inside your `live-build` tree without configuring complex GPG repository signing keys.

### RUN THIS YOURSELF: Build Local Flat Repository

Run in `~/nebulaos-build`:

```bash
# 1. Install dpkg-dev (provides dpkg-scanpackages)
sudo apt install -y dpkg-dev

# 2. Create custom repository directory in config/
mkdir -p config/archives/custom-debs

# 3. Place your custom .deb packages inside config/archives/custom-debs/
# (Example: copy any proprietary or internal .deb files here)
# cp /path/to/my-custom-tool_1.0.0_amd64.deb config/archives/custom-debs/

# 4. Generate Packages.gz index
cd config/archives/custom-debs
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
cd ../../..

# 5. Wire the local repository into config/archives/local.list.chroot
echo "deb [trusted=yes] copy:/build/config/archives/custom-debs ./" \
    > config/archives/local.list.chroot
```

---

## 3. Alternative: Using `config/packages.chroot/`

`live-build` provides a zero-configuration folder specifically for local `.deb` files: `config/packages.chroot/`.
Any `.deb` placed directly in this directory is automatically installed by `dpkg -i` during the chroot stage without needing a repository index or web server.

### RUN THIS YOURSELF: Direct `.deb` Placement (Recommended)
```bash
mkdir -p config/packages.chroot/
# Drop any independent .deb files here:
# cp my-tool_amd64.deb config/packages.chroot/
```

---

## 4. Offline Readiness Strategy

To make NebulaOS completely usable in air-gapped environments or low-connectivity data centers:

### A. Pre-caching Essential Docker Images
By pre-pulling container images into the Docker daemon during build time, engineers can run Kubernetes/Docker offline immediately on boot.
- `registry.k8s.io/pause:3.9`
- `alpine:latest`
- `busybox:latest`
- `nginx:alpine`

We can add a hook (`05-preload-docker.hook.chroot`) to cache these tarballs in `/var/lib/nebulaos/docker-cache/`.

### B. Offline Documentation & Cheat Sheets
We bundle offline documentation in `/usr/share/doc/nebulaos/`:
- Kubernetes API Reference and Cheat Sheet
- Terraform CLI Reference
- Docker Compose Reference Guide
- NebulaOS Architecture Quickstart

#### RUN THIS YOURSELF: Bundle Offline Guides
```bash
mkdir -p config/includes.chroot/usr/share/doc/nebulaos/

cat << 'EOF' > config/includes.chroot/usr/share/doc/nebulaos/DEVOPS_QUICKSTART.md
# NebulaOS Offline Quickstart Reference

## Docker CLI
- Check status: `sudo systemctl status docker`
- Run container: `docker run -d --name web -p 8080:80 nginx:alpine`
- Compose up: `docker compose up -d`

## Kubernetes (kubectl)
- Context view: `kubectl config get-contexts`
- Cluster info: `kubectl cluster-info`
- Run pod: `kubectl run test --image=busybox --restart=Never -- sleep 3600`

## Terraform
- Init: `terraform init`
- Plan: `terraform plan -out=tfplan`
- Apply: `terraform apply tfplan`

## Helm
- List releases: `helm list -A`
- Package chart: `helm package mychart/`
EOF
```

---

## Next Step
Proceed to [Day 12: Secure Boot MOK Signing & Persistent USB Storage Mode](file:///F:/customUbuntu/week2/day12.md).
