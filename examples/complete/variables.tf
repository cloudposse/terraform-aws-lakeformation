variable "region" {
  type = string
}

variable "lakeformation_tags" {
  description = "A map of key-value pairs to be used as Lake Formation tags."
  type        = map(list(string))
  default     = {}
}

variable "resources" {
  description = "A map of Lake Formation resources to create, with related attributes."
  type        = map(any)
  default     = {}
}
