resource "kubernetes_manifest" "namespace_px_operator" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Namespace"
    "metadata" = {
      "name" = "px-operator"
    }
  }
}

resource "kubernetes_manifest" "operatorgroup_px_operator_global_operators" {
  manifest = {
    "apiVersion" = "operators.coreos.com/v1"
    "kind"       = "OperatorGroup"
    "metadata" = {
      "name"      = "global-operators"
      "namespace" = "px-operator"
    }
  }
}
