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

## Process & Improvements:
- [ ] duplicate AMI data blocks to modules and set a default, can be overwritten from root module by end user!
- [ ] tags, Name (functie van resource) EN owener = (richard)
- [ ] Use Locals for SOMETHING, just to learn --> voor vaak terugkerende code OF code die erg lang/complex worden in de module/main.tf.
- [ ] input pubkey voor gebruiker om zelf mee te geven aan de modules (vault en bastion)
- [ ] var namen langs lopen en namen zo simpel mogelijk maken
- [ ] variables.tf --> validation toevoegen waar nodig/nuttig. In specifiek bij strings
- [ ] Bastion provisioning is nu leeg. In richten zodat Vault cmds draaien vanaf de bastion en vault server zelf dicht zetten? Var toevoegen "debug" als true dan pas door hoppen met ssh?

- [ ] pre-commit README generation
- [ ] DOING - Finish vault provisioning (configure Vault + tls cert)
        - [ ] output cloud-init to terraform output? (scp/Provisioning stanza vs User_Data+cloud-init?)
        - [ ] Dedicated vault user
        - [ ] Vault TLS certs for HTTPS
- [ ] monolithic to modulair


## Done
- [x] renamed many variables and data/resource names to be more simple/logical
- [x] seperate rout instead of integrated stanza in aws_route_table
- [ ] refactored aws tags everywhere
- [ ] 
- [ ] 
- [ ] 
- [ ] 
       