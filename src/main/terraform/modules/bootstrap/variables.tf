variable "region" {
  description = "The region to use"
  type        = string
}

variable "namespace" {
  description = "The project namespace to use for unique resource naming"
  type        = string
}

variable "principal_arns" {
  description = "A list of principal arns allowed to assume the IAM role"
  type        = list(string)
}

variable "force_destroy_state" {
  description = "Force destroy the s3 bucket containing state files?"
  default     = true
  type        = bool
}
