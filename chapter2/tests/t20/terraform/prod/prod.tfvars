/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ env=specific configuration variables                                                                             │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

environment = "prod"


/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ redis configuration variables                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

cache_vpc_tags = {
  Name = "default"
}

cache_availability_zones   = ["us-east-2a", "us-east-2b", "us-east-2c"]
cache_engine               = "redis"
cache_engine_version       = "6.x"
cache_node_type            = "cache.t3.micro"
cache_node_count           = 1
cache_parameter_group_name = "default.redis6.x"
cache_port                 = 6379
