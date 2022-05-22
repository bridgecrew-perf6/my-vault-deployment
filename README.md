# My Vault deployment

This is a simple Vault deployment.
It was created to practise designing, writing and using Terraform modules.

Overview:

How to deploy:

Networking:

Modules:

Variables:

Kown issues and quirks:
```
Received disconnect from 34.241.60.238 port 22:2: Too many authentication failures
```
This can occur when there are too many keys on the ssh-agent keyring. One solution is discard the current keyring with `ssh-add -D` and add the ssh key for this deployment again with `ssh-add tmp/bastion_ssh_key`.

TODO:
# TODO Refactor where instance get their public ip boolean configured, instance level VS vpc level?
# TODO igw: seperate vars for allow_access_from_internet en allow_access_to_internet
# TODO intelligenter maken met outputs oid? Wat als meerdere subnets ofzo, hoe met outputs/data?
# TODO make local for the AWS tags Name field?
# TODO Vault server + provision ing with userdata <-- !!!
# TODO bastion toegang geven op alle (evt. gemarkeerde) servers in subnet?
# TODO Variables have to reorganized variables.tfvars -> variables.tf -> main.tf -> module variables
# ssh_cidr_blocks = .... #TODO waarom is het stuk als ik hier de list(string) definieer in vars.tfvars