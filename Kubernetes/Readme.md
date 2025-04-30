- Prometheus and Grafana run outside the Kubernetes cluster
- You want to monitor container resource metrics (CPU, memory, network) using cAdvisor
- cAdvisor is deployed inside the cluster
- Prometheus scrapes metrics using a Bearer token

# Solution Summary
We’ll:
- Deploy cAdvisor as a DaemonSet in the cluster
- Expose it via NodePort so Prometheus can reach it
- Use a Kubernetes ServiceAccount + RBAC to generate a Bearer token
- Configure Prometheus (outside cluster) to scrape cAdvisor metrics securely using that token

  # Step 1: Deploy cAdvisor as DaemonSet
Here’s a working cadvisor.yaml: 

Apply it:
```
kubectl create namespace monitoring
kubectl apply -f cadvisor.yaml
```
# Step 2: Create ServiceAccount + Token Secret for Prometheus
prometheus-remote-token.yaml
Apply it:
```
kubectl apply -f prometheus-remote-token.yaml
```
# Step 3: Extract the Bearer Token
```
kubectl -n kube-system get secret prometheus-remote-token -o jsonpath="{.data.token}" | base64 -d > /etc/prometheus/kubelet.token
```
# Step 4: Add to Prometheus Config (outside cluster)
In prometheus.yml:
```
scrape_configs:
  - job_name: 'cadvisor'
    scheme: http
    bearer_token_file: /etc/prometheus/kubelet.token
    static_configs:
      - targets:
          - 192.168.122.121:30080  # Replace with your node IP
```
# Step 5: Import Grafana Dashboard
In Grafana:
Go to "Import"
Use Dashboard ID: 14282 (cAdvisor - Full Metrics)
Choose your Prometheus data source

# Test the Setup
From the Prometheus server:
```
curl -H "Authorization: Bearer $(cat /etc/prometheus/kubelet.token)" http://192.168.122.121:30080/metrics
```
