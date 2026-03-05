data "kubectl_server_version" "current" {}

data "helm_template" "chart" {
  name                       = var.chart_name
  chart                      = var.chart_name
  repository                 = var.chart_repository
  version                    = var.chart_version
  dependency_update          = true
  skip_tests                 = true
  include_crds               = true
  disable_openapi_validation = true
  render_subchart_notes      = false
  kube_version               = data.kubectl_server_version.current.version
  values                     = var.chart_values
  set                        = var.chart_set_parameter
  set_list                   = var.chart_set_list_parameter
  set_sensitive              = var.chart_set_sensitive_parameter
}

resource "kubectl_manifest" "crds" {
  for_each = { for manifest in provider::kubernetes::manifest_decode_multi(data.helm_template.chart.manifest) :
    manifest.metadata.name => manifest if manifest.kind == "CustomResourceDefinition"
  }
  yaml_body         = provider::kubernetes::manifest_encode(each.value)
  server_side_apply = var.server_side_apply
  apply_only        = var.apply_only
  force_new         = var.force_new
  force_conflicts   = var.force_conflicts
  sensitive_fields  = var.hide_fields
  lifecycle {
    ignore_changes = [yaml_incluster]
  }
}
