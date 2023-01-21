variable "region" {
  description = "The region Terraform deploys your instance"
  default = "eu-central-1"
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