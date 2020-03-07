resource "checkpoint_management_application_site_group" "Inappropriate_Sites" {
  name = "Inappropriate Sites"
  members = [ "Child Abuse", "High Risk", "Spyware / Malicious Sites", "Gambling"]
  color = "red"
}