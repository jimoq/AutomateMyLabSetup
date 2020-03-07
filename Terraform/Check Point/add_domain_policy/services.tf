resource "checkpoint_management_service_tcp" "Http_9090" {
  name = "Http_9090"
  port = 9090
  color = "red"
  match_for_any = false
  session_timeout = 3550
}