client  = "maxim-omelchenko"
project = "wp"

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ fqdn vars                                                                                                        │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

root_domain           = "saritasa-camps.link"
acm_validation_method = "DNS"

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ rds db variables                                                                                                 │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

rds_engine                  = "mysql"
rds_family                  = "mysql8.0"
rds_major_engine_version    = "8.0"
rds_engine_version          = "8.0"
rds_instance_class          = "db.t4g.micro"
rds_allocated_storage       = 20
rds_max_allocated_storage   = 1000
rds_db_name                 = "wordpress_db"
rds_db_user                 = "user_db"
rds_port                    = "3306"
rds_monitoring_interval     = 0
rds_backup_retention_period = 10
rds_backup_window           = "03:00-06:00"
rds_maintenance_window      = "Mon:20:00-Mon:20:30"
rds_skip_final_snapshot     = false
rds_publicly_accessible     = false
rds_deletion_protection     = false
rds_options_list            = []
rds_cloudwatch_logs_list    = []

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ ec2 variables                                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

ec2_volume_size     = 20
ec2_volume_type     = "gp3"
ec2_instances_count = 2
ec2_instance_type   = "t3.micro"
ec2_ssm_role        = "ssm-role"
ec2_user            = "ec2-user"

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ ssh variables                                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

# list of saritasa vpn ip addresses
allowed_ssh_ip = ["195.201.120.196/32", "99.128.21.249/32"]

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ list of keys for which to generate random passwords                                                              │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

password_keys = [
  "wordpress_password",
  "auth_key",
  "secure_auth_key",
  "logged_in_key",
  "nonce_key",
  "auth_salt",
  "secure_auth_salt",
  "logged_in_salt",
  "nonce_salt",
  "db_password"
]

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ efs vars                                                                                                         │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

efs_performance_mode = "generalPurpose"
