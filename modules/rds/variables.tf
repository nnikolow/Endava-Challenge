# DB Subnet Group vars
variable "db_subnet" {
  description = "db subnet group"
  type        = list(string)
}


# DB Security Group vars
variable "ec2_security_group" {
  description = "ec2 sg"
  type        = string
}

variable "vpc" {
  description = "vpc for security group"
  type        = string
}


# Database vars
variable "db_identifier" {
  description = "db identifier"
  type        = string
  default     = "rds"
}

variable "db_storage_type" {
  description = "db storage type"
  type        = string
  default     = "gp2"
}

variable "db_engine" {
  description = "db engine"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "db storage version"
  type        = string
  default     = "13.7"
}

variable "db_instance_class" {
  description = "db instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "db name"
  type        = string
  default     = "postgres"
}

variable "db_username" {
  description = "db user"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "db pass"
  type        = string
  sensitive   = true
}

