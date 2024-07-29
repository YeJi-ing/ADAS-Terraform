output "subnets_controlled_by_eks" {
  description = "subnets' ids should be controlled by eks"
  value = data.aws_subnets.bastion_subnet.ids
}
