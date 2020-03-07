resource "checkpoint_management_vpn_community_meshed" "Site2Site" {
  name = "Site2Site"
  encryption_method = "prefer ikev2 but support ikev1"
  encryption_suite = "custom"
  gateways = ["BranchOffice", "Corporate-GW"]
  color = "sea green"
}