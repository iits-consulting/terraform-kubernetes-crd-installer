## Custom Resource Definition Installer

A module designed to automatically extract the crds from Helm charts and install them on the target kubernetes cluster. The module can be used with existing CRDs without importing.

> **WARNING:** This module will have a large footprint on the terraform state depending on the size and number of charts.  
> Module execution and subsequent state generation can take a longer than usual time due to the large size of the state the module generates.  
> It is recommended to use it as standalone in its own script to separate its state from other terraform scripts.

> **WARNING: BREAKING CHANGES IN 8.0.0**  
> Module is restructured so that each instance of the module now controls only one chart's CRDs. Make sure to adjust your module configuration! See usage example below for details.  
> When migrating from a version before 8.0.0, make sure `apply_only = true` is set  to avoid destruction of CRDs installed by older module versions!  

Usage example (overriding versions and disabling built-in default charts):
```hcl
locals {
  crd_charts = {
    cert-manager = {
      version = "1.17.4-policy-exclusion"
      values = {
        cert-manager = {
          crds = {
            enabled = true
          }
        }
      }
    }
    kyverno = {
      version = "3.1.1"
      values = {
        kyverno = {
          crds = {
            install = true
          }
        }
      }
    }
    prometheus-stack = {
      version = "79.8.2"
      values = {
        prometheusStack = {
          crds = {
            enabled = true
          }
        }
      }
    }
  }
}

module "crds" {
  source  = "iits-consulting/crd-installer/kubernetes/"

  for_each = local.crd_charts

  chart_name    = each.key
  chart_version = each.value.version
  chart_values  = [yamlencode(each.value.values)]

  apply_only = false
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.19 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.1 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | ~> 1.19 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubectl_manifest.crds](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [helm_template.chart](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/data-sources/template) | data source |
| [kubectl_server_version.current](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/data-sources/server_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Helm chart name to create templates from. | `string` | n/a | yes |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart version to template the chart from. | `string` | n/a | yes |
| <a name="input_apply_only"></a> [apply\_only](#input\_apply\_only) | Apply only, prevents destruction of CRDs. | `bool` | `true` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | Helm chart repository to template the chart from. | `string` | `"https://charts.iits.tech"` | no |
| <a name="input_chart_set_list_parameter"></a> [chart\_set\_list\_parameter](#input\_chart\_set\_list\_parameter) | Override the values of the chart using set\_list. | <pre>list(object({<br/>    name  = string<br/>    value = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_chart_set_parameter"></a> [chart\_set\_parameter](#input\_chart\_set\_parameter) | Override the values of the chart using set. | <pre>list(object({<br/>    name  = string<br/>    value = optional(string)<br/>    type  = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_chart_set_sensitive_parameter"></a> [chart\_set\_sensitive\_parameter](#input\_chart\_set\_sensitive\_parameter) | Override the values of the chart using set\_sensitive. | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>    type  = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_chart_values"></a> [chart\_values](#input\_chart\_values) | Override the values of the chart using value files. | `list(string)` | `[]` | no |
| <a name="input_force_conflicts"></a> [force\_conflicts](#input\_force\_conflicts) | Apply using force-conflicts flag. | `bool` | `true` | no |
| <a name="input_force_new"></a> [force\_new](#input\_force\_new) | Forces delete & create of resources if the CRD manifest changes. | `bool` | `false` | no |
| <a name="input_hide_fields"></a> [hide\_fields](#input\_hide\_fields) | Hide the diff output of terraform by marking it as sensitive. Useful for less cluttered terraform output. See https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/kubectl_manifest#sensitive-fields for details. | `list(string)` | <pre>[<br/>  "apiVersion",<br/>  "kind",<br/>  "metadata",<br/>  "spec"<br/>]</pre> | no |
| <a name="input_server_side_apply"></a> [server\_side\_apply](#input\_server\_side\_apply) | Apply using server-side-apply method. | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

