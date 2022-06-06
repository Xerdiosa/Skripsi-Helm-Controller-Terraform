terraform {
  backend "s3" {
    region = "ap-southeast-1"
    bucket = "gudangada-bi-terraform-state"
    key    = "aws/gudangada-bi/eks/production-data-warehouse/olympus-api/state"

    dynamodb_table = "TerraformLocks"
  }
  required_providers {
    aws = {
      version = "~> 3.29"
    }
    helm = {
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.production_data_warehouse_eks_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.production_data_warehouse_eks_ca)
    token                  = data.aws_eks_cluster_auth.production_data_warehouse.token
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.production_data_warehouse_eks_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.production_data_warehouse_eks_ca)
  token                  = data.aws_eks_cluster_auth.production_data_warehouse.token
}
