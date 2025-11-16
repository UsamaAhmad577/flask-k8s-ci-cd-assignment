#!/bin/bash
# Test rollback functionality
# This script demonstrates kubectl rollout undo

echo "=========================================="
echo "Testing Rollback Functionality"
echo "=========================================="

echo ""
echo "1. Current deployment revision..."
kubectl rollout history deployment/flask-app

echo ""
echo "2. Updating deployment image (simulating update)..."
kubectl set image deployment/flask-app flask-app=flask-app:v2 --record

echo ""
echo "3. Waiting for rollout..."
kubectl rollout status deployment/flask-app

echo ""
echo "4. Testing rollback..."
kubectl rollout undo deployment/flask-app

echo ""
echo "5. Waiting for rollback to complete..."
kubectl rollout status deployment/flask-app

echo ""
echo "6. Rollback history..."
kubectl rollout history deployment/flask-app

echo ""
echo "=========================================="
echo "✅ Rollback test completed!"
echo "=========================================="

