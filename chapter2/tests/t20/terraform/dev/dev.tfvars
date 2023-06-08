/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ env=specific configuration variables                                                                             │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

environment = "dev"

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ configuration variables                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

vpc_tags = {
  Name = "default"
}

availability_zones            = ["us-east-2a", "us-east-2b", "us-east-2c"]

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ rds db variables                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

rds_engine                = "mysql"
rds_family                = "mysql8.0"
rds_major_engine_version  = "8.0"
rds_engine_version        = "8.0"
rds_instance_class        = "db.t4g.micro"
rds_allocated_storage     = 20
rds_max_allocated_storage = 1000

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ ec2 variables                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

ec2_volume_size                   = 20
ec2_volume_type                   = "gp3"
ec2_instances_count               = 2
ec2_ami_id                        = "ami-01107263728f3bef4"
ec2_instance_type                 = "t3.micro"

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ ssh variables                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

ssh_cluster_name = "wordpress_cluster"