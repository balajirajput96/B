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

The n8n encryption key must be generated and retained securely on the host. It is not a workflow secret to be committed, logged, or transmitted through Gemini Spark.
