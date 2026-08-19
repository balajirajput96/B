# Runtime Environment Template

Create the actual runtime environment configuration only on the durable n8n host. Use the following value names; do not place real values in this repository.

```text
TZ=Asia/Kolkata
GENERIC_TIMEZONE=Asia/Kolkata
N8N_HOST=<final HTTPS hostname>
N8N_PROTOCOL=https
N8N_EDITOR_BASE_URL=https://<final HTTPS hostname>/
N8N_WEBHOOK_URL=https://<final HTTPS hostname>/
N8N_ENCRYPTION_KEY=<new random value generated on the host>
```

The n8n encryption key must be generated and retained securely on the host. It is not a workflow secret to be committed, logged, or transmitted through a client prompt.

## Gemini and Google credentials

Do **not** add API keys, OAuth client secrets, refresh tokens, or service-account JSON to this template. Configure each credential in n8n's credential manager or the target host's secret store instead.

| Credential | Where to manage it | Use it for |
|---|---|---|
| Gemini API key | [Google AI Studio API keys](https://aistudio.google.com/apikey) | Gemini model calls only; supply it to the host or an n8n credential as `GEMINI_API_KEY` when the selected node requires it. |
| Google OAuth2 credential | [n8n Google credential documentation](https://docs.n8n.io/integrations/builtin/credentials/google/) | Google Calendar, Drive, Gmail, YouTube, and other Google service nodes. |
| n8n encryption key | Target host environment or secret store | Encrypting n8n credentials at rest. |

Use separate, least-privileged credentials for each integration. A Gemini API key is not a replacement for Google OAuth2, and no secret belongs in a committed workflow JSON export.
