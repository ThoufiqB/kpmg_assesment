#Creation of Cluster
resource "aws_eks_cluster" "tz-labs" {
  name     = var.cluster_name
  role_arn = aws_iam_role.tz-labs.arn

#VPC Configuration being defined
  vpc_config {
    subnet_ids              = var.aws_public_subnet
    endpoint_public_access  = var.endpoint_public_access
    endpoint_private_access = var.endpoint_private_access
    public_access_cidrs     = var.public_access_cidrs
    security_group_ids      = [aws_security_group.node_group_one.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.tz-labs-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.tz-labs-AmazonEKSVPCResourceController,
  ]
}

#Creation of NodeGroup
resource "aws_eks_node_group" "tz-labs" {
  cluster_name    = aws_eks_cluster.tz-labs.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.tz-labs2.arn
  subnet_ids      = var.aws_public_subnet
  instance_types  = var.instance_types

  remote_access {
    source_security_group_ids = [aws_security_group.node_group_one.id]
    ec2_ssh_key               = var.key_pair
  }

  scaling_config {
    desired_size = var.scaling_desired_size
    max_size     = var.scaling_max_size
    min_size     = var.scaling_min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.tz-labs-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.tz-labs-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.tz-labs-AmazonEC2ContainerRegistryReadOnly,
  ]
}
#Creation of Security Group
resource "aws_security_group" "node_group_one" {
  name_prefix = "node_group_one"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Creation of IAM Role One will be attached to the Cluster and the other will be attached to the Node Group
resource "aws_iam_role" "tz-labs" {
  name = "eks-cluster-tz-labs"

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

resource "aws_iam_role_policy_attachment" "tz-labs-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.tz-labs.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "tz-labs-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.tz-labs.name
}

resource "aws_iam_role" "tz-labs2" {
  name = "eks-node-group-tz-labs"

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

resource "aws_iam_role_policy_attachment" "tz-labs-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.tz-labs2.name
}

resource "aws_iam_role_policy_attachment" "tz-labs-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.tz-labs2.name
}

resource "aws_iam_role_policy_attachment" "tz-labs-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.tz-labs2.name
}

output "kubeconfig_path" {
  value = aws_eks_cluster.my_cluster.kubeconfig[*].filename
}
