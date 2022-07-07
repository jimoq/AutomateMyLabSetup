locals {
  # assign local variable local.gaia_sid the sid value from the json response
  gaia_sid = jsondecode(restapi_object.gaia_login.create_response)

}