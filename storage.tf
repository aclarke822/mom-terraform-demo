resource "aws_s3_bucket" "mom8" {
    bucket = "mom8-457959958314"
    tags = {
        Provisioner = var.provisioner
        Environment = var.environment
    }
}