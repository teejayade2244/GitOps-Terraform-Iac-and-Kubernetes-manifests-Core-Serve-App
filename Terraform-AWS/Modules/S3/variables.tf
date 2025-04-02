variable "bucket_name" {
  type = string
  description = "Specifies the bucket name to be created"
  default = "terraform-state-remote-backend-bucket"
}

variable "bucket_description" {
   type = string
   description = "bucket description"
   default = "s3-bucket-for-remote-backend-state"
}