variable "cidr" {
  type    = string
  default = "55.0.0.0/16"
}

variable "private_subnets" {
  type = list(string)
  default = ["55.0.1.0/24", "55.0.2.0/24", "55.0.3.0/24"]
}

variable "public_subnets" {
  type = list(string)
  default = ["55.0.101.0/24", "55.0.102.0/24", "55.0.103.0/24"]
}

variable "region" {
  description = "The region to use"
  type        = string
}

variable "namespace" {
  description = "The project namespace to use for unique resource naming"
  type        = string
  default     = "got-gutch"
}

variable "principal_arns" {
  description = "A list of principal arns allowed to assume the IAM role"
  type        = list(string)
}
