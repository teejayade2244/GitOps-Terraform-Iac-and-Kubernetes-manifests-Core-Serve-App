variable "dynamo_db_name_remote-backend" {
  type = string
  description = "Dynamo-db name for the terraform state file lock"
  default = "terraform_state_remote-backend"
}

variable "hash_key" {
  type = string
  default     = "LockID" 
}

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