# What is this?

In this repo I am holding some sample scripts to build a demo infrastructure to host containers. Right now, there is only a script to deploy an Azure Kubernetes Service (AKS) and an Azure Container Registry.

## Preliminaries
You need to have the following tools installed

- az cli
- kubectl

## Setup

```bash
# Login to your Azure account and select the subscription you want to use
az login
```

To make everything run you need to clone 3 repos, this one, the frontend and the backend-api

```bash
mkdir tasks && cd tasks

git clone git@github.com:devndive/tasks-infrastructure.git
git clone git@github.com:devndive/tasks-frontend.git
git clone git@github.com:devndive/tasks-backend-api.git

cd tasks-infrastructure
./create-infrastructure.sh

kubectl apply -f ./deployment.yaml
```
