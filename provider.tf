terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }

#Backend source to store terraform state remotely 
backend "remote" {
		hostname = "app.terraform.io"
		organization = "tf-thoufiqb"

		workspaces {
			name = "tz-labs" 
		}
	}

}

#Creating kubeconfig
provider "kubernetes" { 
  cluster_ca_certificate = base64decode(module.eks.kubeconfig-certificate-authority-data)
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token

}


provider "aws" {
  region = "eu-west-2"
}

resource "random_string" "suffix" {
  length  = 5
  special = false
}

data "aws_eks_cluster" "eks_cluster" {
  depends_on = [module.eks]
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "aws_cluster_auth" {
  depends_on = [module.eks]
  name = module.eks.cluster_name
}
