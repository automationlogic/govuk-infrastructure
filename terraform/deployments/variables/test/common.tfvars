govuk_aws_state_bucket              = "govuk-terraform-steppingstone-test"
cluster_infrastructure_state_bucket = "govuk-terraform-test"

cluster_version               = 1.21
cluster_log_retention_in_days = 7

eks_control_plane_subnets = {
  a = { az = "eu-west-1a", cidr = "10.200.38.0/28" }
  b = { az = "eu-west-1b", cidr = "10.200.38.16/28" }
  c = { az = "eu-west-1c", cidr = "10.200.38.32/28" }
}

eks_public_subnets = {
  a = { az = "eu-west-1a", cidr = "10.200.39.0/24" }
  b = { az = "eu-west-1b", cidr = "10.200.40.0/24" }
  c = { az = "eu-west-1c", cidr = "10.200.41.0/24" }
}

eks_private_subnets = {
  a = { az = "eu-west-1a", cidr = "10.200.44.0/22" }
  b = { az = "eu-west-1b", cidr = "10.200.48.0/22" }
  c = { az = "eu-west-1c", cidr = "10.200.52.0/22" }
}

govuk_environment = "test"
force_destroy     = true

publishing_service_domain = "test.publishing.service.gov.uk"
external_dns_subdomain    = "bill"

frontend_memcached_node_type   = "cache.t4g.micro"
shared_redis_cluster_node_type = "cache.t4g.small"
