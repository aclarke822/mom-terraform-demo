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
  path = "/users/"

  tags = {
    Provisioner = var.provisioner
    Environment = var.environment
  }
}

resource "aws_iam_group" "groups" {
  for_each = { for index, group in local.user_groups : index => group }

  name = each.key
  path = "/users/"

  depends_on = [
    aws_iam_user.users
  ]
}

resource "aws_iam_group_membership" "teams" {
  for_each = { for index, group in local.user_groups : index => group }

  name  = "tf-${each.key}-group-membership"
  users = local.user_groups[each.key]
  group = aws_iam_group.groups[each.key].name

  depends_on = [
    aws_iam_user.users
  ]
}

resource "aws_iam_group_policy_attachment" "administrator_group_policy" {
  group      = "administrators"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

  depends_on = [
    aws_iam_group_membership.teams
  ]
}