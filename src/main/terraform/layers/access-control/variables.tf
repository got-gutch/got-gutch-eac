variable "sysadmins" {
  type    = list(string)
  default = ["bgutch"]
}

variable "admins" {
  type    = list(string)
  default = ["mkgutch"]
}

variable "usernames" {
  type    = list(string)
  default = ["bgutch", "mkgutch"]
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
