# PowerShell script for testing Kubernetes configuration
# Prerequisites: minikube must be running (minikube start)
# Usage: .\kubernetes\test_kubernetes.ps1

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Testing Kubernetes Configuration" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Check if minikube is running
Write-Host ""
Write-Host "Checking minikube status..." -ForegroundColor Yellow
$minikubeStatus = minikube status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Minikube is not running!" -ForegroundColor Red
    Write-Host "Please start minikube first: minikube start" -ForegroundColor Yellow
    exit 1
}
Write-Host "✅ Minikube is running" -ForegroundColor Green

# 1. Validate YAML files
Write-Host ""
Write-Host "1. Validating Kubernetes manifests..." -ForegroundColor Yellow
kubectl apply --dry-run=client -f kubernetes/deployment.yaml
kubectl apply --dry-run=client -f kubernetes/service.yaml
Write-Host "✅ YAML validation successful" -ForegroundColor Green

# 2. Apply manifests
Write-Host ""
Write-Host "2. Applying Kubernetes manifests..." -ForegroundColor Yellow
kubectl apply -f kubernetes/
Write-Host "✅ Manifests applied successfully" -ForegroundColor Green

# 3. Wait for deployment to be ready
Write-Host ""
Write-Host "3. Waiting for deployment to be ready..." -ForegroundColor Yellow
kubectl wait --for=condition=available --timeout=300s deployment/flask-app
Write-Host "✅ Deployment is ready" -ForegroundColor Green

# 4. Check deployment status
Write-Host ""
Write-Host "4. Checking deployment status..." -ForegroundColor Yellow
kubectl get deployments flask-app

# 5. Check pods
Write-Host ""
Write-Host "5. Checking pods..." -ForegroundColor Yellow
kubectl get pods -l app=flask-app

# 6. Check service
Write-Host ""
Write-Host "6. Checking service..." -ForegroundColor Yellow
kubectl get services flask-app-service

# 7. Show rolling update strategy
Write-Host ""
Write-Host "7. Deployment details (rolling update strategy)..." -ForegroundColor Yellow
kubectl describe deployment flask-app | Select-String -Pattern "StrategyType|RollingUpdate" -Context 2

# 8. Test scaling
Write-Host ""
Write-Host "8. Testing scaling - scaling to 7 replicas..." -ForegroundColor Yellow
kubectl scale deployment flask-app --replicas=7
Start-Sleep -Seconds 5
kubectl get pods -l app=flask-app

Write-Host ""
Write-Host "9. Scaling back to 5 replicas..." -ForegroundColor Yellow
kubectl scale deployment flask-app --replicas=5
Start-Sleep -Seconds 5
kubectl get pods -l app=flask-app

# 10. Get service URL
Write-Host ""
Write-Host "10. Service access information..." -ForegroundColor Yellow
$nodeIP = minikube ip
$nodePort = kubectl get service flask-app-service -o jsonpath='{.spec.ports[0].nodePort}'
Write-Host "✅ Service accessible at: http://$nodeIP`:$nodePort" -ForegroundColor Green
Write-Host "   Or use: minikube service flask-app-service --url" -ForegroundColor Cyan

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "✅ All tests completed successfully!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan

