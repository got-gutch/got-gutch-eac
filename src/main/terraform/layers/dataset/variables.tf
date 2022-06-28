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

// "648924262152"
variable "external_accounts" {
  description = "A list of accounts that need read access to the bucket"
  type        = list(string)
  default     = [
    "arn:aws:iam::648924262152:role/nonprod_datalake_datalake_default_sfn_role",
    "arn:aws:iam::648924262152:role/nonprod_oddw_cp_orchestration_oddw_sfn_role",
    "arn:aws:iam::648924262152:role/nonprod_oddw_emr_instance_profile",
    "arn:aws:iam::648924262152:role/nonprod_oddw_emr_default_role",
    "arn:aws:iam::648924262152:role/nonprod_workbench_emr_instance_profile",
    "arn:aws:iam::648924262152:role/nonprod_workbench_emr_default_role",
    "arn:aws:iam::648924262152:role/DCEPrincipal"
  ]
}

variable "force_destroy_dataset" {
  description = "Force destroy the s3 bucket?"
  default     = true
  type        = bool
}
