resource oci_load_balancer_load_balancer publb {
  compartment_id = local.poc_compartment_id
  display_name = local.lb_name
  ip_mode    = "IPV4"
  is_private = "false"
  network_security_group_ids = [
  ]
  #reserved_ips = <<Optional value not found in discovery>>
  shape = var.lb_shape#"flexible"
  shape_details {
    maximum_bandwidth_in_mbps = var.maximum_bandwidth_in_mbps#"10"
    minimum_bandwidth_in_mbps = var.minimum_bandwidth_in_mbps#"10"
  }
  subnet_ids = [
    local.subnet1_id,
  ]
}

resource oci_load_balancer_backend_set publbbs01 {
  health_checker {
    interval_ms         = "10000"
    port                = "8000"
    protocol            = "HTTP"
    response_body_regex = ""
    retries             = "3"
    return_code         = "200"
    timeout_in_millis   = "3000"
    url_path            = var.https_health_check_path
   
  }
  load_balancer_id = oci_load_balancer_load_balancer.publb.id
  name             = local.bcknd1_name
  policy           = "ROUND_ROBIN"
}

resource oci_load_balancer_listener blsnr01 {
  connection_configuration {
    backend_tcp_proxy_protocol_version = "0"
    idle_timeout_in_seconds            = "60"
  }
  default_backend_set_name = oci_load_balancer_backend_set.publbbs01.name
  hostname_names = [
  ]
  load_balancer_id = oci_load_balancer_load_balancer.publb.id
  name             = local.lstn1_name
  #path_route_set_name = <<Optional >>
  port     = "8000"
  protocol = "HTTP"
  #routing_policy_name = <<Optional >>
  rule_set_names = [
  ]
   #ssl_configuration {
   # }

}

resource oci_load_balancer_listener blsnr02 {
  count = local.https_count
  connection_configuration {
    backend_tcp_proxy_protocol_version = "0"
    idle_timeout_in_seconds            = "60"
  }
  default_backend_set_name = oci_load_balancer_backend_set.publbbs01.name
  hostname_names = [
  ]
  load_balancer_id = oci_load_balancer_load_balancer.publb.id
  name             = local.lstn1_name
  #path_route_set_name = <<Optional >>
  port     = "443"
  protocol = "HTTP"
  #routing_policy_name = <<Optional >>
  rule_set_names = [
  ]
   ssl_configuration {
        #Optional
        #certificate_name = oci_load_balancer_certificate.test_certificate.name
        certificate_ids = [var.listener_ssl_configuration_certificate_id]
        /*cipher_suite_name = var.listener_ssl_configuration_cipher_suite_name
        protocols = var.listener_ssl_configuration_protocols
        server_order_preference = var.listener_ssl_configuration_server_order_preference
        trusted_certificate_authority_ids = var.listener_ssl_configuration_trusted_certificate_authority_ids
        verify_depth = var.listener_ssl_configuration_verify_depth
        verify_peer_certificate = var.listener_ssl_configuration_verify_peer_certificate
    */
    }

}

resource oci_load_balancer_backend_set publbbs02 {
  count = local.https_count
  health_checker {
    interval_ms         = "10000"
    port                = "443"
    protocol            = "HTTP"
    response_body_regex = ""
    retries             = "3"
    return_code         = "200"
    timeout_in_millis   = "3000"
    url_path            = var.https_health_check_path#"/wpas/Login.html"
  }
  load_balancer_id = oci_load_balancer_load_balancer.publb.id
  name             = local.bcknd2_name
  policy           = "ROUND_ROBIN"
}

resource oci_load_balancer_backend web_pub {
  backendset_name  = oci_load_balancer_backend_set.publbbs01.name
  backup           = "false"
  drain            = "false"
  ip_address       = oci_core_instance.llm_instance[0].private_ip
  load_balancer_id = oci_load_balancer_load_balancer.publb.id
  offline          = "false"
  port             = "8000"
  weight           = "1"
}