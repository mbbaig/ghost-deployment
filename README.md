## Deployment steps

1. Install ansible roles
   `ansible-galaxy install -r ./playbook/requirements.yaml`
2. Run the playbook
   `ansible-playbook -u root -i "$GHOST_SERVER_IP," ./playbook/playbook.production.yaml`
