resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.replicaCount"
    value = "2"
  }

  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }
}


resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "5.53.0"

  # values = [
  #   templatefile("${path.module}/values/argocd-values.yaml", {})
  # ]
  wait = true
  timeout = 600 #
}

resource "helm_release" "vault" {
  name             = "vault"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault"
  namespace        = "vault"
  create_namespace = true
  version          = "0.27.0"

  set {
    name  = "server.dev.enabled"
    value = "true"
  }

  set {
    name  = "server.ha.enabled"
    value = "false"
  }

  set {
    name  = "injector.enabled"
    value = "true"
  }

  set {
    name  = "ui.enabled"
    value = "true"
  }

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }

  wait    = true
  timeout = 600
}