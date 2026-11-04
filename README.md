# terraform-auth0-core

Terraform module that manages the core objects of an Auth0 tenant: applications, APIs and scopes, client grants, connections, users, organizations, roles and actions.

## Usage

```hcl
module "auth0" {
  source  = "blissflow-tech/core/auth0"
  version = "~> 1.0"

  client_applications = {
    web = {
      name            = "web"
      app_type        = "regular_web"
      callbacks       = ["https://app.example.com/callback"]
      allowed_origins = ["https://app.example.com"]
      grant_types     = ["authorization_code", "refresh_token"]
    }
    backend = {
      name        = "backend"
      app_type    = "non_interactive"
      grant_types = ["client_credentials"]
    }
  }

  resource_servers = {
    api = {
      identifier = "https://api.example.com"
      scopes = [
        { name = "read:items", description = "Read items" },
      ]
    }
  }

  client_grants = {
    backend = {
      audience = "https://api.example.com"
      scopes   = ["read:items"]
    }
  }

  client_application_connections = {
    users = {
      strategy        = "auth0"
      enabled_clients = ["web"]
    }
  }

  organizations = {
    acme = {
      display_name = "Acme"
      connections  = { users = {} }
    }
  }

  actions = {
    add_claims = {
      code = file("${path.module}/actions/add-claims.js")
    }
  }

  trigger_actions = {
    post-login = ["add_claims"]
  }
}
```

## Notes

* Every map is keyed by an identifier that cross-references the others: `client_grants`, `enabled_clients` and `trigger_actions` refer to `client_applications` and `actions` keys, and organization `connections`/`members` refer to `client_application_connections` and `users` keys. An organization connection with `connection_id` set points at a connection managed elsewhere instead.
* A client application is named after its map key. Its `name` attribute is required but not used yet.
* A `client_grants` entry is keyed by the client application that receives the grant.
* Users without a `password` get a generated one. Passwords in the `users` output and `signing_secret` in the `api_identifiers` output are sensitive, so a root output that forwards either must set `sensitive = true`. State holds them in plain text. Client secrets are exposed through the sensitive `client_secrets` output.
* Role membership is managed outside Terraform; the module only declares the roles.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.5 |
| auth0 | >= 1.41.0 |
| random | >= 3.0, < 4.0 |

## Providers

| Name | Version |
| ---- | ------- |
| auth0 | >= 1.41.0 |
| random | >= 3.0, < 4.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [auth0_action.this](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/action) | resource |
| [auth0_client.this](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/client) | resource |
| [auth0_client_grant.this](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/client_grant) | resource |
| [auth0_connection.this](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/connection) | resource |
| [auth0_connection_client.this](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/connection_client) | resource |
| [auth0_organization.this](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/organization) | resource |
| [auth0_organization_connection.this](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/organization_connection) | resource |
| [auth0_organization_member.this](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/organization_member) | resource |
| [auth0_resource_server.this](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/resource_server) | resource |
| [auth0_resource_server_scopes.this](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/resource_server_scopes) | resource |
| [auth0_role.this](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/role) | resource |
| [auth0_trigger_actions.this](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/trigger_actions) | resource |
| [auth0_user.this](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/user) | resource |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [auth0_client.this](https://registry.terraform.io/providers/auth0/auth0/latest/docs/data-sources/client) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| actions | Actions to create and deploy, keyed by an identifier that is the default action name. Without supported\_triggers an action targets post-login v3. | <pre>map(object({<br/>    deploy  = optional(bool, true)<br/>    name    = optional(string)<br/>    code    = optional(string)<br/>    runtime = optional(string, "node22")<br/>    secrets = optional(map(string))<br/>    supported_triggers = optional(object({<br/>      id      = optional(string, "post-login")<br/>      version = optional(string, "v3")<br/>    }))<br/>  }))</pre> | `null` | no |
| client\_application\_connections | Connections to create, keyed by an identifier that is the default connection name. enabled\_clients lists client\_applications keys. | <pre>map(object({<br/>    name                 = optional(string)<br/>    strategy             = string<br/>    display_name         = optional(string)<br/>    is_domain_connection = optional(bool, false)<br/>    show_as_button       = optional(bool)<br/>    metadata             = optional(map(string))<br/>    realms               = optional(list(string))<br/><br/>    connected_accounts = optional(list(object({<br/>      active = bool<br/>    })))<br/><br/>    authentication = optional(list(object({<br/>      active = bool<br/>    })))<br/>    enabled_clients = optional(list(string))<br/>    options = optional(list(object({<br/>      client_id                = optional(string)<br/>      client_secret            = optional(string)<br/>      allowed_audiences        = optional(list(string))<br/>      scopes                   = optional(list(string))<br/>      set_user_root_attributes = optional(string)<br/>      non_persistent_attrs     = optional(list(string))<br/>      access_token_url         = optional(string)<br/>      adfs_server              = optional(string)<br/>      api_enable_users         = optional(bool)<br/><br/>      attribute_map = optional(list(object({<br/>        mapping_mode   = optional(string, "basic_profile")<br/>        userinfo_scope = optional(string)<br/>        attributes     = optional(string)<br/>      })), [])<br/>    })))<br/>  }))</pre> | `{}` | no |
| client\_applications | Client applications to create, keyed by an identifier that is also used as the application name | <pre>map(object({<br/>    name        = string<br/>    description = optional(string)<br/>    app_type    = optional(string)<br/><br/>    logo_uri        = optional(string)<br/>    is_first_party  = optional(bool)<br/>    oidc_conformant = optional(bool)<br/><br/>    callbacks           = optional(list(string))<br/>    allowed_origins     = optional(list(string))<br/>    allowed_logout_urls = optional(list(string))<br/>    web_origins         = optional(list(string))<br/>    client_aliases      = optional(list(string))<br/>    allowed_clients     = optional(list(string))<br/><br/>    grant_types     = optional(list(string))<br/>    client_metadata = optional(map(string))<br/><br/>    initiate_login_uri = optional(string)<br/><br/>    organization_usage            = optional(string)<br/>    organization_require_behavior = optional(string)<br/><br/>    cross_origin_auth = optional(bool)<br/>    cross_origin_loc  = optional(string)<br/><br/>    custom_login_page_on = optional(bool)<br/>    custom_login_page    = optional(string)<br/><br/>    require_pushed_authorization_requests = optional(bool)<br/><br/>    jwt_configuration = optional(object({<br/>      alg                 = optional(string)<br/>      lifetime_in_seconds = optional(number)<br/>      scopes              = optional(map(string))<br/>      secret_encoded      = optional(bool)<br/>    }))<br/><br/>    refresh_token = optional(object({<br/>      rotation_type                = optional(string)<br/>      expiration_type              = optional(string)<br/>      leeway                       = optional(number)<br/>      token_lifetime               = optional(number)<br/>      infinite_token_lifetime      = optional(bool)<br/>      idle_token_lifetime          = optional(number)<br/>      infinite_idle_token_lifetime = optional(bool)<br/>    }))<br/><br/>    addons = optional(object({<br/>      samlp = optional(object({<br/>        audience                           = optional(string)<br/>        issuer                             = optional(string)<br/>        mappings                           = optional(map(string))<br/>        create_upn_claim                   = optional(bool)<br/>        passthrough_claims_with_no_mapping = optional(bool)<br/>        map_unknown_claims_as_is           = optional(bool)<br/>      }))<br/>    }))<br/><br/>    mobile = optional(object({<br/>      android = optional(object({<br/>        app_package_name         = optional(string)<br/>        sha256_cert_fingerprints = optional(list(string))<br/>      }))<br/>      ios = optional(object({<br/>        app_bundle_identifier = optional(string)<br/>        team_id               = optional(string)<br/>      }))<br/>    }))<br/><br/>    native_social_login = optional(object({<br/>      apple = optional(object({<br/>        enabled = optional(bool, false)<br/>      }))<br/>      facebook = optional(object({<br/>        enabled = optional(bool, false)<br/>      }))<br/>      google = optional(object({<br/>        enabled = optional(bool, false)<br/>      }))<br/>    }))<br/><br/>    oidc_logout = optional(object({<br/>      backchannel_logout_urls = optional(list(string))<br/>      backchannel_logout_initiators = object({<br/>        mode                = optional(string)<br/>        selected_initiators = optional(list(string))<br/>      })<br/>    }))<br/><br/>    default_organization = optional(object({<br/>      disable         = optional(bool)<br/>      organization_id = optional(string)<br/>      flows           = optional(list(string))<br/>    }))<br/><br/>    token_quota = optional(object({<br/>      client_credentials = optional(object({<br/>        enforce  = optional(bool)<br/>        per_day  = optional(number)<br/>        per_hour = optional(number)<br/>      }))<br/>    }))<br/><br/>    token_exchange = optional(object({<br/>      allow_any_profile_of_type = optional(list(string))<br/>    }))<br/><br/>    session_transfer = optional(object({<br/>      allow_refresh_token               = optional(bool)<br/>      enforce_cascade_revocation        = optional(bool)<br/>      enforce_device_binding            = optional(string)<br/>      enforce_online_refresh_tokens     = optional(bool)<br/>      can_create_session_transfer_token = optional(bool)<br/>      allowed_authentication_methods    = optional(list(string))<br/>    }))<br/>  }))</pre> | `null` | no |
| client\_grants | Scope grants on an API audience, keyed by the client\_applications key of the client that receives the grant | <pre>map(object({<br/>    client_id                   = optional(string)<br/>    audience                    = optional(string)<br/>    scopes                      = optional(list(string))<br/>    allow_all_scopes            = optional(bool)<br/>    allow_any_organization      = optional(bool)<br/>    authorization_details_types = optional(list(string))<br/>    organization_usage          = optional(string)<br/>    subject_type                = optional(string)<br/>  }))</pre> | `null` | no |
| organizations | Auth0 organizations. Each connections entry keys either an in-module connection or, when connection\_id is set, an externally managed one. Each members entry keys an in-module user. | <pre>map(object({<br/>    name         = optional(string)<br/>    display_name = optional(string)<br/>    metadata     = optional(map(string))<br/>    branding = optional(object({<br/>      logo_url = optional(string)<br/>      colors   = optional(map(string))<br/>    }))<br/>    connections = optional(map(object({<br/>      connection_id              = optional(string)<br/>      assign_membership_on_login = optional(bool, false)<br/>      is_signup_enabled          = optional(bool)<br/>      show_as_button             = optional(bool)<br/>    })), {})<br/>    members = optional(list(string), [])<br/>  }))</pre> | `null` | no |
| resource\_servers | APIs (resource servers) to create with their scopes, keyed by an identifier that is the default API name | <pre>map(object({<br/>    name                                            = optional(string)<br/>    identifier                                      = string<br/>    signing_alg                                     = optional(string, "RS256")<br/>    allow_offline_access                            = optional(bool, false)<br/>    token_dialect                                   = optional(string)<br/>    skip_consent_for_verifiable_first_party_clients = optional(bool, false)<br/>    consent_policy                                  = optional(string)<br/>    enforce_policies                                = optional(bool)<br/>    signing_secret                                  = optional(string)<br/>    token_lifetime                                  = optional(number)<br/>    token_lifetime_for_web                          = optional(number)<br/>    verification_location                           = optional(string)<br/>    authorization_details = optional(object({<br/>      disable = optional(bool)<br/>      type    = optional(string)<br/>    }))<br/>    proof_of_possession = optional(object({<br/>      required_for = optional(string)<br/>      disable      = optional(bool)<br/>      mechanism    = optional(string)<br/>      required     = optional(bool)<br/>    }))<br/>    subject_type_authorization = optional(object({<br/>      enabled = optional(bool)<br/>      client = optional(object({<br/>        policy = optional(string)<br/>      }))<br/>      user = optional(object({<br/>        policy = optional(string)<br/>      }))<br/>    }))<br/>    token_encryption = optional(object({<br/>      disable = optional(bool)<br/>      format  = optional(string)<br/>      encryption_key = optional(object({<br/>        name      = optional(string)<br/>        algorithm = optional(string)<br/>        pem       = optional(string)<br/>        kid       = optional(string)<br/>      }))<br/>    }))<br/>    resource_server_identifier = optional(string)<br/>    scopes = optional(list(object({<br/>      name        = optional(string)<br/>      description = optional(string)<br/>    })))<br/>  }))</pre> | `null` | no |
| roles | Auth0 roles to create. Membership is assigned to people outside terraform, so a role is declared here and its holders are managed in Auth0. | <pre>map(object({<br/>    name        = optional(string)<br/>    description = optional(string)<br/>  }))</pre> | `null` | no |
| trigger\_actions | Action bindings per trigger: a trigger id such as post-login mapped to the action keys to run, in order | `map(list(string))` | `null` | no |
| users | Users to create, keyed by an identifier that is the default name. A random password is generated when password is not set. | <pre>map(object({<br/>    connection_name        = optional(string, "Username-Password-Authentication")<br/>    user_id                = optional(string)<br/>    username               = optional(string)<br/>    name                   = optional(string)<br/>    family_name            = optional(string)<br/>    given_name             = optional(string)<br/>    phone_number           = optional(string)<br/>    phone_verified         = optional(string)<br/>    nickname               = optional(string)<br/>    email                  = optional(string)<br/>    email_verified         = optional(string)<br/>    verify_email           = optional(bool)<br/>    password               = optional(string)<br/>    picture                = optional(string)<br/>    app_metadata           = optional(string)<br/>    user_metadata          = optional(string)<br/>    custom_domain_header   = optional(string)<br/>    blocked                = optional(bool)<br/>    random_password_length = optional(number, 16)<br/>  }))</pre> | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| action\_triggers | The IDs of the trigger-to-action bindings |
| actions | Map of action keys to their Auth0 IDs |
| api\_identifiers | The 'Audience' identifiers for your regional APIs |
| api\_scopes\_list | List of scopes defined for each API key |
| client\_applications | Client applications created, keyed like the client\_applications input |
| client\_connections | Client applications enabled on each connection, keyed <connection key>-<client key> |
| client\_grant\_details | Detailed mapping of which client is granted which scopes on which audience |
| client\_secrets | Client secrets of the created client applications, keyed like the client\_applications input |
| connections | Connections created, keyed like the client\_application\_connections input |
| organization\_connections | Connections enabled on each organization, keyed <organization key>-<connection key> |
| organization\_members | Users added to each organization, keyed <organization key>-<user key> |
| organizations | Organizations created, keyed like the organizations input |
| roles | Auth0 roles created, keyed by the input identifier |
| users | Users created, keyed like the users input |
<!-- END_TF_DOCS -->

## License

Apache 2.0. See [LICENSE](LICENSE).
