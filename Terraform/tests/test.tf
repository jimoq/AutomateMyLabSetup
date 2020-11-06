  variable "objects" {
  type = "list"
  description = "list of objects"
  default = [ {
    "uid" : "97aeb3ee-9aea-11d5-bd16-0090272ccb30",
    "name" : "sqlnet1",
    "type" : "service-tcp",
    "domain" : {
      "uid" : "a0bbbc99-adef-4ef8-bb6d-defdefdefdef",
      "name" : "Check Point Data",
      "domain-type" : "data domain"
    },
    "port" : "1521"
  }, {
    "uid" : "97aeb3ef-9aea-11d5-bd16-0090272ccb30",
    "name" : "sqlnet2-1521",
    "type" : "service-tcp",
    "domain" : {
      "uid" : "a0bbbc99-adef-4ef8-bb6d-defdefdefdef",
      "name" : "Check Point Data",
      "domain-type" : "data domain"
    },
    "port" : "1521"
  }, {
    "uid" : "83c410f3-82c6-4882-bc41-bf89b7849092",
    "name" : "tns",
    "type" : "service-tcp",
    "domain" : {
      "uid" : "a0bbbc99-adef-4ef8-bb6d-defdefdefdef",
      "name" : "Check Point Data",
      "domain-type" : "data domain"
    },
    "port" : "1520-1530"
  } 
  ]
}

output "sql" {
  value = var.objects[*].name
}