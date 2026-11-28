terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.60"
    }
  }
}

provider "proxmox" {
  endpoint  = var.pm_api_url
  api_token = "${var.pm_api_token_id}=${var.pm_api_token_secret}"
  insecure  = true
}

variable "pm_api_url" {
  type = string
}

variable "pm_api_token_id" {
  type = string
}

variable "pm_api_token_secret" {
  type      = string
  sensitive = true
}

variable "ssh_public_key" {
  type = string
}

# ВМ1 — для БД (dbserver)
resource "proxmox_virtual_environment_vm" "db_server" {
  name      = "vm1-db-terraform"
  node_name = "pve"
  tags      = ["db", "ml-project"]
  started   = false

  clone {
    vm_id = 9000
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "192.168.56.101/24"
        gateway = "192.168.56.1"
      }
    }
    user_account {
      username = "student"
      keys     = [var.ssh_public_key]
    }
  }
}

# ВМ2 — для приложения (app-server)
resource "proxmox_virtual_environment_vm" "app_server" {
  name      = "vm2-app-terraform"
  node_name = "pve"
  tags      = ["app", "ml-project"]
  started   = false

  clone {
    vm_id = 9000
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 4096
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "192.168.56.102/24"
        gateway = "192.168.56.1"
      }
    }
    user_account {
      username = "student"
      keys     = [var.ssh_public_key]
    }
  }
}

output "db_ip" {
  value = "192.168.56.101"
}

output "app_ip" {
  value = "192.168.56.102"
}
