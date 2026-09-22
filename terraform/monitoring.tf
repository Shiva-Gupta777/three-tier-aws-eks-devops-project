resource "helm_release" "kube_prometheus_stack" {
  count = var.lab_enabled ? 1 : 0

  name       = "kube-prometheus-stack"
  namespace  = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "91.4.1"

  create_namespace = true

  wait    = true
  timeout = 900

  values = [
    yamlencode({
      grafana = {
        service = {
          type = "ClusterIP"
        }

        persistence = {
          enabled          = true
          size             = "5Gi"
          storageClassName = "gp2"
        }
      }

      prometheus = {
        prometheusSpec = {
          retention = "7d"

          storageSpec = {
            volumeClaimTemplate = {
              spec = {
                storageClassName = "gp2"

                resources = {
                  requests = {
                    storage = "10Gi"
                  }
                }
              }
            }
          }
        }
      }
    })
  ]

  depends_on = [
    aws_eks_node_group.main
  ]
}
