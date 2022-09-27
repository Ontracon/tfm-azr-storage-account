# ---------------------------------------------------------------------------------------------------------------------
# Global Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "cloud_region" {
  type        = string
  description = "Define the cloud region to use (AWS Region / Azure Location) which tf should use."
}

variable "global_config" {
  type = object({
    env             = string
    customer_prefix = string
    project         = string
    application     = string
    costcenter      = string
  })
  description = "Global config Object which contains the mandatory informations within OTC."
}
