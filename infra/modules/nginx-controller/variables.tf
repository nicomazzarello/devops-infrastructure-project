variable "ingress_class_name" {
  type        = string
  description = "Ingress class name"
  default     = "nginx"
}

variable "ingress_class_is_default" {
  type        = bool
  description = "Whether to set this ingress class as default"
  default     = true
}
