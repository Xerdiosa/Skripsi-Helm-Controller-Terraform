data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    region = "ap-southeast-1"
    bucket = "gudangada-bi-terraform-state"
    key    = "aws/gudangada-bi/eks/state"
  }
}

data "aws_eks_cluster_auth" "production_data_warehouse" {
  name = data.terraform_remote_state.eks.outputs.production_data_warehouse_eks_name
}
