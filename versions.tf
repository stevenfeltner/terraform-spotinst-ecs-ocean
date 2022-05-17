terraform {
  required_version = ">= 0.13.0"
  required_providers {
    spotinst = {
      source = "spotinst/spotinst"
    }
    aws = {}
  }
}