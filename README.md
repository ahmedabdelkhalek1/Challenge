# ITI GCP Challenge 2025 - Infrastructure and Deployment

This repository contains the complete infrastructure setup and application deployment for the ITI GCP Challenge 2025. The infrastructure is built using Terraform modules and deploys a secure, private GCP environment.

## Architecture Diagram
![GKE Cluster](/images/private%20gke%20cluster.jpg)

## Architecture Overview

The infrastructure includes:

1. **VPC Network** with two subnets:
   - **Management Subnet**: Contains a private VM with NAT gateway for internet access
   - **Restricted Subnet**: Contains GKE cluster with no internet access

2. **Private GKE Cluster**: 
   - Private control plane and nodes
   - Custom service account (not default compute SA)
   - Authorized networks restricted to management subnet only
   - Uses secondary IP ranges for pods and services

3. **Artifact Registry**: Private container registry for storing Docker images

4. **Private VM**: Management instance in the management subnet for cluster access

5. **Application**: Python Tornado web app with Redis, exposed via HTTP Load Balancer

## Key Security Features

- ✅ Restricted subnet has NO internet access
- ✅ GKE cluster uses private control plane and private nodes
- ✅ Custom service account for GKE nodes (not default compute SA)
- ✅ All container images pulled from private Artifact Registry
- ✅ Management VM is private (no external IP)
- ✅ Only management subnet can access GKE cluster (authorized networks)
- ✅ Application exposed to public internet via HTTP Load Balancer

## Prerequisites

1. GCP Project with billing enabled
2. Terraform >= 1.0 installed
3. Google Cloud SDK installed and authenticated
4. Required GCP APIs enabled:
   - Compute Engine API
   - Kubernetes Engine API
   - Artifact Registry API
   - Cloud Resource Manager API
   - IAM Service Account Credentials API

## Quick Start

### 1. Enable Required APIs

```bash
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable artifactregistry.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable iamcredentials.googleapis.com
```

### 2. Configure Terraform Variables

```bash
cd terraform
nano terraform.tfvars
# Put your values in the tfvars file 
```

### 3. Deploy Infrastructure

```bash
terraform init
terraform plan
terraform apply
```

### 4. Build and Deploy Application

After infrastructure deployment:

1. **Connect to Management VM:**
   ```bash
   gcloud compute ssh management-vm --zone=us-central1-a --tunnel-through-iap
   ```

2. **Clone the repository and build Docker image:**
   ```bash
   # On the management VM
   git clone <your-repo-url>
   cd <repo-directory>
   
   # Configure Docker for Artifact Registry
   gcloud auth configure-docker us-central1-docker.pkg.dev
   
   # Build and push the image
   docker build -t us-central1-docker.pkg.dev/YOUR_PROJECT_ID/iti-docker-repo/python-app:latest .
   docker push us-central1-docker.pkg.dev/YOUR_PROJECT_ID/iti-docker-repo/python-app:latest
   ```

3. **Connect to GKE cluster:**
   ```bash
   gcloud container clusters get-credentials iti-private-cluster --zone=us-central1-a
   ```
4. **Apply K8s Files**
   ```bash
   cd kubernetes
   kubectl apply -f redis-deployment.yaml
   kubectl apply -f python-app-deployment.yaml
   kubectl apply -f ingress.yaml

5. **Verify deployment:**
   ```bash
   kubectl get pods
   kubectl get services
   kubectl get ingress
   ```

## Infrastructure Components

### Network Module (`modules/network/`)
- VPC with custom subnets
- NAT Gateway for management subnet
- Firewall rules for security
- Secondary IP ranges for GKE

### IAM Module (`modules/iam/`)
- Custom service account for GKE nodes
- Proper IAM roles and permissions
- Service account for management VM

### Artifact Registry Module (`modules/artifact-registry/`)
- Private Docker repository
- IAM policies for access control

### Compute Module (`modules/compute/`)
- Private VM in management subnet
- Pre-installed tools (Docker, kubectl, gcloud)
- IAP access configuration

### GKE Module (`modules/gke/`)
- Private GKE cluster with custom configuration
- Node pool with autoscaling
- Security and monitoring configurations

## Application Details

The application is a Python Tornado web server that:
- Connects to Redis for state management
- Displays a counter that increments on each page load
- Shows the current environment
- Includes health checks and proper resource limits

### Application Environment Variables
- `REDIS_HOST`: Redis service hostname
- `REDIS_PORT`: Redis port (6379)
- `REDIS_DB`: Redis database number (0)
- `ENVIRONMENT`: Current environment (production)
- `PORT`: Application port (8080)
- `HOST`: Bind address (0.0.0.0)

## Security Considerations

1. **Network Isolation**: Restricted subnet cannot access internet
2. **Private Endpoints**: GKE control plane is private
3. **Authorized Networks**: Only management subnet can access GKE
4. **Service Accounts**: Custom SAs with minimal required permissions
5. **Container Security**: Images from private registry only
6. **VM Security**: Private VM with IAP access

## Monitoring and Observability

- GKE cluster has logging and monitoring enabled
- Application includes liveness and readiness probes
- Resource limits set for all containers
- Structured logging to Google Cloud Logging

## Clean Up

To destroy all resources:

```bash
cd terraform
terraform destroy
```

**Note**: This will delete all infrastructure including data. Make sure to backup any important data before running destroy.
