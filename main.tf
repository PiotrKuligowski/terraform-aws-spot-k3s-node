data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "spot-nodes" {
  source                      = "git::https://github.com/PiotrKuligowski/terraform-aws-spot-asg.git"
  ami_id                      = var.ami_id
  ssh_key_name                = var.ssh_key_name
  subnet_ids                  = var.subnet_ids
  vpc_id                      = var.vpc_id
  user_data                   = join("\n", [local.node_user_data, var.user_data])
  policy_statements           = local.node_required_policy
  project                     = var.project
  component                   = var.component
  tags                        = var.tags
  instance_type               = var.instance_type
  security_groups             = var.security_groups
  associate_public_ip_address = var.associate_public_ip_address
  asg_min_size                = var.asg_min_size
  asg_max_size                = var.asg_max_size
  asg_desired_capacity        = var.asg_desired_capacity
}

locals {
  node_user_data = <<-EOF
# Waiting max 15s x 12 = 180s = 3mins for master id to be set by master
retries=0;
while [[ "$(aws ssm get-parameter --name ${var.join_command_param_name} --region=${data.aws_region.current.name} --output text --query Parameter.Value | grep -c 'default')" -eq "1" ]]; do
    sleep 15;
    ((retries+=1));
    if [ $retries -eq 12 ]; then
        break
    fi
done
bash -c "$(aws ssm get-parameter --name ${var.join_command_param_name} --region=${data.aws_region.current.name} --output text --query Parameter.Value)"
EOF

  node_required_policy = merge({
    AllowPutParameter = {
      effect = "Allow"
      actions = [
        "ssm:GetParameter"
      ]
      resources = [
        "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.project}/*"
      ]
    }
  }, var.policy_statements)
}