resource "helm_release" "prometheus_stack" {
  name       = "prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "65.0.0"
  namespace  = "monitoring"

  values = [
    file("${path.module}/values-prometheus.yaml")
  ]
}


resource "helm_release" "cloudwatch_exporter" {
  name       = "cloudwatch-exporter"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-cloudwatch-exporter"
  namespace  = "monitoring"

  values = [
    file("${path.module}/values-cloudwatch.yaml")
  ]
}