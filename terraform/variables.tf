variable "github_token" {
  description = "GitHub personal access token with repo permissions"
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "GitHub username or organization"
  type        = string
  default     = "env1bot"
}

variable "repository_name" {
  description = "Name of the GitHub repository"
  type        = string
  default     = "env1bot.github.io"
}

variable "bootstrap_mode" {
  description = "Set to true during initial setup to skip required status checks (chicken-and-egg problem)"
  type        = bool
  default     = true
}
