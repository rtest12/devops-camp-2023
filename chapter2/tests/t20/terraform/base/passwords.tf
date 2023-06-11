resource "random_password" "wordpress_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}

resource "random_password" "auth_key" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}

resource "random_password" "secure_auth_key" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}

resource "random_password" "logged_in_key" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}

resource "random_password" "nonce_key" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}

resource "random_password" "auth_salt" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}

resource "random_password" "secure_auth_salt" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}

resource "random_password" "logged_in_salt" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}

resource "random_password" "nonce_salt" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}
