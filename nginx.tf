provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  }
}
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
  depends_on = [
    module.eks,
  ]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

resource "helm_release" "nginx" {
  name       = "nginx-web"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"
  version    = "15.10.2"

  # values = [
  #   file("./modules/Helm-Chart/nginx/values.yaml")
  # ]

  depends_on = [
    module.eks,
  ]
}