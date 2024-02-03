
output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}


output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = data.aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_ca_certificate" {
  value = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority.0.data)
}

output "eks_cluster_token" {
  value = data.aws_eks_cluster_auth.aws_cluster_auth.token
  sensitive = true
}