# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "region" {
  description = "Region for GCP resources."
  type        = string
}

variable "terraform_owner_email" {
  description = "Email address of the ServiceAccount that can be impersonated to perform TF operations"
  type        = string
}

variable "cluster_name" {
  description = "Cluster Name"
  type        = string
}

variable "asg_desired_capacity" {
  description = ""
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = ""
  type        = number
  default     = 1
}
variable "asg_min_size" {
  description = ""
  type        = number
  default     = 1
}

variable "subnets" {
  description = "Subnets"
  type        = list(string)
  default     = []
}

variable "cluster_enabled_log_types" {
  description = "cluster enabled log types"
  type        = list(string)
  default     = []
}


variable "instance_type " {
  description = "instance type"
  type        = string
  default     = "m4.large"
}

variable "spot_price" {
  description = "spot_price"
  type        = string
  default     = "0.20"
}


variable "environment" {
  description = "environment"
  type        = string
}
