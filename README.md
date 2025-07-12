
# GCP DevOps Challenge - Infrastructure and Application Deployment
## Architecture Diagram
![GKE Cluster](/images/private%20gke%20cluster.jpg)

This repository contains a comprehensive DevOps solution that automates GCP infrastructure provisioning and application deployment. The solution demonstrates best practices in cloud infrastructure, containerization, and CI/CD pipeline implementation.

## 🏗️ Architecture Overview

The solution implements a secure, scalable, and production-ready infrastructure on Google Cloud Platform featuring:

### Infrastructure Components
- **VPC Network** with custom subnets and routing
- **Private GKE Cluster** with secure configuration
- **Bastion Host** for secure cluster access
- **HA Redis (Memorystore)** for data persistence
- **HTTP(S) Load Balancer** for external access
- **Artifact Registry** for container image storage

### Security Features
- ✅ Private GKE cluster with no public endpoints
- ✅ Secure bastion host access
- ✅ Custom firewall rules
- ✅ Service account with minimal permissions
- ✅ Workload Identity for secure authentication
- ✅ Network segmentation and isolation

### Automation & CI/CD
- ✅ Terraform infrastructure as code
- ✅ GitHub Actions CI/CD pipeline
- ✅ Helm chart for application deployment
- ✅ Automated container builds and deployments
- ✅ Remote state management in GCS

## 📋 Prerequisites

Before getting started, ensure you have:

1. **GCP Project** with billing enabled
2. **Terraform** >= 1.0 installed
3. **Google Cloud SDK** installed and authenticated
4. **Docker** installed for local development
5. **kubectl** and **Helm** for Kubernetes management
6. **GitHub repository** for CI/CD pipeline

### Required GCP APIs
Enable the following APIs in your GCP project:

```bash
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable artifactregistry.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable iamcredentials.googleapis.com
gcloud services enable redis.googleapis.com
gcloud services enable servicenetworking.googleapis.com
```

## 🚀 Quick Start

## Infrastructure Setup

### Setting up Workload Identity Federation for GitHub Actions

To allow GitHub Actions to authenticate with GCP without using static credentials, follow these steps to set up Workload Identity Federation:



# 1. Create a Workload Identity Pool
```
gcloud iam workload-identity-pools create ${POOL_NAME} \
    --project=${PROJECT_ID} \
    --location="global" \
    --display-name="GitHub Actions Pool"
```
# 2. Get the Workload Identity Pool ID
```
export POOL_ID=$(gcloud iam workload-identity-pools describe ${POOL_NAME} \
    --project=${PROJECT_ID} \
    --location="global" \
    --format="value(name)")
```
# 3. Create a Workload Identity Provider in the pool
```
gcloud iam workload-identity-pools providers create-oidc ${PROVIDER_NAME} \
    --project=${PROJECT_ID} \
    --location="global" \
    --workload-identity-pool=${POOL_NAME} \
    --display-name="GitHub provider" \
    --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" \
    --issuer-uri="https://token.actions.githubusercontent.com"
```
# 4. Create a Service Account for GitHub Actions
```
gcloud iam service-accounts create ${SERVICE_ACCOUNT_NAME} \
    --project=${PROJECT_ID} \
    --description="Service Account for GitHub Actions to deploy GKE infrastructure" \
    --display-name="GitHub GKE Terraform SA"
```
# 5. Grant necessary IAM roles to the Service Account
# For Terraform to manage GCP resources
```
    --role="roles/container.admin"
    --role="roles/compute.admin"
    --role="roles/iam.serviceAccountUser"
    --role="roles/storage.admin"
    --role="roles/compute.admin"
```
# 6. Allow the GitHub Actions workflow to impersonate the Service Account
```
gcloud iam service-accounts add-iam-policy-binding \
    ${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
    --project=${PROJECT_ID} \
    --role="roles/iam.workloadIdentityUser" \
    --member="principalSet://iam.googleapis.com/${POOL_ID}/attribute.repository/${REPO_NAME}"
```
# 7. Get the Workload Identity Provider resource name
```
export WORKLOAD_IDENTITY_PROVIDER=$(gcloud iam workload-identity-pools providers describe ${PROVIDER_NAME} \
    --project=${PROJECT_ID} \
    --location="global" \
    --workload-identity-pool=${POOL_NAME} \
    --format="value(name)")

echo "Workload Identity Provider: ${WORKLOAD_IDENTITY_PROVIDER}"
echo "Service Account Email: ${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
```

# 8 .Add these values as GitHub repository secrets:
```
- WIF_PROVIDER`: The provider ID from the output above
-`SERVICE_ACCOUNT`: The service account email from the output above
- PROJECT_ID`: Your GCP project ID
- TERRAFORM_VERSION:  
-  WORKING_DIR: 
-  CLUSTER_NAME: 
-  CLUSTER_LOCATION: 

### 1. Clone the Repository

```bash
git clone https://github.com/ahmedabdelkhalek1/Challenge.git
cd Challenge
```

### 2. Configure Terraform Backend

Set up remote state storage:

```bash
# Create GCS bucket for Terraform state
gsutil mb gs://your-terraform-state-bucket

# Update backend configuration in terraform/backend.tf
```

### 3. Configure Variables

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars
```

Required variables:
```hcl
project_id = "your-gcp-project-id"
region     = "us-central1"
zone       = "us-central1-a"
```


### 5. Set Up GitHub Actions

Configure the following repository secrets:
- `GCP_PROJECT_ID`: Your GCP project ID
- `Workload-identity`: Service account key for GitHub Actions
- `GKE_CLUSTER_NAME`: Name of your GKE cluster
- `GKE_CLUSTER_ZONE`: Zone where cluster is deployed

### 6. Deploy Application

Push to main branch to trigger the CI/CD pipeline:

```bash
git add .
git commit -m "Deploy application"
git push origin main
```

## 🏛️ Infrastructure Modules

### Network Module (`terraform/modules/network/`)
- Custom VPC with public and private subnets
- Cloud NAT for internet access from private resources
- Firewall rules for security
- Secondary IP ranges for GKE pods and services

### GKE Module (`terraform/modules/gke/`)
- Private GKE cluster configuration
- Custom node pools with autoscaling
- Network policies for pod security
- Workload Identity enabled

### Bastion Module (`terraform/modules/bastion/`)
- Secure bastion host for cluster access
- Pre-configured with necessary tools
- IAP tunnel access for enhanced security

### Redis Module (`terraform/modules/redis/`)
- High-availability Redis instance (Memorystore)
- Private IP configuration
- Automated backups and monitoring

### Security Module (`terraform/modules/security/`)
- Custom service accounts
- IAM roles and permissions
- Security policies and firewall rules

## 🐳 Application Details

### Demo Application
The demo application is a cloud-native microservice featuring:
- **Language**: Python/Node.js (based on your implementation)
- **Framework**: Flask/Express or similar
- **Database**: Redis for caching and session storage
- **Monitoring**: Health checks and metrics endpoints
- **Containerization**: Multi-stage Docker build

### Application Features
- Health and readiness probes
- Structured logging
- Metrics collection
- Configuration via environment variables

### Helm Chart (`helm/demo-app/`)
- Kubernetes deployment manifests
- Service and ingress configurations
- Horizontal Pod Autoscaler (HPA)

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow (`.github/workflows/`)

The pipeline includes:

1. **Build Stage**
   - Code quality checks
   - Security scanning
   - Docker image build
   - Image vulnerability scanning

2. **Test Stage**
   - Unit tests
   - Integration tests
   - Infrastructure validation

3. **Deploy Stage**
   - Terraform plan and apply
   - Helm chart deployment
   - Smoke tests
   - Rollback on failure

### Workflow Features
- **Workload Identity** for secure GCP authentication
- **Conditional deployments** based on branch
- **Notification integrations** for deployment status

## 📊 Monitoring and Observability

### Monitoring Stack
- **Google Cloud Monitoring** for infrastructure metrics
- **Google Cloud Logging** for centralized log management
- **Kubernetes metrics** via GKE monitoring
- **Application metrics** via custom endpoints

### Alerting
- Resource utilization alerts
- Application error rate monitoring
- Infrastructure health checks
- Automated incident response

## 🛡️ Security Considerations

### Network Security
- Private GKE cluster with no public endpoints
- VPC-native networking with IP aliasing
- Network policies for pod-to-pod communication
- Cloud NAT for controlled internet access

### Access Control
- Workload Identity for pod authentication
- Custom service accounts with minimal permissions
- IAM roles and policies following least privilege
- Secure secrets management

### Container Security
- Multi-stage Docker builds for minimal attack surface
- Regular base image updates
- Container image scanning
- Runtime security policies

## 🔧 Local Development

### Development Setup

```bash
# Install dependencies
pip install -r requirements.txt
# or
npm install

# Run Redis locally
docker run -d -p 6379:6379 redis:alpine

# Run application
python app.py
# or
npm start
```

### Testing

```bash
# Run unit tests
pytest tests/
# or
npm test

# Run integration tests
pytest tests/integration/
```

### Docker Development

```bash
# Build image
docker build -t demo-app .

# Run container
docker run -d -p 8080:8080 --name demo-app demo-app:latest

# Access application
curl http://localhost:8080/health
```

## 🗂️ Project Structure

```
├── terraform/                 # Infrastructure as Code
│   ├── modules/               # Reusable Terraform modules
│   │   ├── network/          # VPC, subnets, firewall
│   │   ├── gke/              # GKE cluster configuration
│   │   ├── bastion/          # Bastion host setup
│   │   └── redis/            # Redis Memorystore
│   ├── environments/         # Environment-specific configs
│   └── main.tf               # Main Terraform configuration
├── helm/                     # Helm charts
│   └── demo-app/            # Application Helm chart
├── .github/                  # GitHub Actions workflows
│   └── workflows/
├── docker/                   # Docker configurations
├── scripts/                  # Deployment and utility scripts
├── tests/                    # Test suite
├── Dockerfile               # Application container
└── README.md               # This file
```

## 🔍 Troubleshooting

### Common Issues

1. **GKE Cluster Access**
   ```bash
   # Connect via bastion host
   gcloud compute ssh bastion-host --zone=us-central1-a
   
   # Get cluster credentials
   gcloud container clusters get-credentials cluster-name --zone=us-central1-a
   ```

2. **Terraform State Issues**
   ```bash
   # Refresh state
   terraform refresh
   
   # Import existing resources
   terraform import google_compute_instance.example projects/PROJECT_ID/zones/ZONE/instances/INSTANCE_NAME
   ```

3. **Application Debugging**
   ```bash
   # Check pod logs
   kubectl logs -f deployment/demo-app
   
   # Port forward for local testing
   kubectl port-forward service/demo-app 8080:80
   ```

## 📞 Support

For questions or issues:
- Open an issue in this repository
- Contact: ahmed.abdelkhalek@example.com
- LinkedIn: [Ahmed Abdelkhalek](https://linkedin.com/in/ahmedabdelkhalek1)

---
