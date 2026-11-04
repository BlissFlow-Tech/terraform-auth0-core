resource "auth0_client" "this" {
  for_each = var.client_applications != null ? var.client_applications : {}

  name            = each.value.name == null ? each.key : each.value.name
  description     = each.value.description
  app_type        = each.value.app_type
  logo_uri        = each.value.logo_uri
  is_first_party  = each.value.is_first_party
  oidc_conformant = each.value.oidc_conformant

  callbacks           = each.value.callbacks
  allowed_origins     = each.value.allowed_origins
  allowed_logout_urls = each.value.allowed_logout_urls
  web_origins         = each.value.web_origins
  client_aliases      = each.value.client_aliases
  allowed_clients     = each.value.allowed_clients

  grant_types                   = each.value.grant_types
  client_metadata               = each.value.client_metadata
  initiate_login_uri            = each.value.initiate_login_uri
  organization_usage            = each.value.organization_usage
  organization_require_behavior = each.value.organization_require_behavior

  cross_origin_auth = each.value.cross_origin_auth
  cross_origin_loc  = each.value.cross_origin_loc

  custom_login_page_on = each.value.custom_login_page_on
  custom_login_page    = each.value.custom_login_page

  require_pushed_authorization_requests = each.value.require_pushed_authorization_requests

  dynamic "jwt_configuration" {
    for_each = each.value.jwt_configuration != null ? [each.value.jwt_configuration] : []
    content {
      alg                 = jwt_configuration.value.alg
      lifetime_in_seconds = jwt_configuration.value.lifetime_in_seconds
      scopes              = jwt_configuration.value.scopes
      secret_encoded      = jwt_configuration.value.secret_encoded
    }
  }

  dynamic "refresh_token" {
    for_each = each.value.refresh_token != null ? [each.value.refresh_token] : []
    content {
      rotation_type                = refresh_token.value.rotation_type
      expiration_type              = refresh_token.value.expiration_type
      leeway                       = refresh_token.value.leeway
      token_lifetime               = refresh_token.value.token_lifetime
      infinite_token_lifetime      = refresh_token.value.infinite_token_lifetime
      idle_token_lifetime          = refresh_token.value.idle_token_lifetime
      infinite_idle_token_lifetime = refresh_token.value.infinite_idle_token_lifetime
    }
  }

  dynamic "addons" {
    for_each = each.value.addons != null ? [each.value.addons] : []
    content {
      dynamic "samlp" {
        for_each = addons.value.samlp != null ? [addons.value.samlp] : []
        content {
          audience                           = samlp.value.audience
          issuer                             = samlp.value.issuer
          mappings                           = samlp.value.mappings
          create_upn_claim                   = samlp.value.create_upn_claim
          passthrough_claims_with_no_mapping = samlp.value.passthrough_claims_with_no_mapping
          map_unknown_claims_as_is           = samlp.value.map_unknown_claims_as_is
        }
      }
    }
  }

  dynamic "mobile" {
    for_each = each.value.mobile != null ? [each.value.mobile] : []
    content {
      android {
        app_package_name         = mobile.value.android.app_package_name
        sha256_cert_fingerprints = mobile.value.android.sha256_cert_fingerprints
      }
      ios {
        app_bundle_identifier = mobile.value.ios.app_bundle_identifier
        team_id               = mobile.value.ios.team_id
      }
    }
  }
  dynamic "native_social_login" {
    for_each = each.value.native_social_login != null ? [each.value.native_social_login] : []
    content {
      dynamic "apple" {
        for_each = native_social_login.value.apple != null ? [native_social_login.value.apple] : []
        content {
          enabled = native_social_login.value.apple.enabled
        }
      }
      dynamic "facebook" {
        for_each = native_social_login.value.facebook != null ? [native_social_login.value.facebook] : []
        content {
          enabled = native_social_login.value.facebook.enabled
        }
      }
      dynamic "google" {
        for_each = native_social_login.value.google != null ? [native_social_login.value.google] : []
        content {
          enabled = native_social_login.value.google.enabled
        }
      }
    }
  }

  dynamic "oidc_logout" {
    for_each = each.value.oidc_logout != null ? [each.value.oidc_logout] : []
    content {
      backchannel_logout_urls = oidc_logout.value.backchannel_logout_urls
      backchannel_logout_initiators {
        mode                = oidc_logout.backchannel_logout_initiators.mode
        selected_initiators = oidc_logout.backchannel_logout_initiators.selected_initiators
      }
    }
  }

  dynamic "default_organization" {
    for_each = each.value.default_organization != null ? [each.value.default_organization] : []
    content {
      disable         = default_organization.value.disable
      organization_id = default_organization.value.organization_id
      flows           = default_organization.value.flows
    }
  }

  dynamic "token_quota" {
    for_each = each.value.token_quota != null ? [each.value.token_quota] : []
    content {
      client_credentials {
        enforce  = token_quota.value.client_credentials.enforce
        per_day  = token_quota.value.client_credentials.per_day
        per_hour = token_quota.value.client_credentials.per_hour
      }
    }
  }

  dynamic "token_exchange" {
    for_each = each.value.token_exchange != null ? [each.value.token_exchange] : []
    content {
      allow_any_profile_of_type = token_exchange.value.allow_any_profile_of_type
    }
  }

  dynamic "session_transfer" {
    for_each = each.value.session_transfer != null ? [each.value.session_transfer] : []
    content {
      allow_refresh_token               = session_transfer.value.allow_refresh_token
      enforce_cascade_revocation        = session_transfer.value.enforce_cascade_revocation
      enforce_device_binding            = session_transfer.value.enforce_device_binding
      enforce_online_refresh_tokens     = session_transfer.value.enforce_online_refresh_tokens
      can_create_session_transfer_token = session_transfer.value.can_create_session_transfer_token
      allowed_authentication_methods    = session_transfer.value.allowed_authentication_methods
    }
  }
}

resource "auth0_action" "this" {
  for_each = nonsensitive(try(toset(keys(var.actions)), toset([])))
  deploy   = var.actions[each.key].deploy
  name     = var.actions[each.key].name == null ? each.key : var.actions[each.key].name
  code     = var.actions[each.key].code
  runtime  = var.actions[each.key].runtime
  dynamic "secrets" {
    for_each = nonsensitive(try(toset(keys(var.actions[each.key].secrets)), toset([])))
    content {
      name  = secrets.value
      value = var.actions[each.key].secrets[secrets.value]
    }
  }
  dynamic "supported_triggers" {
    for_each = [
      var.actions[each.key].supported_triggers != null ? var.actions[each.key].supported_triggers : local.default_trigger
    ]
    content {
      id      = supported_triggers.value.id
      version = supported_triggers.value.version
    }
  }
}

resource "auth0_trigger_actions" "this" {
  for_each = var.trigger_actions != null ? var.trigger_actions : {}
  trigger  = each.key
  dynamic "actions" {
    for_each = [for a in each.value : a if contains(keys(auth0_action.this), a)]
    content {
      display_name = auth0_action.this[actions.value].name
      id           = auth0_action.this[actions.value].id
    }
  }
}

resource "auth0_resource_server" "this" {
  for_each                                        = var.resource_servers != null ? var.resource_servers : {}
  name                                            = each.value.name == null ? each.key : each.value.name
  identifier                                      = each.value.identifier
  signing_alg                                     = each.value.signing_alg
  allow_offline_access                            = each.value.allow_offline_access
  token_dialect                                   = each.value.token_dialect
  skip_consent_for_verifiable_first_party_clients = each.value.skip_consent_for_verifiable_first_party_clients
  consent_policy                                  = each.value.consent_policy
  enforce_policies                                = each.value.enforce_policies
  signing_secret                                  = each.value.signing_secret
  token_lifetime                                  = each.value.token_lifetime
  token_lifetime_for_web                          = each.value.token_lifetime_for_web
  verification_location                           = each.value.verification_location

  dynamic "authorization_details" {
    for_each = each.value.authorization_details != null ? [each.value.authorization_details] : []
    content {
      disable = authorization_details.value.disable
      type    = authorization_details.value.type
    }
  }

  dynamic "proof_of_possession" {
    for_each = each.value.proof_of_possession != null ? [each.value.proof_of_possession] : []
    content {
      required_for = proof_of_possession.value.required_for
      disable      = proof_of_possession.value.disable
      mechanism    = proof_of_possession.value.mechanism
      required     = proof_of_possession.value.required
    }
  }

  dynamic "subject_type_authorization" {
    for_each = each.value.subject_type_authorization != null ? [each.value.subject_type_authorization] : []
    content {
      client {
        policy = subject_type_authorization.value.client.policy
      }
      user {
        policy = subject_type_authorization.value.user.policy
      }
    }
  }

  dynamic "token_encryption" {
    for_each = each.value.token_encryption != null ? [each.value.token_encryption] : []
    content {
      disable = token_encryption.value.disable
      format  = token_encryption.value.format

      dynamic "encryption_key" {
        for_each = token_encryption.value.encryption_key != null ? [token_encryption.value.encryption_key] : []
        content {
          name      = encryption_key.value.name
          algorithm = encryption_key.value.algorithm
          pem       = encryption_key.value.pem
          kid       = encryption_key.value.kid
        }
      }
    }
  }
}

resource "auth0_resource_server_scopes" "this" {
  for_each                   = var.resource_servers != null ? var.resource_servers : {}
  resource_server_identifier = auth0_resource_server.this[each.key].identifier
  dynamic "scopes" {
    for_each = each.value.scopes != null ? each.value.scopes : []
    content {
      name        = scopes.value.name
      description = scopes.value.description
    }
  }
}

resource "auth0_client_grant" "this" {
  for_each                    = var.client_grants != null ? var.client_grants : {}
  client_id                   = each.value.client_id == null ? auth0_client.this[each.key].id : each.value.client_id
  audience                    = each.value.audience
  scopes                      = each.value.scopes
  allow_all_scopes            = each.value.allow_all_scopes
  allow_any_organization      = each.value.allow_any_organization
  authorization_details_types = each.value.authorization_details_types
  organization_usage          = each.value.organization_usage
  subject_type                = each.value.subject_type
}

resource "auth0_user" "this" {
  for_each             = var.users != null ? var.users : {}
  connection_name      = each.value.connection_name
  user_id              = each.value.user_id
  username             = each.value.username
  name                 = each.value.name == null ? each.key : each.value.name
  family_name          = each.value.family_name
  given_name           = each.value.given_name
  phone_number         = each.value.phone_number
  phone_verified       = each.value.phone_verified
  nickname             = each.value.nickname
  email                = each.value.email
  email_verified       = each.value.email_verified
  verify_email         = each.value.verify_email
  password             = each.value.password == null ? random_password.this[each.key].result : each.value.password
  picture              = each.value.picture
  app_metadata         = each.value.app_metadata
  user_metadata        = each.value.user_metadata
  custom_domain_header = each.value.custom_domain_header
  blocked              = each.value.blocked
}

resource "random_password" "this" {
  for_each         = var.users != null ? var.users : {}
  length           = each.value.random_password_length
  special          = true
  override_special = "!_-.~"
}

resource "auth0_connection" "this" {
  for_each             = var.client_application_connections != null ? var.client_application_connections : {}
  name                 = each.value.name == null ? each.key : each.value.name
  strategy             = each.value.strategy
  display_name         = each.value.display_name
  is_domain_connection = each.value.is_domain_connection
  show_as_button       = each.value.show_as_button
  metadata             = each.value.metadata
  realms               = each.value.realms

  dynamic "connected_accounts" {
    for_each = each.value.connected_accounts != null ? each.value.connected_accounts : []
    content {
      active = connected_accounts.value.active
    }
  }
  dynamic "authentication" {
    for_each = each.value.authentication != null ? each.value.authentication : []
    content {
      active = authentication.value.active
    }
  }

  dynamic "options" {
    for_each = each.value.options
    content {
      client_id                = options.value.client_id
      client_secret            = options.value.client_secret
      allowed_audiences        = options.value.allowed_audiences
      scopes                   = options.value.scopes
      set_user_root_attributes = options.value.set_user_root_attributes
      non_persistent_attrs     = options.value.non_persistent_attrs
      access_token_url         = options.value.access_token_url
      adfs_server              = options.value.adfs_server
      api_enable_users         = options.value.api_enable_users

      dynamic "attribute_map" {
        for_each = options.value.attribute_map
        content {
          mapping_mode   = attribute_map.value.mapping_mode
          userinfo_scope = attribute_map.value.userinfo_scope
          attributes     = attribute_map.value.attributes
        }
      }
    }
  }
}

resource "auth0_connection_client" "this" {
  for_each = {
    for pair in flatten([
      for conn_key, conn_val in var.client_application_connections : [
        for client_key in(conn_val.enabled_clients != null ? conn_val.enabled_clients : []) : {
          conn_key   = conn_key
          client_key = client_key
        }
      ]
    ]) : "${pair.conn_key}-${pair.client_key}" => pair
  }
  connection_id = auth0_connection.this[each.value.conn_key].id
  client_id     = auth0_client.this[each.value.client_key].id
}
resource "auth0_organization" "this" {
  for_each     = var.organizations != null ? var.organizations : {}
  name         = each.value.name == null ? each.key : each.value.name
  display_name = each.value.display_name
  metadata     = each.value.metadata

  dynamic "branding" {
    for_each = each.value.branding != null ? [each.value.branding] : []
    content {
      logo_url = branding.value.logo_url
      colors   = branding.value.colors
    }
  }
}

resource "auth0_organization_connection" "this" {
  for_each = {
    for pair in flatten([
      for org_key, org_val in(var.organizations != null ? var.organizations : {}) : [
        for conn_key, conn_val in org_val.connections : {
          org_key    = org_key
          conn_key   = conn_key
          connection = conn_val
        }
      ]
    ]) : "${pair.org_key}-${pair.conn_key}" => pair
  }
  organization_id            = auth0_organization.this[each.value.org_key].id
  connection_id              = each.value.connection.connection_id == null ? auth0_connection.this[each.value.conn_key].id : each.value.connection.connection_id
  assign_membership_on_login = each.value.connection.assign_membership_on_login
  is_signup_enabled          = each.value.connection.is_signup_enabled
  show_as_button             = each.value.connection.show_as_button
}

resource "auth0_organization_member" "this" {
  for_each = {
    for pair in flatten([
      for org_key, org_val in(var.organizations != null ? var.organizations : {}) : [
        for user_key in org_val.members : {
          org_key  = org_key
          user_key = user_key
        }
      ]
    ]) : "${pair.org_key}-${pair.user_key}" => pair
  }
  organization_id = auth0_organization.this[each.value.org_key].id
  user_id         = auth0_user.this[each.value.user_key].id
}

resource "auth0_role" "this" {
  for_each = var.roles != null ? var.roles : {}

  name        = each.value.name == null ? each.key : each.value.name
  description = each.value.description
}
