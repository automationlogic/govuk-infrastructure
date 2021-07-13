resource "aws_iam_role" "k8s-iam-role-node" {
  name = "${var.cluster_name}-role-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "k8s-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.k8s-iam-role-node.name
}

resource "aws_iam_role_policy_attachment" "k8s-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.k8s-iam-role-node.name
}

resource "aws_iam_role_policy_attachment" "k8s-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.k8s-iam-role-node.name
}

resource "aws_eks_node_group" "k8s-node-group" {
  cluster_name    = aws_eks_cluster.k8s-cluster.name
  node_group_name = var.cluster_name
  node_role_arn   = aws_iam_role.k8s-iam-role-node.arn
  subnet_ids      = var.subnet_ids
  #instance_types  = ["m3.medium", "m3.medium"]
  instance_types  = ["c5.2xlarge", "c5.2xlarge"]
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.k8s-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.k8s-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.k8s-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}
