resource "kubernetes_manifest" "catalogsource_px_operator_pixie_operator_index" {
  manifest = {
    "apiVersion" = "operators.coreos.com/v1alpha1"
    "kind" = "CatalogSource"
    "metadata" = {
      "name" = "pixie-operator-index"
      "namespace" = "px-operator"
    }
    "spec" = {
      "displayName" = "Pixie Vizier Operator"
      "image" = "gcr.io/pixie-oss/pixie-prod/operator/bundle_index:0.0.1"
      "publisher" = "px.dev"
      "sourceType" = "grpc"
      "updateStrategy" = {
        "registryPoll" = {
          "interval" = "10m"
        }
      }
    }
  }
}
