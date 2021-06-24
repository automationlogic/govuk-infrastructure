output "cluster_securitygroup_id" {
  value = aws_security_group.k8s-sg-cluster.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.k8s-cluster.endpoint
}
