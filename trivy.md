Setting up **Trivy** in a **GAP (air-gapped) environment** — where there’s no internet access — requires a few extra steps to **pre-download and transfer vulnerability databases and binaries** to the isolated environment.

---

## 🎯 Goal:

Run `trivy` in an air-gapped (GAP) environment to scan container images, filesystems, and source code for vulnerabilities.

---

## ✅ Steps Overview:

### 1. **Download Trivy Binary (Outside GAP)**

From a connected environment:

```bash
TRIVY_VERSION=$(curl -s "https://api.github.com/repos/aquasecurity/trivy/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
curl -LO https://github.com/aquasecurity/trivy/releases/download/${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz
tar -xzf trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz
```

Transfer the `trivy` binary into the GAP environment (e.g., via USB, secure SCP, etc.).

---

### 2. **Download Trivy Vulnerability Database (DB)**

#### Option A: File-based DB (simpler)

Trivy uses a local vulnerability DB stored in a BoltDB file.

On the connected machine:

```bash
# Create a cache directory
mkdir -p trivy-cache

# Pull the database into a directory
trivy --cache-dir ./trivy-cache image alpine:latest
```

Transfer the **entire `trivy-cache/` directory** to the air-gapped environment.

---

### 3. **Run Trivy in Offline Mode (In GAP)**

Inside the air-gapped environment:

```bash
export TRIVY_OFFLINE_SCAN=true
./trivy --cache-dir ./trivy-cache image myimage:latest
```

> 💡 You can also scan filesystem paths, Docker archives, or tarballs.

---

### 4. **Optional: Scan Docker Images without Internet**

If you have Docker images saved as tarballs:

```bash
docker save -o myimage.tar myimage:latest
./trivy image --input myimage.tar --cache-dir ./trivy-cache
```

---

### 5. **Keep DB Updated**

You’ll need to periodically **re-download** the cache (`trivy-cache`) on an internet-connected system to keep CVEs up to date. Consider automating this with a cron job.

```bash
# Update Trivy DB
trivy --download-db-only --cache-dir ./trivy-cache
```

Then transfer again into the GAP environment.

---

## 🚫 Notes and Pitfalls

* Avoid using Trivy’s **client-server mode** in GAP unless you’ve mirrored all components.
* If scanning for misconfigurations (e.g., IaC, Kubernetes YAML), you don’t need container runtime — just pass local files.
* Make sure the `trivy` binary and DB versions are aligned.

---

Would you like a shell script to automate the **download and transfer preparation** on the connected side?
