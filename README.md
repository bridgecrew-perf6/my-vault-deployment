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
TODO - DOING - Finish vault provisioning (configure Vault + tls cert)
        - output cloud-init to terraform output? (Provisioning stanza vs User_Data+cloud-init?)
        - Dedicated vault user
        - Vault TLS certs for HTTPS
TODO Make a local for AWS tagging