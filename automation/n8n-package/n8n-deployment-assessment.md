# n8n Deployment and Gemini Spark Integration Assessment

## Verified Current State

The local n8n instance is listening on port `5678`, and its `/healthz` endpoint returns HTTP `200`. The installed version is **n8n 1.76.3**. The local configuration file permissions have been restricted to owner-only access (`0600`).

This instance is running in a session-based sandbox, so it is **not a durable public service**. It can stop when the sandbox hibernates and cannot be relied upon for production webhooks, remote MCP clients, or daily workflows that must continue when this session is inactive.

## Gemini Spark Integration Boundary

Gemini Spark's custom-app connection accepts an MCP server URL. Modern n8n instance-level MCP support requires enabling MCP on the n8n instance and explicitly exposing individual workflows; cloud-based MCP clients also need the n8n instance to be publicly accessible. [1] The current n8n version is older than the documented current instance-level MCP feature set, so it cannot be treated as a verified Gemini Spark MCP endpoint without a controlled upgrade and configuration review.

n8n webhooks can provide a secure workflow API when a workflow is published. The Webhook node supports header authentication, JWT authentication, and IP allowlisting, and can return workflow output; this is the preferred API pattern for a narrowly scoped automation endpoint rather than exposing the whole n8n instance. [2]

## Deployment Paths

| Approach | What it provides | Trade-offs | Setup complexity |
| --- | --- | --- | --- |
| Personal always-on computer | Durable n8n with local data and no additional hosting provider | The computer must remain online; it needs a public HTTPS tunnel or domain for remote webhooks/MCP | Moderate |
| Managed persistent server | A public, continuously running n8n with stable HTTPS and background workflow processing | Requires a paid persistent runtime; it is the correct fit when the user's computer cannot stay online | Moderate |
| Current sandbox | Immediate local testing only | It hibernates and is not suitable for durable public automation | Low, but not production-ready |

## Security Baseline for the Eventual API Connection

Expose only one approved n8n workflow through a published Webhook or explicitly enabled MCP workflow. Use a dedicated secret stored only in the persistent host, enforce header/JWT authentication, and restrict callers where possible. Do not place the n8n API key, MCP bearer token, cookies, or Gemini credentials in the Spark task instructions, Drive log, Sheet, or Calendar.

## References

[1] [n8n — Connect to n8n MCP server](https://docs.n8n.io/connect/connect-to-n8n-mcp-server/)

[2] [n8n — Webhook node](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.webhook/)
