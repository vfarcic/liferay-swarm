#!/usr/bin/env bash

RED='\033[0;31m'
NC='\033[0;0m'

read -r JSON
echo "Consul watch request:"
echo "$JSON"
echo "$JSON" | jq -r '.[] | select(.CheckID | contains("service:")) | .ServiceName' | while read SERVICE_NAME
do
    echo ""
    echo -e "${RED}>>> Service $SERVICE_NAME is critical${NC}"
    echo ""
    echo "Triggering Ansible playbook $SERVICE_NAME"
    sudo -H -u vagrant bash -c "ansible-playbook /vagrant/ansible/${SERVICE_NAME/-proxy/}.yml -i /vagrant/ansible/hosts/prod -vv"
    echo ""
done
