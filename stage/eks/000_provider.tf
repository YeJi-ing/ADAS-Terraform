#########################################################################################################
## Configure the AWS Provider
#########################################################################################################
provider "aws" {

  region = "ap-northeast-2"

  default_tags {
    tags = {
      managed_by = "terraform"
    }
  }
}