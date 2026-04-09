# 🔐 AWS VPC Security Lab — CI/CD Pipeline

![Status](https://img.shields.io/badge/Status-Active-brightgreen?style=flat-square)
![Type](https://img.shields.io/badge/Type-Cloud%20Security%20Lab-blue?style=flat-square)
![Cloud](https://img.shields.io/badge/Cloud-AWS-orange?style=flat-square)
![IaC](https://img.shields.io/badge/IaC-Terraform-7B42BC?style=flat-square)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?style=flat-square)
![Auth](https://img.shields.io/badge/Auth-OIDC-success?style=flat-square)
![Scanner](https://img.shields.io/badge/Scanner-Checkov-red?style=flat-square)
![Environment](https://img.shields.io/badge/Environment-us--east--1-lightgrey?style=flat-square)

Production-grade CI/CD pipeline for deploying a three-tier AWS VPC security architecture using Terraform, GitHub Actions, and OIDC authentication — with an automated Checkov security gate.

---

## Pipeline

```
push to main → Validate → Security Scan → Plan → Apply
```

Every push to `main` triggers the full pipeline. Infrastructure is deployed automatically via OIDC — no static AWS credentials stored anywhere.

---

## Architecture

```
GitHub Actions (OIDC)
        │
        ▼
    AWS (us-east-1)
        │
        ├── VPC (10.0.0.0/16)
        │     ├── Public layer  → Bastion Host
        │     ├── App layer     → App EC2
        │     └── Data layer    → Data EC2 (port 5432)
        │
        ├── S3          → Remote Terraform state
        ├── DynamoDB    → State locking
        └── CloudWatch  → VPC Flow Logs + Alerts
```

---

## Security Controls

- **OIDC** — GitHub Actions assumes an IAM Role via short-lived token. No access keys stored.
- **Checkov** — Static security analysis blocks the pipeline before plan if critical issues are found.
- **IMDSv2** — Enforced on all EC2 instances.
- **Least-privilege IAM** — Pipeline role scoped to this repository and required actions only.
- **Remote state** — S3 with versioning, AES-256 encryption, and DynamoDB locking.

---

## Structure

```
├── modules/vpc-security/   ← reusable infrastructure module
├── environments/dev/       ← environment-specific configuration
└── .github/workflows/      ← CI/CD pipeline definition
```

---

## Full Documentation

Complete documentation, architecture decisions, and step-by-step walkthrough available in the [cloud-labs portfolio](https://github.com/sxaAspri/cloud-labs/tree/main/aws/aws-vpc-security-lab-cicd).

---

## References

- [GitHub Actions OIDC with AWS](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
- [Checkov Documentation](https://www.checkov.io)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
