locals {
  user_groups = jsondecode(file("./data/iam/user_groups.json"))

  # Nested loop over both lists, and flatten the result.
  users = distinct(flatten([
    for group in keys(local.user_groups) : [
      for name in local.user_groups[group] : {
        group = group
        name  = name
      }
    ]
  ]))
}

resource "aws_iam_user" "users" {
  count = length(local.users)

  name = local.users[count.index].name
  path = "/users/${local.users[count.index].group}"

  tags = {
    Provisioner = var.provisioner
    Environment = var.environment
  }
}

resource "aws_iam_group" "groups" {
  for_each = { for index, group in local.user_groups : index => group }

  name = each.key
  path = "/users/"
}

resource "aws_iam_group_membership" "teams" {
  for_each = { for index, group in local.user_groups : index => group }

  name = "tf-${each.key}-group-membership"
  users = local.user_groups[each.key]
  group = aws_iam_group.groups[each.key].name
}