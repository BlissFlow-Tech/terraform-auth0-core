output "client_applications" {
  description = "Client applications created, keyed like the client_applications input"
  value = {
    for k, v in auth0_client.this :
    k => {
      id                            = v.id
      client_id                     = v.client_id
      name                          = v.name
      description                   = v.description
      app_type                      = v.app_type
      is_first_party                = v.is_first_party
      oidc_conformant               = v.oidc_conformant
      callbacks                     = v.callbacks
      allowed_origins               = v.allowed_origins
      allowed_logout_urls           = v.allowed_logout_urls
      web_origins                   = v.web_origins
      grant_types                   = v.grant_types
      client_metadata               = v.client_metadata
      initiate_login_uri            = v.initiate_login_uri
      organization_usage            = v.organization_usage
      organization_require_behavior = v.organization_require_behavior
      jwt_configuration             = v.jwt_configuration
      refresh_token                 = v.refresh_token
      addons                        = v.addons
      mobile                        = v.mobile
      native_social_login           = v.native_social_login
      oidc_logout                   = v.oidc_logout
      default_organization          = v.default_organization
      token_quota                   = v.token_quota
      token_exchange                = v.token_exchange
      session_transfer              = v.session_transfer
    }
  }
}

output "client_secrets" {
  description = "Client secrets of the created client applications, keyed like the client_applications input"
  value = {
    for k, v in data.auth0_client.this :
    k => {
      client_secret = v.client_secret
    }
  }
  sensitive = true
}

output "actions" {
  description = "Map of action keys to their Auth0 IDs"
  value = {
    for k, v in auth0_action.this :
    k => {
      id                 = v.id
      name               = v.name
      supported_triggers = v.supported_triggers
      deploy             = v.deploy
      modules            = v.modules
      code               = v.code
      dependencies       = v.dependencies
      runtime            = v.runtime
      version_id         = v.version_id
    }
  }
}

output "action_triggers" {
  description = "The IDs of the trigger-to-action bindings"
  value = {
    for k, v in auth0_trigger_actions.this : k => {
      id      = v.id
      actions = v.actions
      trigger = v.trigger
    }
  }
}

output "api_identifiers" {
  description = "The 'Audience' identifiers for your regional APIs"
  value = {
    for k, v in auth0_resource_server.this : k => {
      id                                              = v.id
      name                                            = v.name
      subject_type_authorization                      = v.subject_type_authorization
      allow_offline_access                            = v.allow_offline_access
      client_id                                       = v.client_id
      authorization_details                           = v.authorization_details
      consent_policy                                  = v.consent_policy
      enforce_policies                                = v.enforce_policies
      identifier                                      = v.identifier
      is_system                                       = v.is_system
      proof_of_possession                             = v.proof_of_possession
      signing_alg                                     = v.signing_alg
      signing_secret                                  = v.signing_secret
      skip_consent_for_verifiable_first_party_clients = v.skip_consent_for_verifiable_first_party_clients
      token_encryption                                = v.token_encryption
      token_dialect                                   = v.token_dialect
      token_lifetime                                  = v.token_lifetime
      token_lifetime_for_web                          = v.token_lifetime_for_web
      verification_location                           = v.verification_location
    }
  }
}

output "api_scopes_list" {
  description = "List of scopes defined for each API key"
  value = {
    for k, v in auth0_resource_server_scopes.this : k => {
      id                         = v.id
      resource_server_identifier = v.resource_server_identifier
      scops                      = v.scopes
    }
  }
}

output "client_grant_details" {
  description = "Detailed mapping of which client is granted which scopes on which audience"
  value = { for k, v in auth0_client_grant.this : k => {
    id                          = v.id
    client_id                   = v.client_id
    audience                    = v.audience
    scopes                      = v.scopes
    is_system                   = v.is_system
    subject_type                = v.subject_type
    organization_usage          = v.organization_usage
    allow_all_scopes            = v.allow_all_scopes
    allow_any_organization      = v.allow_any_organization
    authorization_details_types = v.authorization_details_types
    }
  }
}

output "users" {
  description = "Users created, keyed like the users input"
  value = {
    for k, v in auth0_user.this :
    k => {
      id                   = v.id
      user_id              = v.user_id
      username             = v.username
      password             = v.password
      name                 = v.name
      family_name          = v.family_name
      given_name           = v.given_name
      nickname             = v.nickname
      phone_number         = v.phone_number
      phone_verified       = v.phone_verified
      email                = v.email
      email_verified       = v.email_verified
      verify_email         = v.verify_email
      app_metadata         = v.app_metadata
      user_metadata        = v.user_metadata
      blocked              = v.blocked
      custom_domain_header = v.custom_domain_header
      picture              = v.picture
      connection_name      = v.connection_name
    }
  }
}

output "client_connections" {
  description = "Client applications enabled on each connection, keyed <connection key>-<client key>"
  value = { for k, v in auth0_connection_client.this : k => {
    id            = v.id
    client_id     = v.client_id
    name          = v.name
    connection_id = v.connection_id
    strategy      = v.strategy
    }
  }
}

output "organizations" {
  description = "Organizations created, keyed like the organizations input"
  value = {
    for k, v in auth0_organization.this :
    k => {
      id           = v.id
      name         = v.name
      display_name = v.display_name
      metadata     = v.metadata
    }
  }
}

output "organization_connections" {
  description = "Connections enabled on each organization, keyed <organization key>-<connection key>"
  value = { for k, v in auth0_organization_connection.this : k => {
    id                         = v.id
    organization_id            = v.organization_id
    connection_id              = v.connection_id
    name                       = v.name
    strategy                   = v.strategy
    assign_membership_on_login = v.assign_membership_on_login
    is_signup_enabled          = v.is_signup_enabled
    show_as_button             = v.show_as_button
    }
  }
}

output "organization_members" {
  description = "Users added to each organization, keyed <organization key>-<user key>"
  value = { for k, v in auth0_organization_member.this : k => {
    id              = v.id
    organization_id = v.organization_id
    user_id         = v.user_id
    }
  }
}

output "connections" {
  description = "Connections created, keyed like the client_application_connections input"
  value = { for k, v in auth0_connection.this : k => {
    id                   = v.id
    name                 = v.name
    display_name         = v.display_name
    strategy             = v.strategy
    is_domain_connection = v.is_domain_connection
    show_as_button       = v.show_as_button
    realms               = v.realms
    metadata             = v.metadata
    }
  }
}

output "roles" {
  description = "Auth0 roles created, keyed by the input identifier"
  value = { for k, v in auth0_role.this : k => {
    id          = v.id
    name        = v.name
    description = v.description
    }
  }
}
