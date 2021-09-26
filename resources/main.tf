data "aws_vpc" "main" {
  filter {
    name   = "Name"
    values = ["Main"]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.main.id
  filter {
    name   = "Type"
    values = ["Public"]
  }
}