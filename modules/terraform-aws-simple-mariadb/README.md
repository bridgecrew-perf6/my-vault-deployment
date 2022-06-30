# module: terraform-aws-simple-mariadb
This Terraform module creates a very simple and oppinionated MariaDB AWS RDS instance.



![overview](overview.drawio.svg)



## Inputs:
||Description|
|---|---|
|db_subnet_group|Group of multiple subnets that are available to the MariaDB instance. Minimum is 2 subnets in atleast 2 availability zones.|
|password|MariaDB root password.|
|username|MariaDB root username.|
|VPC|The MariaDB instance is deployed in this VPC.|



## Outputs:
||Description|
|---|---|
|address|MariaDB address to connect to.|
|password|see inputs.|
|username|see inputs.|
