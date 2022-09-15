resource "restapi_object" "gaia_login" {  
  path         = "/login"
  id_attribute = var.gaia_api_user
#  object_id    = var.gaia_api_user
#  read_path    = "test{id}"
  destroy_method = "POST"
  destroy_path = "/login"
  data         = "{    \"user\"     : \"${var.gaia_api_user}\",    \"password\" : \"${var.gaia_api_password}\"  }"
}

