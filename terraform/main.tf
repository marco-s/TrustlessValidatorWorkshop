// Configure the Google Cloud Provider
provider "google" {
  credentials = file(var.service_key_path)
  project     = var.project_name
  region      = var.region_name
  zone        = var.zone_name
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 8
}

// Creates a static public IP address for our google compute instance to utilize
resource "google_compute_address" "static" {
  name = "ipv4-address"
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "default" {
  name         = "kusama-${random_id.instance_id.hex}"
  machine_type = var.machine_type
  zone         = var.zone_name

  boot_disk {
    initialize_params {
      image = var.image_name
      size  = var.image_size
    }
  }

  metadata = {
    ssh-keys = "${var.username}:${file(var.public_key_path)}"
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external IP address
      nat_ip = google_compute_address.static.address
    }
  }

  // provisioner "remote-exec" {
  //   script = var.script_path

  //   connection {
  //     type        = "ssh"
  //     host        = google_compute_address.static.address
  //     user        = var.username
  //     private_key = file(var.private_key_path)
  //   }
  // }

  provisioner "file" {
    source = var.script_path
    destination = "/tmp/setup.sh"


    connection {
      type        = "ssh"
      host        = google_compute_address.static.address
      user        = var.username
      private_key = file(var.private_key_path)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "/tmp/setup.sh ${var.db_url}"
    ]
        
    connection {
      type        = "ssh"
      host        = google_compute_address.static.address
      user        = var.username
      private_key = file(var.private_key_path)
    }
  }

}

// A variable for extracting the external ip of the instance
output "ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
  sensitive = true
}
