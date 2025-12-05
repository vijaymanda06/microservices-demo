#!/bin/bash

# Create namespace
kubectl create namespace argocd

# Install Argo CD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for pods to be ready
echo "Waiting for Argo CD pods to start..."
kubectl wait --for=condition=available deployment -l "app.kubernetes.io/name=argocd-server" -n argocd --timeout=300s

# Patch Argo CD Server to be accessible via NodePort (or LoadBalancer if K3s supports it)
# For local K3s/VMs, NodePort is often easiest if LoadBalancer isn't set up.
# But since this is a "Production" demo, let's try LoadBalancer first, 
# and if that stays pending, we can use port-forwarding.
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

echo "Argo CD installed!"
echo "Get the initial admin password with:"
echo "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d; echo"
