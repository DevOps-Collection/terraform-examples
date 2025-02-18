# Summary: Uses the 'count' feature to create multiple disks attached to multiple VM instances (with google_compute_attached_disk)

# Documentation: https://www.terraform.io/docs/language/settings/index.html
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.0"
    }
  }
}

# Documentation: https://www.terraform.io/docs/language/values/variables.html
variable "project_id" {
  type = string
}

# Documentation: https://www.terraform.io/docs/language/providers/requirements.html
provider "google" {
  project = var.project_id
  region  = "us-central1"
  zone    = "us-central1-a"
}

# Documentation: https://www.terraform.io/docs/language/values/variables.html
variable "changeme_google_attached_disk_count_number_of_instances" {
  type    = number
  default = 3
}

# Attach disks to instances
# Documentation: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_attached_disk
resource "google_compute_attached_disk" "changeme_count_attached_disk" {
  # Documentation: https://www.terraform.io/docs/language/meta-arguments/count.html
  count    = var.changeme_google_attached_disk_count_number_of_instances
  disk     = google_compute_disk.changeme_count_attached_disk_disk[count.index].id
  instance = google_compute_instance.changeme_count_attached_disk_instance[count.index].id
}

# Compute Instances
# Documentation: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
resource "google_compute_instance" "changeme_count_attached_disk_instance" {
  name         = "changeme-count-attached-disk-instance-${count.index}"
  count        = var.changeme_google_attached_disk_count_number_of_instances
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    # Explanation: A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }
}

# Persistent disks
# Documentation: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_disk
resource "google_compute_disk" "changeme_count_attached_disk_disk" {
  name                      = "changeme-count-attached-disk-disk-${count.index}"
  count                     = var.changeme_google_attached_disk_count_number_of_instances
  type                      = "pd-ssd"
  zone                      = "us-central1-a"
  size                      = 4
  physical_block_size_bytes = 4096
}
