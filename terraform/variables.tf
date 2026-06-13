variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "rg-actualbudget-capstone"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "australiaeast"
}

variable "project_name" {
  description = "Short name used across all resources"
  type        = string
  default     = "actualbudget"
}

variable "aks_node_count" {
  description = "Number of AKS nodes"
  type        = number
  default     = 1
}

variable "aks_node_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s_v2"
}
