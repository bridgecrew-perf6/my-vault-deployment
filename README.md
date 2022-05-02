# My Vault deployment

This is a simple Vault deployment.
It was created to practise designing, writing and using Terraform modules.

This deployment will use the following modules:
- terraform-aws-simple-vpc
- terraform-aws-simple-ec2
- terraform-aws-simple-vault
- terraform-aws-simple-bastion

Variables:
- VPC
    - region
    - AZs
    - cidr
    - internet accessable boolean
    - subnet(s)
- ec2
    - count?
    - vpc_id
    - subnet_id
- Bastion
    - setup ssh access to all ec2 instances within subnet with ssh keys
- vault
    - 
    - api endpoint/port