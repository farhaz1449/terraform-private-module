# Moving Terraform Modules to a Remote Private Repository

**Great choice!** Moving modules from your local computer to a remote private repository is the hallmark of a **Senior DevOps workflow**. It allows different teams at your company to use the same code without copy-pasting folders.

There are two main ways to handle this:
- Using **Git directly**
- Using a **Private Module Registry**

---

## 1. Using a Private Git Repository (The "Pro" Way)

This is the most common method. You host your module code in a private GitHub or GitLab repository and point your Terraform project to that URL.

### The Source Syntax

In your project’s `main.tf`, the source changes from a local path to a Git URL:

```hcl
module "vpc" {
  # Using SSH (Best for local development)
  source = "git@github.com:YourOrg/terraform-aws-vpc.git?ref=v1.2.0"
  
  # OR Using HTTPS (Best for CI/CD pipelines)
  # source = "git::https://github.com/YourOrg/terraform-aws-vpc.git?ref=main"

  instance_name = "RemoteModuleDemo"
  environment   = "prod"
}
```

### Critical Detail: The `?ref=` Parameter

In real life, **never point a production project to the main branch.**  
If someone updates the module and breaks it, your production `terraform apply` will fail.

Use **Git Tags (e.g., v1.0.0)** to *pin* your module to a specific version.  
This ensures your infrastructure stays stable until you’re ready to upgrade.

---

## 2. Authentication: The Hardest Part

Since the repository is private, Terraform needs permission to download it.

### Option A: SSH Keys (Recommended)
If you have an SSH key added to your GitHub account, Terraform will use it automatically.  
This is why the `git@github.com` syntax is preferred by developers.

### Option B: Personal Access Tokens (PAT)
In CI/CD pipelines (like Jenkins or GitHub Actions), you can use a token and configure Git globally to use it:

```bash
git config --global url."https://oauth2:YOUR_TOKEN@github.com".insteadOf "https://github.com"
```

---

## 3. The Private Module Registry (The "Enterprise" Way)

Companies using Terraform Cloud or GitLab Premium use a **Private Registry**.  
This provides a neat UI where teams can browse available modules, read documentation, and see version history—just like the public Terraform Registry.

### Why use a Registry instead of Git?

- **Semantic Versioning:** Use the `version` argument instead of `?ref=`.
- **Discovery:** Browse "Approved" modules easily.
- **Security:** Improved RBAC (Role-Based Access Control).

### Example Registry Call

```hcl
module "secure_s3" {
  source  = "app.terraform.io/MyCompany/s3/aws"
  version = "2.1.0"
}
```

---

## 4. Hands-on Experiment: Try This Now

If you have a private Git repo, try this locally to see how Terraform handles it:

1. **Move your module:** Push the `ec2_instance` code you wrote earlier to a new private GitHub repository.
2. **Change your project:** Update your `main.tf` to point to that Git URL.
3. **Run `terraform init`:** Terraform will actually run a `git clone` into a hidden folder.
4. **Check it out:** Look inside `.terraform/modules/` to see the downloaded code!

---

## Comparison Table

| Feature         | Local Module      | Private Git Repo | Private Registry     |
|-----------------|-------------------|------------------|----------------------|
| **Setup Speed** | Instant           | Fast             | Slow (Needs TFC/GitLab) |
| **Reusability** | None (Local only) | High             | Highest              |
| **Versioning**  | No                | Yes (Git Tags)   | Yes (`version` arg)  |
| **Best For**    | Testing/Lab       | Small–Mid Teams  | Large Enterprises    |

---

Since you're focused on **DevOps**, would you like to see how to set up a **GitHub Action** that automatically tests your module whenever you push code to that remote repository?
