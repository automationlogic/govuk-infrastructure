module "eks-master" {
  source       = "../../modules/eks"
  vpc_id       = local.vpc_id
  subnet_ids   = local.private_subnets
  cluster_name = "govuk-eks-${var.govuk_environment}-${local.workspace}"
  k8s_version  = "1.20"
  environment  = var.govuk_environment
  workspace    = local.workspace

}
