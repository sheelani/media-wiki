provider "aws" {
 region     = var.region
}


resource "aws_vpc" "wvpc" {
  cidr_block = var.aws_cidr_vpc
  enable_dns_support = true
  enable_dns_hostnames = true
  tags =  {
    Name = "webvpc"
  }
}


resource "aws_internet_gateway" "w_igw" {
    vpc_id = aws_vpc.wvpc.id
    tags =  {
        Name = "Internet Gateway for webSubnet"
    }
}



resource "aws_route_table" "w_rt" {
  vpc_id = aws_vpc.wvpc.id
  route {
        cidr_block = "0.0.0.0/0"
       gateway_id = aws_internet_gateway.w_igw.id
    }
}


resource "aws_subnet" "w_subnet1" {
  vpc_id = aws_vpc.wvpc.id
  cidr_block = var.aws_cidr_subnet1
  availability_zone = var.azs

  tags =  {
    Name = "WebserverSubnet1"
  }
}

resource "aws_route_table_association" "Publicrta" {
    subnet_id = aws_subnet.w_subnet1.id
    route_table_id = aws_route_table.w_rt.id
}




resource "aws_security_group" "w_sg" {
  name = "w_sg"
  vpc_id = aws_vpc.wvpc.id
  ingress {
    from_port = 22 
    to_port  = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port = 80
    to_port  = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = "0"
    to_port  = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}




# Launch the instance
resource "aws_instance" "webserver2" {
  ami           = var.aws_ami
  instance_type = var.aws_instance_type
  key_name  = var.key_name
  vpc_security_group_ids = [aws_security_group.w_sg.id]
  subnet_id     = aws_subnet.w_subnet1.id 
  associate_public_ip_address = true
  tags =  {
    Name = "${lookup(var.aws_tags,"webserver1")}"
    group = "web"
  }
}

output "instance_ips" {
  value = ["${aws_instance.webserver2.*.public_ip}"]
}



