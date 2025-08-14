resource oci_waf_web_app_firewall_policy lb_waf_policy {
  actions {
    #body = <<Optional value not found in discovery>>
    #code = <<Optional value not found in discovery>>
    #headers = <<Optional value not found in discovery>>
    name = "Pre-configured Check Action"
    type = "CHECK"
  }
  actions {
    #body = <<Optional value not found in discovery>>
    #code = <<Optional value not found in discovery>>
    #headers = <<Optional value not found in discovery>>
    name = "Pre-configured Allow Action"
    type = "ALLOW"
  }
  actions {
    body {
      #template = <<Optional value not found in discovery>>
      text = "{\"code\":\"401\",\"message\":\"Unauthorized\"}"
      type = "STATIC_TEXT"
    }
    code = "401"
    headers {
      name  = "Content-Type"
      value = "application/json"
    }
    name = "Pre-configured 401 Response Code Action"
    type = "RETURN_HTTP_RESPONSE"
  }
  actions {
    #body = <<Optional value not found in discovery>>
    #code = <<Optional value not found in discovery>>
    #headers = <<Optional value not found in discovery>>
    name = "Allow_AUS"
    type = "ALLOW"
  }
  compartment_id = local.poc_compartment_id
  display_name = local.waf_policy_name
  freeform_tags = {
  }
  request_access_control {
    default_action_name = "Allow_AUS"
    rules {
      action_name        = "Allow_AUS"
      condition          = "i_contains(['AU'], connection.source.geo.countryCode)"
      condition_language = "JMESPATH"
      name               = "allow_aus"
      type               = "ACCESS_CONTROL"
    }
  }
  request_protection {
    #body_inspection_size_limit_exceeded_action_name = <<Optional value not found in discovery>>
    body_inspection_size_limit_in_bytes = "8192"
  }
  request_rate_limiting {
    rules {
      action_name = "Pre-configured Check Action"
      #condition = <<Optional value not found in discovery>>
      condition_language = "JMESPATH"
      configurations {
        action_duration_in_seconds = "0"
        period_in_seconds          = "60"
        requests_limit             = "100"
      }
      name = "100perminute"
      type = "REQUEST_RATE_LIMITING"
    }
  }
  response_access_control {
  }
  system_tags = {
    "orcl-cloud.free-tier-retained" = "false"
  }
}

resource oci_waf_web_app_firewall lb_waf {
  backend_type   = "LOAD_BALANCER"
  compartment_id = local.poc_compartment_id
  display_name = local.waf_name
  freeform_tags = {
  }
  load_balancer_id = oci_load_balancer_load_balancer.publb.id
  system_tags = {
    "orcl-cloud.free-tier-retained" = "false"
  }
  web_app_firewall_policy_id = oci_waf_web_app_firewall_policy.lb_waf_policy.id
}

