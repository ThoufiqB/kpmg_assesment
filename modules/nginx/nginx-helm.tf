provider "helm" {
  kubernetes {
    config_path = module.eks.kubeconfig_path
  }
}

resource "helm_release" "nginx" {
  name       = "nginx-release"
  chart      = "./nginx-chart"
  namespace  = "default"
  depends_on = [modules.nginx]

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  set {
    name  = "service.port"
    value = "80"
  }
}
