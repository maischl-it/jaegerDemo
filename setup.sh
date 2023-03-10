#!/bin/env sh

kind create cluster --name jaeger-demo

# Install cert-manager (Prerequisite of jaeger)
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.1/cert-manager.crds.yaml
helm repo add jetstack https://charts.jetstack.io --force-update
helm install cert-manager jetstack/cert-manager -n cert-manager --create-namespace --version v1.10.1

# Install jaeger-operator & wait for pod to become ready
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts --force-update
helm install jaeger jaegertracing/jaeger-operator --set rbac.clusterRole=true -n observability --create-namespace
kubectl wait pod -n observability -l app.kubernetes.io/instance=jaeger --for condition=Ready --timeout=60s

# Deploy Jaeger all in one
kubectl apply -f jaeger.yaml
