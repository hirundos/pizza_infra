output "pz_vpc" {
  value = google_compute_network.pz_vpc
}

output "vpc_connection" {
  value = google_service_networking_connection.private_vpc_connection
}

output "pz_snet" {
    value = google_compute_subnetwork.main_subnet
}

