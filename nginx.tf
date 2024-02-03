provider "helm" {
  kubernetes {
    host     = data.aws_eks_cluster.cluster.endpoint
    token    = data.aws_eks_cluster_auth.cluster.token
    client_certificate     = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    client_key             = base64decode(data.aws_eks_cluster_auth.cluster.client_certificate)
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

resource "helm_release" "nginx" {
  name       = "nginx"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"
  version    = "8.2.1"

  values = [
    file("helm/nginx/values.yaml")
  ]

  depends_on = [
    aws_eks_cluster.cluster,
    aws_eks_node_group.node_group,
  ]
}