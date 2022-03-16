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
      "clusterName" = "docker-desktop"
      "dataAccess"  = "Full"
      "dataCollectorParams" = {
        "datastreamBufferSize"      = 1048576
        "datastreamBufferSpikeSize" = 524288000
      }
      "deployKey"         = "px-dep-d2b79fee-2b60-4285-82c6-2306b0a8dd93"
      "disableAutoUpdate" = false
      "useEtcdOperator"   = false
      "version"           = "0.10.7"
    }
  }
}
