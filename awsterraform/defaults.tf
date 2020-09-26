variable "region" {
  type = string
  default =  "ap-south-1"
}

 # Availability Zones
 
variable "azs" {
  type = string
  default = "ap-south-1a"
}

variable "key_name" {
  default = "server"
}

 
variable "aws_ami" {
  default="ami-0e306788ff2473ccb"
}

# VPC and Subnet
variable "aws_cidr_vpc" {
  default = "172.16.0.0/16"
}

variable "aws_cidr_subnet1" {
  default = "172.16.1.0/24"
}

variable "aws_cidr_subnet2" {
  default = "172.16.2.0/24"
}



variable "aws_tags" {
  type = map
  default = {
    "webserver1" = "Web-1"
  }
}

variable "aws_instance_type" {
  default = "t2.micro"
}

variable "sns_topic" {
  type = string
  default =  "arn:aws:sns:ap-south-1:524704856167:alarm"

}

