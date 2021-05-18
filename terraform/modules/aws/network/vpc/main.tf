resource "aws_vpc" "this" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "master-${var.service}"
  }
}

resource "aws_subnet" "public" {
  for_each          = var.subnets
  cidr_block        = each.value["cidr_block"]
  vpc_id            = aws_vpc.this.id
  availability_zone = each.value["availability_zone"]
  tags = {
    Name = "public-${var.service}-${each.key}"
    Tier = "public"
  }
  depends_on = [aws_vpc.this]
}

// TODO privateSubnet作る?

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "master-${var.service}-gw"
  }
  depends_on = [aws_subnet.public]
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "master-${var.service}-rt"
  }
  depends_on = [aws_internet_gateway.this]
}

// ルートテーブルの紐付け
resource "aws_route_table_association" "this" {
  for_each       = var.subnets
  route_table_id = aws_route_table.this.id
  subnet_id      = aws_subnet.public[each.key].id
  depends_on     = [aws_route_table.this]
}

resource "aws_security_group" "this" {
  name   = "master-${var.service}-sg"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "master-${var.service}-sg"
  }
  depends_on = [aws_route_table_association.this]
}
