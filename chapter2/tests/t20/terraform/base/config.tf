terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = "~> 5.1"

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }
    null = "~> 3.2.1"
  }
}

provider "aws" {
  default_tags {
    tags = {
      Owner      = "maxim-omelchenko"
      Camp       = true
      project    = "wp"
      terraform  = true
      git        = "https://github.com/rtest12/devops-camp-2023.git"
      branch     = "Task_20"
      created_by = "maxim-omelchenko"
      created_at = "06/17/2023"
      updated_at = "06/17/2023"
    }
  }
}
