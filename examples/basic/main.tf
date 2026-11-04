module "auth0" {
  source = "../.."

  client_applications = {
    web = {
      name            = "web"
      app_type        = "regular_web"
      callbacks       = ["${var.app_url}/callback"]
      allowed_origins = [var.app_url]
      grant_types     = ["authorization_code", "refresh_token"]
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

  client_application_connections = {
    users = {
      strategy        = "auth0"
      enabled_clients = ["web"]
    }
  }
}

output "web_client_id" {
  value = module.auth0.client_applications["web"].client_id
}
