output "endpoint" {
  value = aws_eks_cluster.tz-labs.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.tz-labs.certificate_authority[0].data
}
output "cluster_id" {
  value = aws_eks_cluster.tz-labs.id
}
output "cluster_endpoint" {
  value = aws_eks_cluster.tz-labs.endpoint
}
output "cluster_name" {
  value = aws_eks_cluster.tz-labs.name
}

