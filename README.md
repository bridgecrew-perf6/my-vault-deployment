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

## Process & Improvements:
- [ ] module variables for the Vault port
- [ ] AMI's fixed per module, Opinionated! find another excuse for locals :)))
- [ ] Bastion provisioning is now empty. Perhaps provision in a way so that it can only access vault on 8200 via the CLI and no SSH access?

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