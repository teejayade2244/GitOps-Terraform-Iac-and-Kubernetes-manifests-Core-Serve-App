variable "cluster_name" {
  description = "The name of the EKS cluster for which to create access entries."
  type        = string
}

variable "access_entries" {
  description = "A map of access entry configurations. Each key is an identifier for the entry."
  type = map(object({
    principal_arn     = string
    kubernetes_groups = list(string)
    type              = optional(string, "STANDARD") 
  }))
}