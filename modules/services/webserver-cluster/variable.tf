variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for remote state"
  type        = string
}

variable "db_remote_state_key" {
  description = "The path of the remote state file in S3"
  type        = string
}

variable "instance_type" {
  description = "The instance type"
  type        = string
  default     = "t2.micro"
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 5
}
