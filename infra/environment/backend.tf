terraform {
  backend "gcs" {
    bucket = "artful-fragment-458014-j4-tf-state"
    prefix = "devops-challenge"
  }
}