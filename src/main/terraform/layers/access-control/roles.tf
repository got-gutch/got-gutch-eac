module "got_gutch_iam_account" {
  source        = "terraform-aws-modules/iam/aws//modules/iam-account"
  version       = "v5.1.0"
  account_alias = var.namespace
}

module "got_gutch_sysadmin_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "v5.1.0"
  count   = length(var.sysadmins)
  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.jenkins.account_id}:root"
  ]
  create_role       = true
  role_name         = "${var.namespace}-${var.sysadmins[count.index]}-role"
  role_requires_mfa = true
  role_description  = "Role that should only be used by ${var.sysadmins[count.index]}@${var.namespace}"
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/job-function/SystemAdministrator"
  ]
  number_of_custom_role_policy_arns = 1
}

module "got_gutch_admin_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "v5.1.0"
  count   = length(var.admins)
  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.jenkins.account_id}:root"
  ]
  create_role       = true
  role_name         = "${var.namespace}-${var.admins[count.index]}-role"
  role_requires_mfa = true
  role_description  = "Role that should only be used by ${var.admins[count.index]}@${var.namespace}"
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
  number_of_custom_role_policy_arns = 1
}
