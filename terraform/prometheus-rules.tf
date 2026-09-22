resource "kubernetes_manifest" "three_tier_application_alerts" {
  count = var.lab_enabled ? 1 : 0

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "PrometheusRule"

    metadata = {
      name      = "three-tier-application-alerts"
      namespace = "monitoring"

      labels = {
        release = "kube-prometheus-stack"
      }
    }

    spec = {
      groups = [
        {
          name = "eks-node-alerts"

          rules = [
            {
              alert = "HighNodeMemory"

              expr = <<-EOT
                100 * (
                  1 -
                  node_memory_MemAvailable_bytes
                  /
                  node_memory_MemTotal_bytes
                ) > 80
              EOT

              for = "5m"

              labels = {
                severity = "warning"
              }

              annotations = {
                summary     = "High node memory usage"
                description = "Node memory usage has been above 80% for more than 5 minutes."
              }
            },

            {
              alert = "NodeNotReady"

              expr = <<-EOT
                kube_node_status_condition{
                  condition="Ready",
                  status="true"
                } == 0
              EOT

              for = "5m"

              labels = {
                severity = "critical"
              }

              annotations = {
                summary     = "Kubernetes node is not ready"
                description = "A Kubernetes node has been NotReady for more than 5 minutes."
              }
            }
          ]
        }
      ]
    }
  }

  depends_on = [
    helm_release.kube_prometheus_stack
  ]
}
