#!/bin/bash
# Kubernetes testing script for Task 3
# Run this script after starting minikube: minikube start

set -e

echo "=========================================="
echo "Testing Kubernetes Configuration"
echo "=========================================="

# Validate YAML files
echo ""
echo "1. Validating Kubernetes manifests..."
kubectl apply --dry-run=client -f kubernetes/deployment.yaml
kubectl apply --dry-run=client -f kubernetes/service.yaml
echo "✅ YAML validation successful"

# Apply manifests
echo ""
echo "2. Applying Kubernetes manifests..."
kubectl apply -f kubernetes/
echo "✅ Manifests applied successfully"

# Wait for deployment to be ready
echo ""
echo "3. Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/flask-app
echo "✅ Deployment is ready"

# Check deployment status
echo ""
echo "4. Checking deployment status..."
kubectl get deployments flask-app

# Check pods
echo ""
echo "5. Checking pods..."
kubectl get pods -l app=flask-app

# Check service
echo ""
echo "6. Checking service..."
kubectl get services flask-app-service

# Describe deployment to show rolling update strategy
echo ""
echo "7. Deployment details (rolling update strategy)..."
kubectl describe deployment flask-app | grep -A 5 "StrategyType\|RollingUpdate"

# Test scaling
echo ""
echo "8. Testing scaling - scaling to 7 replicas..."
kubectl scale deployment flask-app --replicas=7
sleep 5
kubectl get pods -l app=flask-app

echo ""
echo "9. Scaling back to 5 replicas..."
kubectl scale deployment flask-app --replicas=5
sleep 5
kubectl get pods -l app=flask-app

# Get service URL for minikube
echo ""
echo "10. Service access information..."
NODE_IP=$(minikube ip)
NODE_PORT=$(kubectl get service flask-app-service -o jsonpath='{.spec.ports[0].nodePort}')
echo "✅ Service accessible at: http://$NODE_IP:$NODE_PORT"
echo "   Or use: minikube service flask-app-service --url"

echo ""
echo "=========================================="
echo "✅ All tests completed successfully!"
echo "=========================================="

