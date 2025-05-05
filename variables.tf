variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public (web) subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"] # /24 gives 256 IPs per subnet
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for private (app) subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for private (DB) subnets"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "availability_zones" {
  description = "AZs for subnet placement"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "enable_internet_access" {
  description = "Enable 0.0.0.0/0 internet access for public subnets"
  type        = bool
  default     = true
}

variable "my_ip" {
  description = "Your public IP address for SSH access to jump server"
  type        = string
  default     = "154.161.18.192"  # Replace with your actual IP
}
