variable "vpc" {
  type = string
}

variable "subnet_id" {
  type = list(string)
}

variable "alb_target_group_arn" {
  type = string
}