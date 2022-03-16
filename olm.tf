resource "kubernetes_manifest" "namespace_olm" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Namespace"
    "metadata" = {
      "name" = "olm"
    }
  }
}

resource "kubernetes_manifest" "serviceaccount_olm_olm_operator_serviceaccount" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "name"      = "olm-operator-serviceaccount"
      "namespace" = "olm"
    }
  }
}

resource "kubernetes_manifest" "clusterrole_system_controller_operator_lifecycle_manager" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind"       = "ClusterRole"
    "metadata" = {
      "name" = "system:controller:operator-lifecycle-manager"
    }
    "rules" = [
      {
        "apiGroups" = [
          "*",
        ]
        "resources" = [
          "*",
        ]
        "verbs" = [
          "*",
        ]
      },
      {
        "nonResourceURLs" = [
          "*",
        ]
        "verbs" = [
          "*",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrolebinding_olm_operator_cluster_binding_olm" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind"       = "ClusterRoleBinding"
    "metadata" = {
      "name" = "olm-operator-cluster-binding-olm"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind"     = "ClusterRole"
      "name"     = "system:controller:operator-lifecycle-manager"
    }
    "subjects" = [
      {
        "kind"      = "ServiceAccount"
        "name"      = "olm-operator-serviceaccount"
        "namespace" = "olm"
      },
    ]
  }
}

resource "kubernetes_manifest" "deployment_olm_olm_operator" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = "olm-operator"
      }
      "name"      = "olm-operator"
      "namespace" = "olm"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "olm-operator"
        }
      }
      "strategy" = {
        "type" = "RollingUpdate"
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "olm-operator"
          }
        }
        "spec" = {
          "containers" = [
            {
              "args" = [
                "--namespace",
                "$(OPERATOR_NAMESPACE)",
                "--writeStatusName",
                "",
              ]
              "command" = [
                "/bin/olm",
              ]
              "env" = [
                {
                  "name" = "OPERATOR_NAMESPACE"
                  "valueFrom" = {
                    "fieldRef" = {
                      "fieldPath" = "metadata.namespace"
                    }
                  }
                },
                {
                  "name"  = "OPERATOR_NAME"
                  "value" = "olm-operator"
                },
              ]
              "image"           = "quay.io/operator-framework/olm@sha256:b706ee6583c4c3cf8059d44234c8a4505804adcc742bcddb3d1e2f6eff3d6519"
              "imagePullPolicy" = "IfNotPresent"
              "livenessProbe" = {
                "httpGet" = {
                  "path" = "/healthz"
                  "port" = 8080
                }
              }
              "name" = "olm-operator"
              "ports" = [
                {
                  "containerPort" = 8080
                },
                {
                  "containerPort" = 8081
                  "name"          = "metrics"
                  "protocol"      = "TCP"
                },
              ]
              "readinessProbe" = {
                "httpGet" = {
                  "path" = "/healthz"
                  "port" = 8080
                }
              }
              "resources" = {
                "requests" = {
                  "cpu"    = "10m"
                  "memory" = "160Mi"
                }
              }
              "terminationMessagePolicy" = "FallbackToLogsOnError"
            },
          ]
          "nodeSelector" = {
            "kubernetes.io/os" = "linux"
          }
          "serviceAccountName" = "olm-operator-serviceaccount"
        }
      }
    }
  }
}

resource "kubernetes_manifest" "deployment_olm_catalog_operator" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = "catalog-operator"
      }
      "name"      = "catalog-operator"
      "namespace" = "olm"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "catalog-operator"
        }
      }
      "strategy" = {
        "type" = "RollingUpdate"
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "catalog-operator"
          }
        }
        "spec" = {
          "containers" = [
            {
              "args" = [
                "-namespace",
                "olm",
                "-configmapServerImage=quay.io/operator-framework/configmap-operator-registry:latest",
                "-util-image",
                "quay.io/operator-framework/olm@sha256:b706ee6583c4c3cf8059d44234c8a4505804adcc742bcddb3d1e2f6eff3d6519",
              ]
              "command" = [
                "/bin/catalog",
              ]
              "env"             = null
              "image"           = "quay.io/operator-framework/olm@sha256:b706ee6583c4c3cf8059d44234c8a4505804adcc742bcddb3d1e2f6eff3d6519"
              "imagePullPolicy" = "IfNotPresent"
              "livenessProbe" = {
                "httpGet" = {
                  "path" = "/healthz"
                  "port" = 8080
                }
              }
              "name" = "catalog-operator"
              "ports" = [
                {
                  "containerPort" = 8080
                },
                {
                  "containerPort" = 8081
                  "name"          = "metrics"
                  "protocol"      = "TCP"
                },
              ]
              "readinessProbe" = {
                "httpGet" = {
                  "path" = "/healthz"
                  "port" = 8080
                }
              }
              "resources" = {
                "requests" = {
                  "cpu"    = "10m"
                  "memory" = "80Mi"
                }
              }
              "terminationMessagePolicy" = "FallbackToLogsOnError"
            },
          ]
          "nodeSelector" = {
            "kubernetes.io/os" = "linux"
          }
          "serviceAccountName" = "olm-operator-serviceaccount"
        }
      }
    }
  }
}

resource "kubernetes_manifest" "clusterrole_aggregate_olm_edit" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind"       = "ClusterRole"
    "metadata" = {
      "labels" = {
        "rbac.authorization.k8s.io/aggregate-to-admin" = "true"
        "rbac.authorization.k8s.io/aggregate-to-edit"  = "true"
      }
      "name" = "aggregate-olm-edit"
    }
    "rules" = [
      {
        "apiGroups" = [
          "operators.coreos.com",
        ]
        "resources" = [
          "subscriptions",
        ]
        "verbs" = [
          "create",
          "update",
          "patch",
          "delete",
        ]
      },
      {
        "apiGroups" = [
          "operators.coreos.com",
        ]
        "resources" = [
          "clusterserviceversions",
          "catalogsources",
          "installplans",
          "subscriptions",
        ]
        "verbs" = [
          "delete",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrole_aggregate_olm_view" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind"       = "ClusterRole"
    "metadata" = {
      "labels" = {
        "rbac.authorization.k8s.io/aggregate-to-admin" = "true"
        "rbac.authorization.k8s.io/aggregate-to-edit"  = "true"
        "rbac.authorization.k8s.io/aggregate-to-view"  = "true"
      }
      "name" = "aggregate-olm-view"
    }
    "rules" = [
      {
        "apiGroups" = [
          "operators.coreos.com",
        ]
        "resources" = [
          "clusterserviceversions",
          "catalogsources",
          "installplans",
          "subscriptions",
          "operatorgroups",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "packages.operators.coreos.com",
        ]
        "resources" = [
          "packagemanifests",
          "packagemanifests/icon",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "operatorgroup_olm_olm_operators" {
  manifest = {
    "apiVersion" = "operators.coreos.com/v1"
    "kind"       = "OperatorGroup"
    "metadata" = {
      "name"      = "olm-operators"
      "namespace" = "olm"
    }
    "spec" = {
      "targetNamespaces" = [
        "olm",
      ]
    }
  }
}
