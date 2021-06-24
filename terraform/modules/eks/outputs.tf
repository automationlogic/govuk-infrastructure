output "cluster_securitygroup_id" {
  value = aws_security_group.k8s-sg-cluster.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.k8s-cluster.endpoint
}

output "cluster_certificate" {
  value = aws_eks_cluster.k8s-cluster.certificate_authority.0.data
}
