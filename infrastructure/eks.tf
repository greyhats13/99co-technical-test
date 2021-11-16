resource "aws_iam_role" "eks_role" {
  name = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub[0]}-role"

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

resource "aws_iam_role_policy_attachment" "eks_cluster_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "eks_pods_sg_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_role.name
}

resource "aws_eks_cluster" "cluster" {
  name     = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub[0]}"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = aws_subnet.node.*.id
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_attachment,
    aws_iam_role_policy_attachment.eks_pods_sg_attachment,
  ]
}

resource "aws_iam_role" "node_role" {
  name = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub[1]}-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_ecr_policy_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_role.name
}

resource "aws_eks_node_group" "ondemand" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub[1]}"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = aws_subnet.node.*.id

  scaling_config {
    desired_size = 3
    max_size     = 6
    min_size     = 3
  }

  update_config {
    max_unavailable = 2
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_policy_readonly,
  ]
}

resource "aws_eks_node_group" "spot" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub[1]}"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = aws_subnet.node.*.id

  scaling_config {
    desired_size = 3
    max_size     = 6
    min_size     = 3
  }

  update_config {
    max_unavailable = 2
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_policy_readonly,
  ]
}