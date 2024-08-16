variable "max_cpu_nodes" {
  default     = 1
  description = "number of gke cpu only nodes, e.g. for the mlflow tracking server"
}

variable "max_gpu_nodes" {
  default     = 1
  description = "number of gke nodes for training"
}

variable "gpu_type" {
  default     = "nvidia-tesla-t4"
  description = "Type of accelerator"
}

variable "gpu_count" {
  default     = 1
  description = "Number of GPUs per node"
}

variable "cpu_machine_type" {
  default     = "n1-standard-2"
  description = "Type of the CPU only node pool machines"
}

variable "gpu_machine_type" {
  default     = "n1-highmem-4"
  description = "Type of the GPU node pool machines"
}

variable "compute_machine_type" {
  default     = "n2-standard-16"
  description = "Type of machine for high-powered CPU-only node pool"
}

variable "max_compute_nodes" {
  default     = 1
  description = "Number of high-powered CPU-only nodes for e.g. preprocessing"
}

variable "initial_namespaces" {
  description = "Initial kubernetes namespaces"
  type        = list(string)
  default     = ["istio-system"]
}