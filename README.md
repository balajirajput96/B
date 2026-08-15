# Balaji Digital Marketing and Automation Package

This repository contains a responsive static marketing site and a safe, version-controlled package for self-hosted n8n automation work.

## Static Website

The marketing site is available in `index.html` with matching styles in `styles.css`. Open `index.html` in a modern browser to preview it. The contact form is intentionally presentation-only until a server-side endpoint is configured.

## n8n Automation Package

The package under `automation/n8n-package/` includes a localhost-bound Docker Compose configuration, a Gemini Spark connection checklist, a deployment assessment, and 14 **sanitized inactive workflow drafts**. The drafts are intentionally inactive because some contain placeholders, triggers without a verified business action, or dependencies on credentials and external resources that have not been confirmed.

## Repository Safety

Secrets are intentionally excluded. Configure n8n encryption keys, OAuth credentials, API keys, endpoint URLs, and authentication values only in the target host's credential store or runtime environment. Never add those values to this repository, a workflow export, a Gemini task prompt, or a public issue.

| Path | Purpose |
| --- | --- |
| `index.html` and `styles.css` | Static marketing site. |
| `automation/n8n-package/compose.yaml` | Localhost-only n8n service configuration for the intended persistent host. |
| `automation/n8n-package/n8n-deployment-guide.md` | Durable hosting, security, and migration guidance. |
| `automation/n8n-package/gemini-spark-connection.md` | Checklist for adding a verified, durable n8n endpoint to Gemini Spark. |
| `automation/n8n-package/n8n-workflows/` | Sanitized inactive workflow drafts, repair manifest, and import/readiness assessment. |

> A workflow must remain inactive until its trigger purpose, required credentials, external resource IDs, and expected output have been verified in the durable n8n environment.

The temporary development environment is useful for drafting and testing. A connected personal computer or another durable host is required before exposing n8n automation to external services.
