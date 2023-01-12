resource "aws_iam_user" "lb" {
  name = "loadbalancer"
  path = "/"

  tags = {
    Provisioner = var.provisioner
    Environment = var.environment
  }
}

resource "aws_iam_access_key" "lb_access_key" {
  user = aws_iam_user.lb.name
}

resource "aws_iam_user_policy" "lb_role" {
  name = "lb_role"
  user = aws_iam_user.lb.name

  policy = file("./policies/lb_role.json")
}