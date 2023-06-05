terraform {
  cloud {
    organization = "saritasa-devops-camps"

    workspaces {
      tags = [
        "owner:maxim-omelchenko",
        "lecture:environments",
        "env:staging"
      ]
    }
  }
}
