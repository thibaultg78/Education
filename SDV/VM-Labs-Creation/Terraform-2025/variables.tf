variable "vm_count" {
  description = "Nombre de VMs à créer"
  type        = number
  default     = 2
}

variable "admin_username" {
  description = "Nom d'utilisateur admin pour les VMs"
  type        = string
  default     = "student"
}

variable "admin_password" {
  description = "Mot de passe admin pour les VMs"
  type        = string
  sensitive   = true
  default     = "StudentPassword123456!"
}

variable "vm_size" {
  description = "Taille des VMs"
  type        = string
  default     = "Standard_B2ms"
}

variable "location" {
  description = "Région Azure"
  type        = string
  default     = "France Central"
}