#K8s Cluster role 
resource "aws_iam_role" "k8s-iam-role-cluster" {
  name = "${var.cluster_name}-k8s-iam-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "k8s-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.k8s-iam-role-cluster.name
}

resource "aws_iam_role_policy_attachment" "k8s-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.k8s-iam-role-cluster.name
}

resource "aws_security_group" "k8s-sg-cluster" {
  name        = "${var.cluster_name}-k8s-sg-master-nodes"
  description = "Allos master nodes communicate with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.cluster_name}-k8s-sg-master-nodes-${var.environment}-${var.workspace}"
    },
  )
}

resource "aws_eks_cluster" "k8s-cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.k8s-iam-role-cluster.arn
  version  = var.k8s_version

  vpc_config {
    security_group_ids = [aws_security_group.k8s-sg-cluster.id]
    subnet_ids         = var.subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.k8s-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.k8s-cluster-AmazonEKSServicePolicy,
  ]
}
