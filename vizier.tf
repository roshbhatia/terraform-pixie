resource "kubernetes_manifest" "vizier_pl_pixie" {
  manifest = {
    "apiVersion" = "px.dev/v1alpha1"
    "kind"       = "Vizier"
    "metadata" = {
      "name"      = "pixie"
      "namespace" = "pl"
    }
    "spec" = {
      "cloudAddr"   = "withpixie.ai:443"
      "clusterName" = var.cluster_name
      "dataAccess"  = "Full"
      "dataCollectorParams" = {
        "datastreamBufferSize"      = 1048576
        "datastreamBufferSpikeSize" = 524288000
      }
      "deployKey"         = var.deploy_key
      "disableAutoUpdate" = false
      "useEtcdOperator"   = false
      "version"           = "0.10.7"
    }
  }
}
