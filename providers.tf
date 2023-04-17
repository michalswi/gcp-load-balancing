provider "google" {}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "=4.60.2"
    }
  }
  required_version = "~>1.3.0"
}
