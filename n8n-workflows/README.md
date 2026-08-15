# Repaired n8n Workflow Bundle

This bundle contains **sanitized, inactive drafts** generated from the available n8n exports. Each draft has its historical identifiers removed, its active flag set to `false`, and any credential-like values redacted. It is safe to version-control this bundle, but it is not safe to activate a workflow until its trigger, credentials, external resource identifiers, and expected outputs have been reviewed.

The archive included empty and trigger-only workflows. Their business action cannot be derived from the workflow file, so they are retained as named drafts rather than being fabricated into potentially harmful automations. The multi-step Google Veo/Drive/YouTube workflow needs a Google Sheets OAuth credential and review of its remote API steps. The Perplexity workflow needs a valid Perplexity credential; all possible sensitive strings in its export are redacted in the repaired copy.

> Imported workflows remain **inactive** by design. Credentials must be connected through n8n's credential interface rather than committed to GitHub or placed in workflow JSON.
