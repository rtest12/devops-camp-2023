terraform {
  required_version = ">= 1.4.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }
    null = "~> 3.2.1"
  }
}
