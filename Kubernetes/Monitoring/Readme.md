
 1. Metrics Server
```    
    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```    
or
```   
    kubectl apply -f components.yaml
```   
 3. Create a ServiceAccount with Permissions
```   
    kubectl apply -f prometheus-sa.yaml
```   
 4. prometheus Secret
```   
    kubectl apply -f prometheus-remote-token.yaml
```   
5.  Create token and token file
```   
    SECRET=$(kubectl -n kube-system get sa prometheus-remote -o jsonpath="{.secrets[0].name}")
 kubectl -n kube-system get secret $SECRET -o jsonpath="{.data.token}" | base64 -d > /etc/prometheus/kubelet.token
```   
 6. prometheus.yaml

```yaml
scrape_configs:
  - job_name: 'kubelet'
    scheme: https
    metrics_path: /metrics
    bearer_token_file: /etc/prometheus/kubelet.token
    tls_config:
      insecure_skip_verify: true  # Accept self-signed certs (or configure proper CA)
    static_configs:
      - targets:
          - 192.168.122.121:10250  # Replace with your node's IP
```

To scrape container stats (like CPU/mem per pod), add:

```yaml
- job_name: 'kubelet-cadvisor'
  scheme: https
  metrics_path: /metrics/cadvisor
  bearer_token_file: /etc/prometheus/kubelet.token
  tls_config:
    insecure_skip_verify: true
  static_configs:
    - targets:
        - 192.168.122.121:10250
```
6. URLs:
   
    https://192.168.122.121:10250/metrics
   
    https://192.168.122.121:10250/metrics/cadvisor
