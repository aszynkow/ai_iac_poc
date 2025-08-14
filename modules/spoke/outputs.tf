output "vcn_id" {
  value = oci_core_vcn.spoke-a-vcn.id
}

output "subnet1_id" {
  value = oci_core_subnet.spoke-a-subnet[1].id
}

output "subnet2_id" {
  value = oci_core_subnet.spoke-a-subnet[2].id
}
