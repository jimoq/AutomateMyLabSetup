# Error - when changeing the code the provide is sending unsupported parameter: {"add-default-rule":true,"} with API endpoint set-access-layer
resource "checkpoint_management_access_layer" "Web_Control" {
  name = "Web Control"
  comments = "Filter access to Internet"
  applications_and_url_filtering = true
  content_awareness = true
  mobile_access = true
  shared = true
  color = "red"
}

resource "checkpoint_management_access_layer" "Data_Center_Layer" {
  name = "Data Center Layer"
  comments = "Shared layer for data center traffic"
  applications_and_url_filtering = true 
  content_awareness = true
  mobile_access = true
  shared = true
  color = "sea green"
}

resource "checkpoint_management_access_layer" "Guest_Exception_Layer" {
  name = "Guest_Exception_Layer"
  comments = "Control traffic for our guests"
  applications_and_url_filtering = true
  content_awareness = true
  shared = true
  color = "blue"
}