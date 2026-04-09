resource "aws_instance" "this" {
  ami           = "ami-0ec10929233384c7f" # Ubuntu Server 24.04 LTS
  instance_type = "t2.micro"

  tags = {
    Name        = var.instance_name
    Environment = var.environment
    ManagedBy   = "Terraform-Module"
  }
}
