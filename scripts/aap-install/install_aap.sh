#!/bin/bash
cd ~/ansible-automation-platform-containerized-setup-2.6-5 || { echo "Installer directory not found"; exit 1; }

echo "Starting AAP 2.6 Installation (Vault Protected)..."

ansible-playbook -i inventory-growth \
    ansible.containerized_installer.install -K \
    --ask-vault-pass \
    -e "{'ansible_memtotal_mb': 16000}"