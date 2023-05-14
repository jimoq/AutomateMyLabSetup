 terraform {
# Stores the state using a simple REST client. Used by Gitlab runner
  backend "http" {
#    address = "https://gitlab.com/api/v4/projects/xxx/terraform/state/tfstate"
#    lock_address = "https://gitlab.com/api/v4/projects/xxx/terraform/state/tfstate"
#    unlock_address = "https://gitlab.com/api/v4/projects/xxx/terraform/state/tfstate"
#    lock_method = "POST"
#    unlock_method = "DELETE"
#    retry_wait_min = "5"
  }
}