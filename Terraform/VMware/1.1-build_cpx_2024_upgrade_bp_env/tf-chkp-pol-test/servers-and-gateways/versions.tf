terraform {
  required_providers {
    checkpoint = {
      #      source  = "terraform.local/local/checkpoint" // use this when to test a local provider
      source = "checkpointsw/checkpoint"
    }
  }
}