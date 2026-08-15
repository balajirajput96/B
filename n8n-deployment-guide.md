# Personal-Computer n8n Deployment Package

## Purpose

This package prepares a **durable self-hosted n8n** service for the connected personal computer. It must remain online for the Gemini Spark automation to reach its approved webhook or MCP endpoint. The local sandbox instance is only a source for workflow export; it is not the final host.

## Security Design

The Compose service binds n8n only to `127.0.0.1:5678`. A separate HTTPS reverse proxy or trusted tunnel must be configured on the personal computer before any remote Gemini connection is created. Configure `N8N_HOST`, `N8N_EDITOR_BASE_URL`, and `N8N_WEBHOOK_URL` with the final HTTPS public address. n8n documents that reverse-proxy deployments must set `N8N_WEBHOOK_URL` and `N8N_PROXY_HOPS=1`. [1]

The `N8N_ENCRYPTION_KEY` must be newly generated on the target computer and preserved in a secure password manager. Changing it later without a planned migration can prevent access to stored credentials. Never copy the `.env` file, API keys, session cookies, or access tokens into a Gemini Spark instruction.

## Deployment Procedure After the Personal Computer Is Connected

First, copy this folder to a directory in the computer's native filesystem. On Windows with WSL, n8n recommends keeping Docker project files in the Linux filesystem rather than under `/mnt/c`. [2] Copy `.env.example` to `.env`, replace all placeholder values, and generate the encryption key locally. Then start the persistent service with:

```bash
docker compose up -d
docker compose ps
curl -sf http://127.0.0.1:5678/healthz
```

After the HTTPS domain or tunnel is available, verify that the public endpoint reaches n8n and that n8n displays production webhook URLs using the same HTTPS address. Only then import the workflow backup from `backup/` and enable any workflow that must execute automatically.

## Gemini Spark Integration

Do **not** expose the n8n editor or public REST API to Gemini Spark. Use one of the following narrowly scoped interfaces:

| Interface | Use case | Required security |
| --- | --- | --- |
| Published n8n Webhook workflow | Spark or another service invokes a single approved workflow | Header/JWT authentication, narrow input schema, validated response, optional IP allowlist |
| n8n MCP workflow exposure | Spark custom app connects to explicitly enabled workflows when the upgraded n8n version supports it | Public HTTPS MCP URL, individual workflow enablement, least-privilege OAuth/API-key connection |

n8n's Webhook node supports header authentication, JWT authentication, and IP allowlisting; production webhook URLs register only when the workflow is published. [3] n8n's current instance-level MCP documentation requires a public instance, enabling MCP, and explicitly enabling each workflow to expose. [4]

## Sources

[1] [n8n — Configure webhook URLs with reverse proxy](https://docs.n8n.io/deploy/host-n8n/configure-n8n/basic-configuration/configuration-examples/configure-webhook-urls-with-reverse-proxy.md)

[2] [n8n — Install using Docker Compose](https://docs.n8n.io/deploy/host-n8n/install-options/install-using-docker-compose.md)

[3] [n8n — Webhook node](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.webhook/)

[4] [n8n — Connect to n8n MCP server](https://docs.n8n.io/connect/connect-to-n8n-mcp-server/)
