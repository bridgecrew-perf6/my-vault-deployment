# My Vault deployment

This is a simple Vault deployment.
It was created to practise designing, writing and using Terraform modules.

## Overview:

## How to deploy:

## Networking:

## Modules:

## Variables:

## Kown issues and quirks:

```
Received disconnect from 34.241.60.238 port 22:2: Too many authentication failures
```
This can occur when there are too many keys on the ssh-agent keyring. One solution is discard the current keyring with `ssh-add -D` and add the ssh key for this deployment again with `ssh-add tmp/bastion_ssh_key`.

## test with images
![test tiff](dynamic_vault_port_todo.tiff)

![test psd](dynamic_vault_port_todo.psd)
![test psd](dynamic_vault_port_todo.jpeg)

## Process & Improvements:
- [ ] module: Vault-mariadb (dynamic secrets engine)
  - [ ] Readme
  - [ ] cicd
- [x] module: aws-mariadb-simple
  - [x] readme
  - [ ] cicd
- [ ] module variables for the Vault port
        - [x] template for install script to make the Vault listener port variable
        - [x] make variable for the root module outputs.tf
        - [x] make variable for the vault security group in AWS
        - [ ] allow privilidged ports, sub 1000 ports like 443/80 etc.
          - [LINK](https://superuser.com/questions/710253/allow-non-root-process-to-bind-to-port-80-and-443)
- [ ] Fix finger printing for bastion and vault.
- [ ] AMI's fixed per module, Opinionated! find another excuse for locals :)))
- [ ] Bastion provisioning is now empty. Perhaps provision in a way so that it can only access vault on 8200 via the CLI and no SSH access?

- [ ] - module aws vpc: module doet veel meer dan alleen VPC, hernoemen?

- [ ] - Toevoegen vault dummy clients (machine AND/OR human, kv en dynamic?)
  - [ ] Vet goed idee, is wel een twee traps raket --> 1. module voor db infra   2. module voor het inrichten van Vault voor de nieuwe db infra.
- [ ] - wijzigen naar arm nodes voor meer performance/cost?

- [ ] pre-commit README generation
- [ ] DOING - Finish vault provisioning (configure Vault + tls cert)
        - [ ] output cloud-init to terraform output? (scp/Provisioning stanza vs User_Data+cloud-init?)
        - [ ] Dedicated vault user
        - [ ] Vault TLS certs for HTTPS
- [ ] monolithic to modulair


## Done
- [x] try(function) input pubkey voor gebruiker om zelf mee te geven aan de modules (vault en bastion)
- [x] variables.tf --> validation toevoegen waar nodig/nuttig. In specifiek bij strings
- [x] duplicate AMI data blocks to modules and set a default, can be overwritten from root module by end user!
        - [x] Use Locals for SOMETHING, just to learn --> voor vaak terugkerende code OF code die erg lang/complex worden in de module/main.tf.
- [x] renamed many variables and data/resource names to be more simple/logical
- [x] seperate rout instead of integrated stanza in aws_route_table
- [x] refactored aws tags everywhere, but no locals used! --> tags, Name (functie van resource) EN owener = (richard), no random hash yet and no cluster differenciation yet