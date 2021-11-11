# GCP - Creating a GKE Instance with Terraform
The files in this repo create an auto-scaling Google Kubernetes Engine (GKE) Cluster in a GCP Project.

## Prerequisites
A pre-existing GCP Project is required in order to create a GKE Cluster (see the [GCP_Creating_a_Project_with_Terraform](https://github.com/rigoford/GCP_Creating_a_Project_with_Terraform) repo).

## Usage
Either update the `variables.tf` file, setting a default value for the `project_id` variable, or set the value as an environment variable:
```bash
export TF_VAR_project_id="<PROJECT_ID>"
```

Running `terraform init` followed by `terrform apply` with then create a GKE Cluster called "cluster" in the specified GCP Project.
