client  = "maxim-omelchenko"
project = "wp"

tags = {
  project    = "wp"
  terraform  = true
  git        = "https://github.com/rtest12/devops-camp-2023.git"
  branch     = "Task_20"
  created_by = "maxim-omelchenko"
  created_at = "06/12/2023"
  updated_at = "06/12/2023"
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ fqdn vars                                                                                                        │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

site_url            = "tf-maxim-omelchenko.saritasa-camps.link"
site_subdomain_part = "tf-maxim-omelchenko"

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

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ ec2 variables                                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

ec2_volume_size     = 20
ec2_volume_type     = "gp3"
ec2_instances_count = 2
ec2_ami_id          = "ami-01107263728f3bef4"
ec2_instance_type   = "t3.micro"
ec2_ssm_role        = "ssm-role"
ec2_user            = "ec2-user"

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ ssh variables                                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

ssh_cluster_name = "wordpress_cluster"
allowed_ssh_ip   = "195.201.120.196/32"

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ efs variables                                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

efs_name = "wordpress-efs"
