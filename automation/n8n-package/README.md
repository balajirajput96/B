# Integrated n8n automation package

This directory is an additive integration of the independent `n8n-automation` history into the working `main` site repository. It is intentionally nested so the static site remains unchanged; the two remote branches have no common Git merge base, so no destructive rebase was performed.

The package contains sanitized, inactive n8n workflow drafts, deployment guidance, a Compose definition, and Gemini Spark connection notes. All workflows remain inactive until their intended business action, credentials, external resource IDs, and expected outputs are verified in a durable n8n instance.

## Validation status

The main static-site workflow checks pass locally. All 14 workflow exports listed in `n8n-workflows/manifest.json` parse as JSON and satisfy the local structural validator. Several files are placeholders or credential-dependent drafts; they are not safe to activate automatically. Docker and n8n are not installed in the current sandbox, so runtime execution remains pending on the target host.

## Remote-operation boundary

This local integration branch has not been pushed, rebased remotely, merged, or used to change repository settings. Before any remote mutation, review the diff, choose the target branch and merge strategy, and explicitly approve the push/PR operation. Never commit API keys, OAuth tokens, publish profiles, or n8n credential exports.
