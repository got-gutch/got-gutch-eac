resource "aws_iam_user" "got_gutch_users" {
  count = length(var.usernames)
  name  = var.usernames[count.index]
  path  = "/system/"

  tags = {
    resource_group = var.namespace
    region         = var.region
    layer_name     = "access-control"
    username       = var.usernames[count.index]
  }
}

resource "aws_iam_access_key" "got_gutch_access_keys" {
  count = length(var.usernames)
  user  = var.usernames[count.index]
  depends_on = [aws_iam_user.got_gutch_users]
}