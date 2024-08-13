## Setup

The following environment variables are needed

```
export GHOST_SERVER_IP
export DIGITAL_OCEAN_TOKEN
export DIGITAL_OCEAN_SSH_KEY_ID
```

## Provisioning steps

1. Install provider
   `terraform init`
2. Run plan
   `terraform plan -var="do_token=$DIGITAL_OCEAN_TOKEN" -var="ssh_key_id=$DIGITAL_OCEAN_SSH_KEY_ID" -var="alert_email=$ALERT_EMAIL" -o blog.plan`
3. Apply changes
   `terraform apply -var="do_token=$DIGITAL_OCEAN_TOKEN" -var="ssh_key_id=$DIGITAL_OCEAN_SSH_KEY_ID" -var="alert_email=$ALERT_EMAIL"`

## Deployment steps

1. Install ansible roles
   `ansible-galaxy install -r ./playbook/requirements.yaml`
2. Run the playbook
   `ansible-playbook -u root -i "$GHOST_SERVER_IP," ./playbook/playbook.production.yaml`

## Relevant blog posts
1. [How I cut my cloud costs by 70%](https://hackandslash.blog/how-i-cut-my-cloud-costs-by-70-percent/)
2. [How to deploy ghost using Ansible, Terraform, and Ghost CLI](https://hackandslash.blog/how-to-deploy-ghost-using-ansible-terraform-and-ghost-cli/)
