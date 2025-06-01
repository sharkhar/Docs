1. Clone and Build Docker Image (if you're using Docker):
   ```
   git clone https://github.com/aquasecurity/trivy-ui.git
   cd trivy-ui
   docker build -t trivy-ui:local .
   ```
2. Download Trivy and Vulnerability DB:
   ```
  mkdir -p trivy-cache
  trivy --cache-dir ./trivy-cache --download-db-only
   ```
3. Run Trivy-UI Container:
  ```
  docker run -d -p 8080:8080 \
  -v $(pwd)/trivy:/app/trivy \
  -v $(pwd)/trivy-cache:/app/trivy-cache \
  -e TRIVY_CACHE_DIR=/app/trivy-cache \
  trivy-ui:local
  ```
4. Access UI:
  ```
  Open browser to: http://<your-node-ip>:8080
  ```
