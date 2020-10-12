variable "vpc_id" {
  type = string
}

variable "govuk_app_domain_external" {
  type = string
}

variable "govuk_website_root" {
  type = string
}

variable "private_subnets" {
  description = "Subnet IDs to use for non-Internet-facing resources."
  type        = list
}

variable "public_subnets" {
  description = "Subnet IDs to use for Internet-facing resources."
  type        = list
}

# TODO: find out how asset_host is actually used and add a description to disambiguate it.
variable "asset_host" {
  type = string
}

variable "mongodb_host" {
  type = string
}

variable "redis_host" {
  description = "Hostname for the shared Redis (which isn't managed by this Terraform repo, at least initially)."
  type        = string
}

variable "redis_security_group_id" {
  description = "ID of security group for the shared Redis (which isn't managed by this Terraform repo, at least initially)."
  type        = string
}

variable "statsd_host" {
  type = string
}

variable "documentdb_security_group_id" {
  description = "ID of security group for the shared DocumentDB (which isn't managed by this Terraform repo, at least initially)."
  type        = string
}

# TODO: pull common vars up from the app modules into here so that they can vary by environment.
