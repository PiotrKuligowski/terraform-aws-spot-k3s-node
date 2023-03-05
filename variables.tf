variable "component" {
  description = "Component name, will be used to generate names for created resources"
  type        = string
  default     = "node"
}

variable "project" {
  description = "Project name, will be used to generate names for created resources"
  type        = string
  default     = "k3s"
}

variable "tags" {
  description = "Tags to attach to resources"
  default     = {}
}

variable "ami_id" {
  description = "AMI ID to use for EC2 instances created by AutoScaling Group"
  type        = string
}

variable "ssh_key_name" {
  description = "Key pair name for SSH"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EC2 instances should be created"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet ids where EC2 instances should be created"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t4g.micro"
}

variable "user_data" {
  description = "EC2 bootstrap script that will be executed at instance boot"
  type        = string
  default     = ""
}

variable "policy_statements" {
  description = "Policy statements to attach to IAM role used by EC2 Instances"
  default     = {}
}

variable "asg_min_size" {
  description = "Min number of running instances"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Max number of running instances"
  type        = number
  default     = 1
}

variable "asg_desired_capacity" {
  description = "Desired number of running instances"
  type        = number
  default     = 1
}

variable "security_groups" {
  description = "List of additional security groups to attach to EC2 instances"
  type        = list(string)
  default     = []
}

variable "associate_public_ip_address" {
  description = "Flag indicating whether public ip should be associated"
  default     = false
}

variable "join_command_param_name" {
  description = "Name of SSM parameter containing join command"
  type        = string
}