output "server_ipv4" {
  description = "Public IPv4 address"
  value       = hcloud_server.server.ipv4_address
}

output "server_ipv6" {
  description = "Public IPv6 address"
  value       = hcloud_server.server.ipv6_address
}
