# main.tf

# Define variables
variable "suffix" {
  default = "ci" # used according to task statement
}

# Module for creating IAM resources
module "iam_resources" {
  source = "./modules/iam"

  suffix = var.suffix
}
