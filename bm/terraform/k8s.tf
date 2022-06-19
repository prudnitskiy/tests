provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
    }
  }
}

resource "helm_release" "ingress-nginx" {
  name       = "ingress-nginx"
  chart      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
}

resource "kubernetes_secret" "docker" {
  metadata {
    name = "docker"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.registry_server}" = {
          "username" = var.registry_username
          "password" = var.registry_password
          "email"    = var.registry_email
          "auth"     = base64encode("${var.registry_username}:${var.registry_password}")
        }
      }
    })
  }
}


resource "kubernetes_deployment" "simplews" {
  metadata {
    name = "simplews"
    labels = {
      app = "simplews"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "simplews"
      }
    }
    template {
      metadata {
        labels = {
          app = "simplews"
        }
      }
      spec {
        container {
          image = "${var.deploy_image}:${var.deploy_version}"
          name  = "simplews"
          resources {
            limits = {
              cpu    = "0.5"
              memory = "256Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
          liveness_probe {
            http_get {
              path = "/health"
              port = 8081
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
        image_pull_secrets {
          name = kubernetes_secret.docker.metadata.name
        }
      }
    }
  }
}


resource "kubernetes_service" "simplews" {
  metadata {
    name = "simplews"
  }
  spec {
    selector = {
      app = kubernetes_deployment.simplews.metadata.0.labels.app
    }
    port {
      port        = 8081
      target_port = 8081
    }
  }
}
