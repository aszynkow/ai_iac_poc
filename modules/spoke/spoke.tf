resource "oci_core_vcn" "spoke-a-vcn" {
  cidr_blocks    = [local.spoke_cidr_block]
  dns_label      = local.dns_label
  compartment_id = local.netwrok_compartment
  display_name   = local.vcn_name
}

resource "oci_core_subnet" "spoke-a-subnet" {
  for_each      =  { for sub in local.subnet_variables : sub.id => sub} 
  cidr_block        = cidrsubnet(local.spoke_cidr_block, tonumber(split("/",each.value.cidr_block)[1] - local.base_prefix_length), each.value.netnum)
  display_name      = join (local.separator,[local.environment_name,each.value.display_name])
  dns_label         = join ("",[local.environment_name,each.value.dns_label])
  compartment_id    = local.netwrok_compartment
  vcn_id            = oci_core_vcn.spoke-a-vcn.id
  security_list_ids = [each.value.private_boolean ? oci_core_security_list.private-subnet-security-list.id : oci_core_security_list.public-subnet-security-list.id]
  route_table_id    = each.value.private_boolean ? oci_core_route_table.private_subnet_route_table.id : oci_core_route_table.public_subnet_route_table.id
  dhcp_options_id   = oci_core_vcn.spoke-a-vcn.default_dhcp_options_id
  
  prohibit_public_ip_on_vnic = each.value.private_boolean
}

resource "oci_core_security_list" "private-subnet-security-list" {
  compartment_id    = var.compartment_ocid
  #manage_default_resource_id = oci_core_vcn.spoke-a-vcn.default_security_list_id
  vcn_id = oci_core_vcn.spoke-a-vcn.id
  
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    protocol = "all"
    source = oci_core_vcn.spoke-a-vcn.cidr_block
  }
}

resource "oci_core_security_list" "public-subnet-security-list" {
  compartment_id    = var.compartment_ocid
  #manage_default_resource_id = oci_core_vcn.spoke-a-vcn.default_security_list_id
  vcn_id = oci_core_vcn.spoke-a-vcn.id
  
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  dynamic "ingress_security_rules" { 
    iterator = port
    for_each  =  [ for spoke in local.spoke_variables : {
      minport = spoke.minport
      maxport = spoke.maxport
      source = spoke.source
      protocol = spoke.protocol
      description = spoke.description
    }
    ]
    content {
        #Required
        protocol = port.value.protocol
        #Optional
        source = port.value.source
        description = port.value.description
        tcp_options {
          min = port.value.minport
          max = port.value.maxport
        }
    }
  }
}

resource "oci_core_nat_gateway" "spoke-a-oci-nat-gateway" {
    #Required
    compartment_id = local.netwrok_compartment
    vcn_id = oci_core_vcn.spoke-a-vcn.id
    #Optional
    display_name = local.nat_name
}

resource "oci_core_internet_gateway" "spoke-a-oci-igw-gateway" {
    #Required
    compartment_id = local.netwrok_compartment
    vcn_id = oci_core_vcn.spoke-a-vcn.id
    #Optional
    display_name = local.igw_name
}

##################################################################################
# Create Route Table routes for Spokes in OCI cloud VCN
##################################################################################

resource oci_core_service_gateway "spoke_service_gateway" {
  compartment_id = local.netwrok_compartment
  display_name = local.sgw_name
  services {
    service_id = local.services_id
  }
  vcn_id = oci_core_vcn.spoke-a-vcn.id
}

resource "oci_core_route_table" "private_subnet_route_table" {
    #Required
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_vcn.spoke-a-vcn.id
    route_rules {
        #Required
        network_entity_id = oci_core_nat_gateway.spoke-a-oci-nat-gateway.id
        #Optional
        destination = "0.0.0.0/0"
        
    }

    route_rules {
      #Required
      destination       = local.services_desc
      destination_type  = "SERVICE_CIDR_BLOCK"
      network_entity_id = oci_core_service_gateway.spoke_service_gateway.id
      #Optional
  }
}

resource "oci_core_route_table" "public_subnet_route_table" {
    #Required
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_vcn.spoke-a-vcn.id
    route_rules {
        #Required
        network_entity_id = oci_core_internet_gateway.spoke-a-oci-igw-gateway.id
        #Optional
        destination = "0.0.0.0/0"
        
    }
} 
