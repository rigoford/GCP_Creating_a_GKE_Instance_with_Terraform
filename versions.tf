terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.85.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "2.1.0"
    }
  }
}
