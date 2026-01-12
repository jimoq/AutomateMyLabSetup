# AutomateMyLabSetup

**Automate Check Point security infrastructure deployment across VMware and Azure environments using Infrastructure as Code (IaC) with Terraform and Ansible.**

## Overview

This repository provides comprehensive automation tools for deploying and managing Check Point security infrastructure in lab and production environments. It supports multiple deployment scenarios including:

- **Security Management Servers** (SMS, MDS, MDLS)
- **Security Gateways** (standalone and clustered)
- **Azure CloudGuard deployments** with auto-scaling
- **Policy and object management** automation

---

## Table of Contents

- [Repository Structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Terraform Deployments](#terraform-deployments)
- [Ansible Playbooks](#ansible-playbooks)
- [Common Workflows](#common-workflows)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)

---

## Repository Structure

### `/Ansible`

Ansible-based automation for Check Point infrastructure:

- **`playbooks/`** - Main deployment playbooks for various scenarios
- **`roles/`** - Reusable Ansible roles for common tasks
- **`demo_mode_policy_ansible/`** - Pre-configured policy objects and rules

### `/Terraform`

Terraform Infrastructure as Code configurations:

- **`VMware/`** - VMware vSphere deployments
- **`azure/`** - Azure cloud deployments
- **`Check-Point/`** - Check Point-specific configurations
- **`modules/`** - Reusable Terraform modules

---

## Prerequisites

### Software Requirements

- **Terraform** >= 0.14.3
- **Ansible** >= 2.9
- **Python** 3.x
- VMware vSphere access (for VMware deployments)
- Azure subscription (for Azure deployments)

### Ansible Collections

Install required Check Point collections:

```bash
ansible-galaxy collection install check_point.mgmt
ansible-galaxy collection install check_point.gaia
```

### Access Requirements

- VMware vCenter credentials with VM deployment permissions
- Check Point management credentials
- Azure credentials (if deploying to Azure)
- Check Point licenses (BYOL or subscription)

---

## Getting Started

### Initial Setup for VMware Deployments

#### 1. Create the Template Virtual Machine

Before using this automation, you need a Check Point Gaia template in your VMware environment:

1. Clean install Check Point Gaia OS
2. Configure DHCP on the management interface:
   ```bash
   add dhcp client interface eth0
   save config
   halt
   ```
3. Convert the virtual machine to a template in vCenter

#### 2. Configure Inventory

Edit the Ansible inventory file:

```bash
cd Ansible/playbooks
vi hosts
```

Update with your Check Point management server details:
```ini
[check_point]
192.168.100.110

[check_point:vars]
ansible_httpapi_use_ssl=True
ansible_httpapi_validate_certs=False
ansible_user=admin
ansible_password=YOUR_PASSWORD
ansible_network_os=check_point.gaia.checkpoint
```

---

## Terraform Deployments

### VMware vSphere Deployments

#### Deploy Primary Management Server (MDS)

```bash
cd Terraform/new-gaia-instance
terraform init
terraform plan -var-file="pri-mds10.tfvars"
terraform apply -var-file="pri-mds10.tfvars"
```

#### Deploy Security Gateway

```bash
cd Terraform/VMware/1.1-build-my-lab
terraform init
terraform plan
terraform apply
```

#### Configuration Variables

Create a `.tfvars` file with your environment details:

```hcl
vsphere_user       = "administrator@vsphere.local"
vsphere_password   = "your-password"
vsphere_server     = "vcenter.yourdomain.com"
vsphere_datacenter = "Datacenter"
vsphere_datastore  = "datastore1"
vsphere_host       = "esxi01.yourdomain.com"
mgmt_net          = "VM Network"
remote_ovf_url    = "https://path-to-checkpoint-ova"
```

### Azure Deployments

#### Deploy CloudGuard Auto-Scaling Environment

```bash
cd Terraform/azure
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

This deployment creates:
- **Resource Group** with VNet and subnets
- **Check Point CloudGuard** auto-scaling VMSS (Virtual Machine Scale Set)
- **Load Balancers** (external and internal)
- **Ubuntu web servers** in DMZ zones
- **Network Security Groups** and routing tables
- **Auto-scaling rules** based on CPU metrics

#### Deploy Multi-Domain Server (MDS) in Azure

```bash
cd Terraform/terraform-mds-mlm
terraform init
terraform plan
terraform apply
```

---

## Ansible Playbooks

### Available Playbooks

Navigate to the playbooks directory:

```bash
cd Ansible/playbooks
```

#### Infrastructure Deployment

| Playbook | Description | Usage |
|----------|-------------|-------|
| `primary_mds_create.yml` | Deploy Primary Multi-Domain Server | `ansible-playbook primary_mds_create.yml -e "vm_name=mds01 target=192.168.1.10"` |
| `primary_sms_create.yml` | Deploy Primary Security Management Server | `ansible-playbook primary_sms_create.yml -e "vm_name=sms01 target=192.168.1.11"` |
| `sg_create.yml` | Deploy Security Gateway | `ansible-playbook sg_create.yml -e "vm_name=gw01 target=192.168.1.20"` |
| `sms_ha_create.yml` | Deploy SMS High Availability pair | `ansible-playbook sms_ha_create.yml -e "vm_name=sms-ha"` |
| `mdsm_farm_create.yml` | Deploy MDS farm/cluster | `ansible-playbook mdsm_farm_create.yml` |
| `ls_se_create.yml` | Deploy Log Server and Smart Event | `ansible-playbook ls_se_create.yml` |

#### Destruction Playbooks

| Playbook | Description |
|----------|-------------|
| `all_destroy.yml` | Remove all deployed infrastructure |
| `vm_ware_instance_destroy.yml` | Remove specific VMware instances |
| `sms_ha_destroy.yml` | Remove SMS HA deployment |
| `mdsm_farm_destroy.yml` | Remove MDS farm |

#### Policy Management

Deploy pre-configured policy and objects:

```bash
cd Ansible/demo_mode_policy_ansible
ansible-playbook cp_mgmt_playbook.yml -i hosts
```

This playbook configures:
- Network objects (hosts, networks, ranges)
- Service objects and groups
- Security zones and access layers
- VPN communities
- Access control rules
- Threat prevention layers

### Playbook Options

Most playbooks support these parameters:

- **`vm_name`** - Name of the virtual machine to create
- **`target`** - IP address for the new instance
- **`nr`** - Number identifier for the instance
- **`type`** - Deployment type (primary_mds, secondary_mds, mdls, primary_sms, secondary_sms, ls_se, smsg, sg)
- **`esxi_hostname`** - Target ESXi host (cloud02.local, cloud03.local)
- **`vm_template`** - Template to use (cloud02_r81dot10, cloud03_r81dot10, etc.)
- **`gaia_password`** - Admin password for Gaia OS

**Example:**
```bash
ansible-playbook primary_sms_create.yml \
  -e "vm_name=sms-prod01" \
  -e "target=192.168.100.50" \
  -e "type=primary_sms" \
  -e "esxi_hostname=cloud02.local" \
  -e "vm_template=cloud02_r81dot10" \
  -e "gaia_password=SecurePass123"
```

---

## Common Workflows

### Deploy a Complete Lab Environment

#### Using Terraform (VMware)

```bash
cd Terraform/VMware/1.1-build-my-lab
terraform init
terraform apply -auto-approve
```

#### Using Ansible

1. **Deploy Management Server:**
   ```bash
   cd Ansible/playbooks
   ansible-playbook primary_sms_create.yml -e "vm_name=sms01 target=192.168.100.10"
   ```

2. **Deploy Security Gateway:**
   ```bash
   ansible-playbook sg_create.yml -e "vm_name=gw01 target=192.168.100.20"
   ```

3. **Configure Policy:**
   ```bash
   cd ../demo_mode_policy_ansible
   ansible-playbook cp_mgmt_playbook.yml
   ```

### Deploy High Availability Setup

```bash
cd Ansible/playbooks
ansible-playbook sms_ha_create.yml -e "vm_name=sms-ha"
```

### Add Domain to Multi-Domain Server

```bash
ansible-playbook chkp_add_domain_policy.yml \
  -e "domain_name=Customer1" \
  -e "mds_ip=192.168.100.10"
```

### Deploy Azure CloudGuard with Auto-Scaling

```bash
cd Terraform/azure
terraform init
terraform apply
```

Monitor the deployment, and after completion:
- External Load Balancer VIP will be displayed in outputs
- Web servers accessible through CloudGuard
- Auto-scaling triggered at 80% CPU (scale up) and 60% (scale down)

---

## Configuration

### Ansible Roles

The repository includes reusable roles in `Ansible/roles/`:

| Role | Purpose |
|------|---------|
| `vm_ware_deploy_instance` | Deploy VM from template in VMware |
| `vm_ware_remove_instance` | Remove VMware instances |
| `chkp_config_gaia` | Configure Gaia OS (FTW, network, etc.) |
| `chkp_add_sg` | Add Security Gateway to management |
| `chkp_add_sg_cluster` | Configure Security Gateway cluster |
| `chkp_add_mds_domain` | Add domain to MDS |
| `chkp_domain_policy` | Configure domain-level policies |
| `chkp_zero_touch` | Zero-touch provisioning |
| `chkp_update_and_install` | Update and install policies |

### Terraform Modules

Reusable modules in `Terraform/modules/`:

- **`vmware/`** - VMware infrastructure provisioning
- **`chkp-config-gaia/`** - Check Point Gaia configuration

---

## Troubleshooting

### Common Issues

#### Ansible Connection Failures

**Issue:** Cannot connect to Check Point management
```
FAILED! => {"msg": "Authentication failure"}
```

**Solution:**
- Verify credentials in `hosts` file
- Check management server is accessible
- Ensure API is enabled: `api status` on Gaia

#### Terraform VMware Deployment Fails

**Issue:** Template not found

**Solution:**
- Verify template name in variables
- Ensure template exists in vCenter
- Check datacenter and datastore names

#### Azure Marketplace Agreement Required

**Issue:** Must accept marketplace terms

**Solution:**
The Terraform code includes marketplace agreement acceptance, but you may need to manually accept:
```bash
az vm image terms accept \
  --publisher checkpoint \
  --offer check-point-cg-r8040 \
  --plan sg-byol
```

### Debug Mode

Run Ansible with verbose output:
```bash
ansible-playbook playbook.yml -vvv
```

Run Terraform with debug logging:
```bash
export TF_LOG=DEBUG
terraform apply
```

### Check Point API Debugging

Enable API debugging on the management server:
```bash
api set-debug admin on
api show-debug
```

---

## Support and Contribution

This is a lab automation project for Check Point security infrastructure deployment. Customize the configurations according to your environment requirements.

### Key Configuration Files to Update:

1. **Ansible inventory:** `Ansible/playbooks/hosts`
2. **Terraform variables:** Create `.tfvars` files for your environment
3. **Role defaults:** Check `Ansible/roles/*/defaults/main.yml`
4. **Network configurations:** Update IP addresses, subnets, and VLANs

---

## Security Notes

⚠️ **Important Security Reminders:**

- Change all default passwords before production use
- Store credentials securely (use Ansible Vault or Azure Key Vault)
- Follow Check Point security best practices
- Regularly update Check Point software versions
- Review and customize security policies for your requirements

---

## License

See [LICENSE](LICENSE) file for details.

---

## Version Information

This repository supports:
- **Check Point:** R80.40, R81.10, R81.20
- **Terraform:** >= 0.14.3
- **Ansible:** >= 2.9
- **VMware vSphere:** 6.5+
- **Azure:** Resource Manager
