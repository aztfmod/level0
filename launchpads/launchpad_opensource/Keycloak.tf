data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com/"
}

data "helm_repository" "rancher_stable" {
  name = "rancher-stable"
  url  = "https://releases.rancher.com/server-charts/stable"
}

   # Put placeholder rancher annoations, otherwise the ignore directive below will not work.
    annotations = {
      "cattle.io/status" = "placeholder"
      "lifecycle.cattle.io/create.namespace-auth" = "placeholder"
    }
  }

  # Ignore changes to rancher annotations.
  lifecycle {
    ignore_changes = [
      metadata[0].annotations["cattle.io/status"],
      metadata[0].annotations["lifecycle.cattle.io/create.namespace-auth"]
    ]
  }
}

resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = "keycloak"

    # Put placeholder rancher annoations, otherwise the ignore directive below will not work.
    annotations = {
      "keycloak.io/status" = "placeholder"
      "lifecycle.keycloak.io/create.namespace-auth" = "placeholder"
    }
  }

  # Ignore changes to rancher annotations.
  lifecycle {
    ignore_changes = [
      metadata[0].annotations["keycloak.io/status"],
      metadata[0].annotations["lifecycle.cattle.io/create.namespace-auth"]
    ]
  }
}

resource "helm_release" "keycloak_server" {
  depends_on = [helm_release.cert_manager]

  repository = data.helm_repository.rancher_stable.metadata[0].name
  name       = "keycloak"
  chart      = "keycloak"
  version    = var.rancher_version
  namespace  = kubernetes_namespace.keycloak.metadata[0].name

  set {
    name  = "hostname"
    value = azurerm_public_ip.keycloak.fqdn
  }

  set {
    name = "ingress.tls.source"
    value = "letsEncrypt"
  }

  set {
    name = "letsEncrypt.email"
    value = "caleb@winterwinds.io"
  }
}

resource "azurerm_public_ip" "keycloak" {
  name                = "keycloak_public_ip"
  location            = azurerm_resource_group.cot.location
  resource_group_name = azurerm_kubernetes_cluster.k8s.node_resource_group
  allocation_method   = "Static"
  domain_name_label   = "keycloakcaleb"
}

resource "helm_release" "ingress" {
  repository = data.helm_repository.stable.metadata[0].name
  name       = "nginx-ingress"
  chart      = "nginx-ingress"
  namespace  = kubernetes_namespace.keycloak.metadata[0].name

  values = [<<EOF
controller:
  replicaCount: 3
  nodeSelector:
    beta.kubernetes.io/os: linux
  service:
    loadBalancerIP: ${azurerm_public_ip.rancher.ip_address}
defaultBackend:
  nodeSelector:
    beta.kubernetes.io/os: linux
EOF
  ]
}
