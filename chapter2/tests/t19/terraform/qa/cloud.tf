terraform {
  cloud {
    organization = "saritasa-devops-camps"

    workspaces {
      tags = [
        "owner:test-student-user",
        "lecture:environments",
        "env:qa"
      ]
    }
  }
}

