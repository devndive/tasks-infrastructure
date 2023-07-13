#!/bin/bash
# fail on any error
set -e

# Print the commands being executed
set -x

# Create infrasturcture for the project

# Variables
RNG="$(openssl rand -hex 5)"

RESOURCE_GROUP="rg-aks-demo-${RNG}"
CLUSTER_NAME="aks-cluster-${RNG}"
LOCATION="northeurope"
ACR_NAME="aksdemoacr${RNG}"

# Create a resource group
az group create \
    --name $RESOURCE_GROUP \
    --location $LOCATION

# Create a container registry
az acr create \
    --resource-group $RESOURCE_GROUP \
    --name $ACR_NAME \
    --sku Basic \
    --admin-enabled true

# Create an AKS cluster with one node and connect it to the ACR
az aks create \
    --resource-group $RESOURCE_GROUP \
    --name $CLUSTER_NAME \
    --node-count 1 \
    --enable-addons monitoring \
    --attach-acr $ACR_NAME

# Get the credentials for the cluster
az aks get-credentials \
    --resource-group $RESOURCE_GROUP \
    --name $CLUSTER_NAME

# Build frontend image and push it to the ACR
az acr build \
    --registry $ACR_NAME \
    --image $ACR_NAME.azurecr.io/frontend:v1 \
    --file ./frontend/Dockerfile \
    ./frontend

# Build backendapi image and push it to the ACR
az acr build \
    --registry $ACR_NAME \
    --image $ACR_NAME.azurecr.io/backend-api:v1 \
    --file ./backend-api/Dockerfile \
    ./backend-api