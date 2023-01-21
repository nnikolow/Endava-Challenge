variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
}

variable "vpc_public_subnet_cidrs" {
  description = "Public Subnets CIDR values"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "vpc_private_subnet_cidrs" {
  description = "Private Subnets CIDR values"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "vpc_azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}