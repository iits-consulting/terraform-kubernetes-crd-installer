variable "hide_fields" {
  type = list(string)
  default = [
    "apiVersion",
    "kind",
    "metadata",
    "spec",
  ]
  description = "Hide the diff output of terraform by marking it as sensitive. Useful for less cluttered terraform output. See https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/kubectl_manifest#sensitive-fields for details."
}

variable "server_side_apply" {
  type        = bool
  default     = true
  description = "Apply using server-side-apply method."
}

variable "force_conflicts" {
  type        = bool
  default     = true
  description = "Apply using force-conflicts flag."
}

variable "apply_only" {
  type        = bool
  default     = true
  description = "Apply only, prevents destruction of CRDs."
}

variable "force_new" {
  type        = bool
  default     = false
  description = "Forces delete & create of resources if the CRD manifest changes."
}

variable "chart_repository" {
  description = "Helm chart repository to template the chart from."
  type        = string
  default     = "https://charts.iits.tech"
}

variable "chart_name" {
  description = "Helm chart name to create templates from."
  type        = string
}

variable "chart_version" {
  description = "Helm chart version to template the chart from."
  type        = string
}

variable "chart_values" {
  type        = list(string)
  default     = []
  description = "Override the values of the chart using value files."
}

variable "chart_set_parameter" {
  type = list(object({
    name  = string
    value = optional(string)
    type  = optional(string)
  }))
  default     = []
  description = "Override the values of the chart using set."
}

variable "chart_set_list_parameter" {
  type = list(object({
    name  = string
    value = list(string)
  }))
  default     = []
  description = "Override the values of the chart using set_list."
}

variable "chart_set_sensitive_parameter" {
  type = list(object({
    name  = string
    value = string
    type  = optional(string)
  }))
  default     = []
  description = "Override the values of the chart using set_sensitive."
}
