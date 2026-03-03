provider "github" {
  token = var.github_token
  owner = var.github_owner
}

# Repository settings
resource "github_repository" "portfolio" {
  name        = var.repository_name
  description = "Personal portfolio and blog"
  visibility  = "public"

  has_issues   = true
  has_projects = false
  has_wiki     = false

  # GitHub Pages served via Actions, not from a branch
  pages {
    build_type = "workflow"
  }

  # Security settings
  vulnerability_alerts = true

  # Merge settings — squash only for clean history
  allow_merge_commit = false
  allow_squash_merge = true
  allow_rebase_merge = false
  delete_branch_on_merge = true

  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "PR_BODY"
}

# Branch protection for main
resource "github_branch_protection" "main" {
  repository_id = github_repository.portfolio.node_id
  pattern       = "main"

  # Require PR reviews
  required_pull_request_reviews {
    required_approving_review_count = 0
    dismiss_stale_reviews           = true
  }

  # Require status checks only after bootstrap
  dynamic "required_status_checks" {
    for_each = var.bootstrap_mode ? [] : [1]
    content {
      strict = true
      contexts = [
        "build",
        "lint",
        "security",
      ]
    }
  }

  # Allow admins to bypass during bootstrap
  enforce_admins = var.bootstrap_mode ? false : true

  # Prevent force pushes and branch deletion
  allows_force_pushes  = false
  allows_deletions     = false
  require_conversation_resolution = true
}

# Repository-level Actions permissions
resource "github_actions_repository_permissions" "portfolio" {
  repository = github_repository.portfolio.name

  allowed_actions = "selected"
  allowed_actions_config {
    github_owned_allowed = true
    patterns_allowed = [
      "lycheeverse/*",
      "peter-evans/*",
      "treosh/*",
      "hashicorp/*",
      "zgosalvez/*",
    ]
  }
}
