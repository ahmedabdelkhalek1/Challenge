terraform {
  backend "gcs" {
    bucket = "devops-challenge-tf"
    prefix = "devops-challenge-tf"
  }
}