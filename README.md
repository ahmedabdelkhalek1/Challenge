
## application loadbalancer http://34.117.43.24/
please vist it to test funcionality 
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
    --role="compute.network.admin"
    --role="artifactregistry.googleapis.com"
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
- Custom VPC with private subnets
- Cloud NAT for internet access from private resources
- Firewall rules for security
- Security policies and firewall rules
- Secondary IP ranges for GKE pods and services

### GKE Module (`terraform/modules/gke/`)
- Private GKE cluster configuration
- Custom node pools with autoscaling
- Network policies for pod security
- Workload Identity enabled

### Bastion Module (`terraform/modules/compute/`)
- Secure bastion host for cluster access
- Pre-configured with necessary tools
- IAP tunnel access for enhanced security

### Redis Module (`terraform/modules/redis/`)
- High-availability Redis instance (Memorystore)
- Private IP configuration

### Artifact Registry Module (`terraform/modules/artifact-registry/`)
- Creates a regional Artifact Registry repository (Docker or other formats)
- Supports multiple repositories for dev, staging, and prod environments

### IAM Module (`terraform/modules/iam/`)
- Centralized IAM bindings management (project-level and service-specific roles)
- Supports custom roles and predefined role assignments
- Handles Workload Identity bindings 
- Follows least privilege principle across resources

## 🐳 Application Details

### Demo Application
The demo application is a cloud-native microservice featuring:
- **Language**: Python/Node.js (based on your implementation)
- **Framework**: Flask/Express or similar
- **Database**: Redis for caching and session storage
- **Monitoring**: Health checks and metrics endpoints
- **Containerization**:  Docker build

### Application Features
- Health and readiness probes
- Configuration via environment variables

### Helm Chart (`helm/demo-app/`)
- Kubernetes deployment 
- Service and ingress configurations
- Horizontal Pod Autoscaler (HPA)

## 🔄 CI/CD Pipeline
## CI/CD Pipeline Flow Chart

```mermaid
graph TD
    A[Push to Repository] --> B[authenticate]
    B --> C[terraform-checks]
    C -->|Push to main| D[deploy-infrastructure]
    C -->|Pull Request| E[Preview terraform plan]
    D --> F[test-apps]
    F --> G[preview-deployment]
    G -->|Push to main| H[deploy-applications]
    I[Manual trigger] --> J[destroy]
    K[Branch deletion] --> J
    
    style D fill:#9cf,stroke:#333
    style H fill:#9cf,stroke:#333
    style J fill:#fcb,stroke:#333
```

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
## 🧹 Infrastructure Management

### Terraform State Management

#### Unlock Terraform State
If Terraform state becomes locked due to interrupted operations:

**⚠️ Warning**: The destroy operation will:
- Delete all infrastructure resources
- Remove all data (Redis, application state)
- Cannot be undone

### Operational Workflows

#### Terraform Destroy Workflow
- **Trigger**: Manual dispatch from GitHub Actions
- **Purpose**: Complete infrastructure cleanup
- **Safety**: Requires manual confirmation
- **Scope**: Destroys all Terraform-managed resources

#### Terraform Unlock Workflow  
- **Trigger**: Manual dispatch from GitHub Actions
- **Purpose**: Release stuck Terraform state locks
- **Use Case**: When Terraform operations are interrupted
- **Safety**: Includes validation before unlock

## 📞 Support

For questions or issues:
- Open an issue in this repository
- Contact: ahmed.abdelkhalek
- LinkedIn: [Ahmed Abdelkhalek](https://linkedin.com/in/ahmedabdelkhalek1)

---
