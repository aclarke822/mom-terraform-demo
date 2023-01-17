locals {
  philosophers = jsondecode(file("./data/iam/philosophers.json"))
}

resource "aws_iam_user" "philosophers" {
  name  = local.philosophers[count.index]
  count = length(local.philosophers)

  path = "/users/"

  tags = {
    Provisioner = var.provisioner
    Environment = var.environment
  }
}

resource "aws_iam_group" "philosophers_group" {
  name = "philosophers"
  path = "/users/"
  
  depends_on = [
    aws_iam_user.philosophers
  ]
}

resource "aws_iam_group_membership" "philosophers_team" {
  name  = "tf-philosophers-group-membership"
  users = local.philosophers
  group = aws_iam_group.philosophers_group.name
}