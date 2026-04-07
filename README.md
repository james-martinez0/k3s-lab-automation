# K3s Lab Automation

This repository contains the **Ansible** automation and **Shell** scripts used to provision, configure, and manage a multi-node Kubernetes cluster and an Ansible Automation Platform (AAP) instance.

## Architecture Overview
* **Automation Controller:** Ansible Automation Platform (AAP) 2.6 (Containerized on RHEL 10).
* **Kubernetes Cluster:** 4-node K3s cluster.
    * **Master:** Ubuntu Node (`192.168.5.40`).
    * **Agents:** 3x Ubuntu Nodes (`192.168.5.41` - `192.168.5.43`).
* **Operating Systems:** Red Hat Enterprise Linux 10 and Ubuntu.

## Repository Structure
* **`inventory/production/`**: Defines the cluster topology.
    * `hosts.yml`: Group definitions for master and agent nodes.
    * `group_vars/`: Host-specific variables and connection settings.
* **`playbooks/`**:
    * `prep_k3s.yml`: OS hardening, firewall configuration, and dependency installation[cite: 1, 5].
    * `install_k3s.yml`: Core logic for initializing the control plane and joining agents.
* **`scripts/aap-install/`**: 
    * `install_aap.sh`: Automated deployment script for the AAP containerized installer.
    * `inventory-growth`: **[Encrypted]** The setup inventory for AAP (protected via Ansible Vault).
* **`ansible.cfg`**: Optimized configuration for roles and inventory paths.

## Getting Started

### 1. Provisioning AAP 
To install or redeploy the Ansible Automation Platform, use the provided shell script. Note that the inventory is encrypted; you will need the Vault password to run this.

```bash
cd scripts/aap-install
./install_aap.sh
```

### 2. Provisioning the K3s Cluster (Day 1)Run the site-wide automation to prepare and install the K3s cluster across all nodes:

```bash
# Prepare the OS (Hostnames, Firewall, Dependencies)
ansible-playbook -i inventory/production/hosts.yml playbooks/prep_k3s.yml

# Install and initialize the K3s cluster
ansible-playbook -i inventory/production/hosts.yml playbooks/install_k3s.yml
```

## Security & Best Practices

- **Ansible Vault**: All sensitive credentials, including the AAP installer inventory, are encrypted to prevent exposure in version control
- **Modular Design**: Automation is broken down into reusable roles and playbooks for better maintainability.
- **Lab Optimization**: The AAP installer is configured with a memory override (ansible_memtotal_mb: 16000) to ensure reliable operation on lab hardware.
