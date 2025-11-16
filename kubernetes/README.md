# Kubernetes Configuration

This directory contains Kubernetes manifests for deploying the Flask application.

## Files

- `deployment.yaml` - Kubernetes Deployment manifest with rolling update strategy
- `service.yaml` - Kubernetes Service manifest (NodePort type) for load balancing

## Features

### Deployment (`deployment.yaml`)
- **Rolling Update Strategy**: Configured with `maxSurge: 2` and `maxUnavailable: 1`
- **Replicas**: 5 replicas for high availability and scaling demonstration
- **Resource Limits**: 
  - Requests: 128Mi memory, 100m CPU
  - Limits: 256Mi memory, 500m CPU
- **Health Probes**: Liveness and readiness probes configured
- **Image Pull Policy**: IfNotPresent for local development with minikube

### Service (`service.yaml`)
- **Type**: NodePort for load balancing and external access
- **Port**: 80 (maps to container port 5000)
- **NodePort**: 30080 (accessible from host machine)

## Testing Locally with Minikube

### Prerequisites
1. Install and start minikube: `minikube start`
2. Ensure kubectl is configured: `kubectl config get-contexts`

### Apply Manifests

```bash
# Apply all manifests
kubectl apply -f kubernetes/

# Verify deployment status
kubectl get pods,services,deployments

# Check deployment details
kubectl describe deployment flask-app
```

### Test Scaling

```bash
# Scale deployment to 7 replicas
kubectl scale deployment flask-app --replicas=7

# Verify scaling
kubectl get pods -l app=flask-app

# Scale back to 5 replicas
kubectl scale deployment flask-app --replicas=5
```

### Test Rollback

```bash
# View rollout history
kubectl rollout history deployment/flask-app

# Simulate an update (change image or any other field)
kubectl set image deployment/flask-app flask-app=flask-app:v2 --record

# Rollback to previous revision
kubectl rollout undo deployment/flask-app

# Check rollback status
kubectl rollout status deployment/flask-app
```

### Access the Service

```bash
# Get the service URL
minikube service flask-app-service --url

# Or access via NodePort
# Get minikube IP
minikube ip

# Access at: http://<minikube-ip>:30080
```

### Using Test Scripts

#### PowerShell (Windows)
```powershell
.\kubernetes\test_kubernetes.ps1
```

#### Bash (Linux/Mac)
```bash
chmod +x kubernetes/test_kubernetes.sh
./kubernetes/test_kubernetes.sh
```

## Verification Commands

```bash
# Check deployment rollout strategy
kubectl describe deployment flask-app | grep -A 5 "StrategyType\|RollingUpdate"

# Check resource limits
kubectl describe deployment flask-app | grep -A 5 "Limits\|Requests"

# Check service type and ports
kubectl get service flask-app-service -o yaml

# View all resources
kubectl get all -l app=flask-app
```

## Rolling Update Strategy

The deployment uses a RollingUpdate strategy with:
- **maxSurge: 2** - Maximum number of pods that can be created above the desired replica count during update
- **maxUnavailable: 1** - Maximum number of pods that can be unavailable during update

This ensures:
- Zero-downtime deployments
- Gradual rollout of new versions
- Automatic rollback on failure

## Cleanup

```bash
# Delete all resources
kubectl delete -f kubernetes/

# Or delete individually
kubectl delete deployment flask-app
kubectl delete service flask-app-service
```

