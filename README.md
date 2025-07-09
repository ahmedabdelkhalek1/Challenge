# DevOps Challenge Solution

This solution automates GCP infrastructure and application deployment for the DevOps challenge.

## Components

- Terraform modules for:
  - VPC, subnets, routing
  - Firewall rules
  - Private GKE cluster
  - Bastion host
  - HA Redis (Memorystore)
- Helm chart for demo app
- Dockerfile for app containerization
- GitHub Actions pipeline with Workload Identity
- GCP HTTP(S) Load Balancer
- Terraform remote state in GCS
- Autoscaling setup
