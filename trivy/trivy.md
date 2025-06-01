1. Download Trivy Binary
   url :
   https://github.com/aquasecurity/trivy/releases/
   
   ```
   curl -LO https://github.com/aquasecurity/trivy/releases/download/v0.63.0/trivy_0.63.0_Linux-64bit.deb
   tar -xzf trivy_0.63.0_Linux-64bit.tar.gz
   ```
2. Download Trivy Vulnerability Database (DB)
  ```
  # Create a cache directory
  mkdir -p trivy-cache

  # Pull the database into a directory
  trivy --cache-dir ./trivy-cache image alpine:latest
  ```
3. Run Trivy in Offline Mode (In GAP)
  ```
  export TRIVY_OFFLINE_SCAN=true
  ./trivy --cache-dir ./trivy-cache image myimage:latest
  ```
4. Keep DB Updated
  ```
  # Update Trivy DB
  trivy --download-db-only --cache-dir ./trivy-cache
  ```

## Download Trivy Database
1. Let Trivy use it automatically
No action needed — Trivy will select the best mirror automatically based on availability and performance.

2. Manually specify it
  ```
`./trivy \
  --cache-dir ./trivy-cache \
  --db-repository mirror.gcr.io/aquasec/trivy-db \
  image alpine:latest
  ```
Or in an air-gapped setup
  ```
  docker pull mirror.gcr.io/aquasec/trivy-db:2
  docker create --name trivydb mirror.gcr.io/aquasec/trivy-db:2
  docker cp trivydb:/trivy.db ./trivy.db
  docker rm trivydb
  ```
Then point Trivy to use the file with:
  ```
  ./trivy --cache-dir ./trivy-cache --db-repository mirror.gcr.io/aquasec/trivy-db --skip-db-update image alpine:latest
  ```
or
  ```
  ./trivy --cache-dir ./trivy-cache --skip-db-update image alpine:latest
  ```
