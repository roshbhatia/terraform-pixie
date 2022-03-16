resource "kubernetes_manifest" "subscription_px_operator_pixie_operator_subscription" {
  manifest = {
    "apiVersion" = "operators.coreos.com/v1alpha1"
    "kind"       = "Subscription"
    "metadata" = {
      "name"      = "pixie-operator-subscription"
      "namespace" = "px-operator"
    }
    "spec" = {
      "channel"             = "stable"
      "installPlanApproval" = "Automatic"
      "name"                = "pixie-operator"
      "source"              = "pixie-operator-index"
      "sourceNamespace"     = "px-operator"
    }
  }
}
