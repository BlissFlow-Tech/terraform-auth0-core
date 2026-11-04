data "auth0_client" "this" {
  for_each  = var.client_applications != null ? var.client_applications : {}
  client_id = auth0_client.this[each.key].client_id
}
