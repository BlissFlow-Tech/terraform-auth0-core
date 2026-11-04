# Basic example

Creates a regular web application, an API with one scope, and a database connection enabled for the application.

The Auth0 provider reads its credentials from `AUTH0_DOMAIN`, `AUTH0_CLIENT_ID` and `AUTH0_CLIENT_SECRET`.

```sh
terraform init
terraform apply -var app_url=https://app.example.com
```
