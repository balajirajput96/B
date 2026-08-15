# Test-Readiness Report

## Local n8n Configuration State

The local n8n instance contains **14 test-ready workflow drafts**. All 14 are inactive. Empty placeholders have been converted into manual review/status templates, while trigger-only drafts now send their data through a non-destructive pass-through status action.

| Workflow group | Current readiness | Activation boundary |
| --- | --- | --- |
| Empty placeholder drafts | Manual status templates are present | Define the actual business action before activation. |
| n8n and MCP trigger drafts | Safe pass-through action is present | Expose only after a durable host and a narrow workflow purpose are established. |
| AI Agent draft | OpenAI model binding is configured locally | Test in the local editor, then activate only with a reviewed prompt and approved trigger. |
| Video generation draft | OpenAI title-generation binding is configured locally | Requires Google Sheets OAuth and review of the external video, Drive, and upload steps. |
| Perplexity draft | Sanitized inactive draft | Requires a Perplexity credential before testing. |
| IMAP draft | Inactive pass-through draft | Requires an IMAP credential and explicit mailbox/filter rules. |

## Credential Safety

This repository does not contain credentials, OAuth tokens, local credential IDs, API keys, session cookies, or endpoint secrets. Provider credentials are configured only in the local n8n credential store. The two workflows that can use the existing OpenAI credential are configured locally, but their repository copies intentionally retain no credential reference.

## Deployment Boundary

GitHub stores the reproducible configuration and workflow drafts. It does **not** host a running n8n server. A durable n8n runtime with HTTPS is still required before any webhook, schedule, MCP endpoint, or external integration can operate continuously.
