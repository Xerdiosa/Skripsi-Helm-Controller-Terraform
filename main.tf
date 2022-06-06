resource "helm_release" "olympus_api" {
  repository = "s3://gudangada-bi-helm-charts/stable"
  chart      = "warehouse-controller"
  version    = "0.3.9"

  name      = "olympus-api"
  namespace = local.namespace
  set {
    name  = "secretName"
    value = "env-config-secret"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::316810839165:role/DataEngineer"
  }
}

resource "kubernetes_role" "masters" {
  metadata {
    name      = "masters"
    namespace = local.namespace
  }
  rule {
    api_groups = [""]
    resources  = ["*"]
    verbs      = ["*"]
  }
  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_role_binding" "masters" {
  metadata {
    name      = "masters"
    namespace = local.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.masters.metadata.0.name
  }
  subject {
    kind = "Group"
    name = "olympus-api:masters"
  }
}
