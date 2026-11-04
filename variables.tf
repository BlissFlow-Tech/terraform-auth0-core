variable "client_applications" {
  description = "Client applications to create, keyed by an identifier that is the default application name"
  type = map(object({
    name        = optional(string)
    description = optional(string)
    app_type    = optional(string)

    logo_uri        = optional(string)
    is_first_party  = optional(bool)
    oidc_conformant = optional(bool)

    callbacks           = optional(list(string))
    allowed_origins     = optional(list(string))
    allowed_logout_urls = optional(list(string))
    web_origins         = optional(list(string))
    client_aliases      = optional(list(string))
    allowed_clients     = optional(list(string))

    grant_types     = optional(list(string))
    client_metadata = optional(map(string))

    initiate_login_uri = optional(string)

    organization_usage            = optional(string)
    organization_require_behavior = optional(string)

    cross_origin_auth = optional(bool)
    cross_origin_loc  = optional(string)

    custom_login_page_on = optional(bool)
    custom_login_page    = optional(string)

    require_pushed_authorization_requests = optional(bool)

    jwt_configuration = optional(object({
      alg                 = optional(string)
      lifetime_in_seconds = optional(number)
      scopes              = optional(map(string))
      secret_encoded      = optional(bool)
    }))

    refresh_token = optional(object({
      rotation_type                = optional(string)
      expiration_type              = optional(string)
      leeway                       = optional(number)
      token_lifetime               = optional(number)
      infinite_token_lifetime      = optional(bool)
      idle_token_lifetime          = optional(number)
      infinite_idle_token_lifetime = optional(bool)
    }))

    addons = optional(object({
      samlp = optional(object({
        audience                           = optional(string)
        issuer                             = optional(string)
        mappings                           = optional(map(string))
        create_upn_claim                   = optional(bool)
        passthrough_claims_with_no_mapping = optional(bool)
        map_unknown_claims_as_is           = optional(bool)
      }))
    }))

    mobile = optional(object({
      android = optional(object({
        app_package_name         = optional(string)
        sha256_cert_fingerprints = optional(list(string))
      }))
      ios = optional(object({
        app_bundle_identifier = optional(string)
        team_id               = optional(string)
      }))
    }))

    native_social_login = optional(object({
      apple = optional(object({
        enabled = optional(bool, false)
      }))
      facebook = optional(object({
        enabled = optional(bool, false)
      }))
      google = optional(object({
        enabled = optional(bool, false)
      }))
    }))

    oidc_logout = optional(object({
      backchannel_logout_urls = optional(list(string))
      backchannel_logout_initiators = object({
        mode                = optional(string)
        selected_initiators = optional(list(string))
      })
    }))

    default_organization = optional(object({
      disable         = optional(bool)
      organization_id = optional(string)
      flows           = optional(list(string))
    }))

    token_quota = optional(object({
      client_credentials = optional(object({
        enforce  = optional(bool)
        per_day  = optional(number)
        per_hour = optional(number)
      }))
    }))

    token_exchange = optional(object({
      allow_any_profile_of_type = optional(list(string))
    }))

    session_transfer = optional(object({
      allow_refresh_token               = optional(bool)
      enforce_cascade_revocation        = optional(bool)
      enforce_device_binding            = optional(string)
      enforce_online_refresh_tokens     = optional(bool)
      can_create_session_transfer_token = optional(bool)
      allowed_authentication_methods    = optional(list(string))
    }))
  }))
  default = null
}

variable "actions" {
  description = "Actions to create and deploy, keyed by an identifier that is the default action name. Without supported_triggers an action targets post-login v3."
  type = map(object({
    deploy  = optional(bool, true)
    name    = optional(string)
    code    = optional(string)
    runtime = optional(string, "node22")
    secrets = optional(map(string))
    supported_triggers = optional(object({
      id      = optional(string, "post-login")
      version = optional(string, "v3")
    }))
  }))
  default = null
}

variable "trigger_actions" {
  description = "Action bindings per trigger: a trigger id such as post-login mapped to the action keys to run, in order"
  type        = map(list(string))
  default     = null
}

variable "resource_servers" {
  description = "APIs (resource servers) to create with their scopes, keyed by an identifier that is the default API name"
  type = map(object({
    name                                            = optional(string)
    identifier                                      = string
    signing_alg                                     = optional(string, "RS256")
    allow_offline_access                            = optional(bool, false)
    token_dialect                                   = optional(string)
    skip_consent_for_verifiable_first_party_clients = optional(bool, false)
    consent_policy                                  = optional(string)
    enforce_policies                                = optional(bool)
    signing_secret                                  = optional(string)
    token_lifetime                                  = optional(number)
    token_lifetime_for_web                          = optional(number)
    verification_location                           = optional(string)
    authorization_details = optional(object({
      disable = optional(bool)
      type    = optional(string)
    }))
    proof_of_possession = optional(object({
      required_for = optional(string)
      disable      = optional(bool)
      mechanism    = optional(string)
      required     = optional(bool)
    }))
    subject_type_authorization = optional(object({
      enabled = optional(bool)
      client = optional(object({
        policy = optional(string)
      }))
      user = optional(object({
        policy = optional(string)
      }))
    }))
    token_encryption = optional(object({
      disable = optional(bool)
      format  = optional(string)
      encryption_key = optional(object({
        name      = optional(string)
        algorithm = optional(string)
        pem       = optional(string)
        kid       = optional(string)
      }))
    }))
    resource_server_identifier = optional(string)
    scopes = optional(list(object({
      name        = optional(string)
      description = optional(string)
    })))
  }))
  default = null
}

variable "client_grants" {
  description = "Scope grants on an API audience for the client in client_id, or, when client_id is null, for the client_applications client with the same key"
  type = map(object({
    client_id                   = optional(string)
    audience                    = optional(string)
    scopes                      = optional(list(string))
    allow_all_scopes            = optional(bool)
    allow_any_organization      = optional(bool)
    authorization_details_types = optional(list(string))
    organization_usage          = optional(string)
    subject_type                = optional(string)
  }))
  default = null
}

variable "users" {
  description = "Users to create, keyed by an identifier that is the default name. A random password is generated when password is not set."
  type = map(object({
    connection_name        = optional(string, "Username-Password-Authentication")
    user_id                = optional(string)
    username               = optional(string)
    name                   = optional(string)
    family_name            = optional(string)
    given_name             = optional(string)
    phone_number           = optional(string)
    phone_verified         = optional(string)
    nickname               = optional(string)
    email                  = optional(string)
    email_verified         = optional(string)
    verify_email           = optional(bool)
    password               = optional(string)
    picture                = optional(string)
    app_metadata           = optional(string)
    user_metadata          = optional(string)
    custom_domain_header   = optional(string)
    blocked                = optional(bool)
    random_password_length = optional(number, 16)
  }))
  default = null
}

variable "client_application_connections" {
  description = "Connections to create, keyed by an identifier that is the default connection name. enabled_clients lists client_applications keys."
  type = map(object({
    name                 = optional(string)
    strategy             = string
    display_name         = optional(string)
    is_domain_connection = optional(bool, false)
    show_as_button       = optional(bool)
    metadata             = optional(map(string))
    realms               = optional(list(string))

    connected_accounts = optional(list(object({
      active = bool
    })))

    authentication = optional(list(object({
      active = bool
    })))
    enabled_clients = optional(list(string))
    options = optional(list(object({
      client_id                = optional(string)
      client_secret            = optional(string)
      allowed_audiences        = optional(list(string))
      scopes                   = optional(list(string))
      set_user_root_attributes = optional(string)
      non_persistent_attrs     = optional(list(string))
      access_token_url         = optional(string)
      adfs_server              = optional(string)
      api_enable_users         = optional(bool)

      attribute_map = optional(list(object({
        mapping_mode   = optional(string, "basic_profile")
        userinfo_scope = optional(string)
        attributes     = optional(string)
      })), [])
    })))
  }))
  default = {}
}
variable "organizations" {
  description = "Auth0 organizations. Each connections entry keys either an in-module connection or, when connection_id is set, an externally managed one. Each members entry keys an in-module user."
  type = map(object({
    name         = optional(string)
    display_name = optional(string)
    metadata     = optional(map(string))
    branding = optional(object({
      logo_url = optional(string)
      colors   = optional(map(string))
    }))
    connections = optional(map(object({
      connection_id              = optional(string)
      assign_membership_on_login = optional(bool, false)
      is_signup_enabled          = optional(bool)
      show_as_button             = optional(bool)
    })), {})
    members = optional(list(string), [])
  }))
  default = null

  validation {
    condition = var.organizations == null ? true : alltrue([
      for org in values(var.organizations) : alltrue([
        for conn in values(org.connections) :
        conn.is_signup_enabled != true || conn.assign_membership_on_login == true
      ])
    ])
    error_message = "is_signup_enabled requires assign_membership_on_login to be true on the same connection, and is only supported on database connections."
  }
}

variable "roles" {
  description = "Auth0 roles to create. Membership is assigned to people outside terraform, so a role is declared here and its holders are managed in Auth0."
  type = map(object({
    name        = optional(string)
    description = optional(string)
  }))
  default = null
}
