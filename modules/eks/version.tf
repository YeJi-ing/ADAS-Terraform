terraform {
  required_version = "1.7.3"
  required_providers {
  kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }
}