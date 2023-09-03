# Learn Terraform - Provision a GKE Cluster

## Introduction

This is a project to provision a GKE cluster on GCP using Terraform. We use the same resource files 
across dev and prod. We use workspaces to manage the state files for each environment.

See below for the steps to provision the GKE cluster in the right environment.

## For Learning Please checkout these resources

- [Provision a GKE Cluster tutorial](https://developer.hashicorp.com/terraform/tutorials/kubernetes/gke), containing
  Terraform configuration files to provision an GKE cluster on GCP.

## First select the workspace that you want to work with.

`terraform workspace switch dev` to switch to the dev workspace.

`terraform workspace switch stage` to switch to the stage workspace.

`terraform workspace switch prod` to switch to the prod workspace.

`terraform workspace new WORKSPACE_NAME` to add a new workspace. Please consult the leads as there may not be a need for
this.

# Now perform the following steps to provision the GKE cluster.

`terraform init` to initialize the working directory.

`terraform plan -var-file="terraform.dev.tfvars"` to see the execution plan for the dev env.

`terraform apply -var-file="terraform.dev.tfvars"` to apply the desired changes for the dev env.

`terraform destroy -var-file="terraform.dev.tfvars"` to destroy the deployed infrastructure. ** proceed with caution **

