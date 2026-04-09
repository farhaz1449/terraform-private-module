Great choice. Moving modules from your local computer to a **Remote Private Repository** is the hallmark of a "Senior" DevOps workflow. It allows different teams at your company to use the same code without needing to copy-paste folders.

There are two main ways to handle this: using **Git directly** or using a **Private Module Registry**.

## ---

**1\. Using a Private Git Repository (The "Pro" Way)**

This is the most common method. You host your module code in a private GitHub or GitLab repository and point your Terraform project to that URL.

### **The Source Syntax**

In your project’s main.tf, the source changes from a local path to a Git URL:

Terraform

module "vpc" {  
  \# Using SSH (Best for local development)  
  source \= "git@github.com:YourOrg/terraform-aws-vpc.git?ref=v1.2.0"  
    
  \# OR Using HTTPS (Best for CI/CD pipelines)  
  \# source \= "git::https://github.com/YourOrg/terraform-aws-vpc.git?ref=main"

  instance\_name \= "RemoteModuleDemo"  
  environment   \= "prod"  
}

### **Critical Detail: The ?ref= Parameter**

In real life, you **never** want to point a production project to the main branch. If someone updates the module and breaks it, your production terraform apply will fail.

* Use **Git Tags** (e.g., v1.0.0) to "pin" your module to a specific version.  
* This ensures your infrastructure stays stable until you are ready to upgrade.

## ---

**2\. Authentication: The Hardest Part**

Since the repository is **private**, Terraform needs permission to download it.

### **Option A: SSH Keys (Recommended)**

If you have an SSH key added to your GitHub account, Terraform will use it automatically. This is why the git@github.com syntax is preferred by developers.

### **Option B: Personal Access Tokens (PAT)**

In a **Jenkins** or **GitHub Actions** pipeline, you usually use a token. You can tell Git to "swap" HTTPS for a token-authenticated URL globally:

Bash

git config \--global url."https://oauth2:YOUR\_TOKEN@github.com".insteadOf "https://github.com"

## ---

**3\. The Private Module Registry (The "Enterprise" Way)**

Companies using **Terraform Cloud** or **GitLab Premium** use a "Registry." This provides a UI where teams can browse available modules, read documentation, and see version history—just like the public Terraform Registry.

**Why use a Registry instead of just Git?**

* **Semantic Versioning:** You can use the version argument instead of ?ref=.  
* **Discovery:** Other teams can see a list of "Approved" modules.  
* **Security:** Better RBAC (Role-Based Access Control).

**Example Registry Call:**

Terraform

module "secure\_s3" {  
  source  \= "app.terraform.io/MyCompany/s3/aws"  
  version \= "2.1.0"  
}

## ---

**4\. Hands-on Experiment: Try this now**

If you have a private Git repo, try this locally to see how Terraform handles it:

1. **Move your module:** Push the ec2\_instance code we wrote earlier to a new private GitHub repository.  
2. **Change your project:** Update your project's main.tf to point to that Git URL.  
3. **Run terraform init:** Watch the output. Terraform will actually run a git clone into a hidden folder.  
   * *Check it out:* Look inside .terraform/modules/ to see the downloaded code\!

### **Comparison Table**

| Feature | Local Module | Private Git Repo | Private Registry |
| :---- | :---- | :---- | :---- |
| **Setup Speed** | Instant | Fast | Slow (Needs TFC/GitLab) |
| **Reusability** | None (Local only) | High | Highest |
| **Versioning** | No | Yes (Git Tags) | Yes (Version argument) |
| **Best For** | Testing/Lab | Small-Mid Teams | Large Enterprises |

Since you're focused on **DevOps**, would you like to see how to set up a **GitHub Action** that automatically tests your module whenever you push code to that remote repository?