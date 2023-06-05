terraform {
  cloud {
    organization = "saritasa-devops-camps"

    workspaces {
      tags = [
        "owner:maxim-omelchenko",
        "lecture:aws",
        "env:dev"
      ]
    }
  }
}
