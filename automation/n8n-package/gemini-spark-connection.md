# Gemini Spark Connection Checklist

Use this checklist only after the personal-computer n8n host is online, upgraded to a version that supports the intended MCP capability, and publicly available over HTTPS.

1. Create one small workflow that accepts a defined automation request and returns a short status result. Do not expose blanket workflow administration.
2. Add authentication to the Webhook node using a dedicated header or JWT credential, and set the workflow to published only after testing.
3. If using MCP instead of a webhook, enable instance-level MCP access only after reviewing the current n8n version’s MCP documentation. Enable only the exact workflow that Gemini Spark needs.
4. In Gemini Spark, open **Connected apps**, add the verified remote MCP URL, and complete the provider's approval flow. Do not include an n8n bearer token in a Spark task prompt.
5. Update the existing Spark task with the public endpoint name and the permitted operations only after a successful test response.

> The public HTTPS URL, webhook secret, MCP access token, and n8n encryption key are deployment secrets. They must stay in the target computer's environment or secret store and must not be written into this file.
