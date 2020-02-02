variable "project_name" {
  type        = string
  description = "The name of the project to instantiate the instance at. Make sure this matches the project ID on GCP"
}

variable "region_name" {
  type        = string
  description = "The region that this terraform configuration will instantiate at."
  default     = "us-west1"
}

variable "zone_name" {
  type        = string
  description = "the zone that this terraform configuration will instatiate at."
  default     = "us-west1-a"
}

variable "machine_type" {
  type        = string
  description = "The machine type that this instance will be"
  default     = "n1-standard-8"
}

variable "image_name" {
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-1804-lts"
  description = "The image type that the instance runs"
}

variable "image_size" {
  type        = string
  description = "The disk size the image uses"
  default     = "100"
}

variable "script_path" {
  type        = string
  description = "Where is the path to the script locally on the machine"
}

variable "public_key_path" {
  type        = string
  description = "The path to the public ssh key used to connect to the instance"
}

variable "private_key_path" {
  type        = string
  description = "The path to the private key used to connect to the instance"
}

variable "service_key_path" {
  type        = string
  description = "The path to the account service key from GCP"
}

variable "username" {
  type        = string
  description = "The name of the user that will be used to remote exec the script"
}

variable "db_url" {
  type = string
  description = "Optional URL of a stored backup db. Supplying this will download the db and sync from there instead of the beginning"
}

