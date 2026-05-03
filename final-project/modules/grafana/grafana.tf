resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "8.0.0"
  namespace  = "monitoring"

  values = [
    file("${path.module}/values-grafana.yaml")
  ]
}