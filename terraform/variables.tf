variable "server_name" {
  description = "Name of the server"
  type        = string
  default     = "hydrogen"
}

variable "server_type" {
  description = "Hetzner server type"
  type        = string
  default     = "cx33"
}

variable "image" {
  description = "OS image to use for the server"
  type        = string
  default     = "debian-13"
}

variable "location" {
  description = "Hetzner datacenter location"
  type        = string
  default     = "fsn1"
}

variable "ssh_key_name" {
  description = "Name of the SSH key uploaded to Hetzner Cloud"
  type        = string
}
