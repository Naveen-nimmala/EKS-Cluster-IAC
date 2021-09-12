


module "eks-cluster" {
  source       = "terraform-aws-modules/eks/aws"
  version      = "v7.0.1"
  cluster_name = var.cluster_name
  subnets      = var.subnets
  vpc_id       = var.vpc_id
  worker_groups = [
    {
      spot_price           = var.spot_price
      asg_desired_capacity = var.asg_desired_capacity
      asg_max_size         = var.asg_max_size
      asg_min_size         = var.asg_min_size
      instance_type        = var.instance_type
      name                 = "worker-group"
      additional_userdata  = "Worker group configurations"
      tags = [{
        key                 = "worker-group-tag"
        value               = "worker-group-1"
        propagate_at_launch = true
      }]
    }
  ]
  map_users = [
    {
      userarn  = "arn:aws:iam::AWS_ACCOUNT:user/AWS_USERNAME"
      username = "AWS_USERNAME"
      groups   = ["system:masters"]
    },
  ]
  cluster_enabled_log_types = var.cluster_enabled_log_types
  tags = {
    environment = var.environment
  }
}