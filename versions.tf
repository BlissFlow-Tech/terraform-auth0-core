terraform {
  required_version = ">= 1.5"
  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = ">= 1.41.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0, < 4.0"
    }
  }
}
