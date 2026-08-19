# Gemini and n8n Connection Checklist

Use this checklist only after the personal-computer n8n host is online, upgraded to a version that supports the intended capability, and publicly available over HTTPS. This repository does not bundle credentials, authenticate third-party accounts, or activate workflows automatically.

## 1. Choose the authentication method for the actual service

| Integration target | Supported setup path | Credential-management link | Safety boundary |
|---|---|---|---|
| Gemini API model calls | Create or manage a Gemini API key in Google AI Studio, then add it only to the appropriate n8n credential or host-side secret store. | [Google AI Studio API keys](https://aistudio.google.com/apikey) | Use an environment or secret-store value such as `GEMINI_API_KEY`; never commit it, paste it into a workflow export, or include it in a prompt. |
| Google Calendar, Drive, Gmail, YouTube, or other Google service nodes | Configure a dedicated n8n Google OAuth2 credential. OAuth2 is the recommended method for the broadest n8n node support. | [n8n Google credential documentation](https://docs.n8n.io/integrations/builtin/credentials/google/) | Grant the minimum Google scopes required by the exact workflow, and do not reuse a Gemini API key as a Google OAuth credential. |
| Remote n8n webhook | Protect the Webhook node with a dedicated header or JWT credential and publish only after a successful scoped test. | [n8n Webhook documentation](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.webhook/) | Keep the public HTTPS URL and webhook secret only in the host environment or secret store. |
| Remote n8n MCP endpoint | Verify that the installed n8n version supports the intended MCP capability, then enable only the specific approved workflow. | [n8n MCP documentation](https://docs.n8n.io/advanced-ai/accessing-n8n-mcp-server/) | Do not enable instance-wide workflow administration or place an MCP token in a task prompt. |

## 2. Create and test the least-privileged workflow

1. Create one small workflow that accepts a defined automation request and returns a short status result. Do not expose blanket workflow administration.
2. Add the required n8n credential through the n8n credential manager or a host-side secret store. Keep separate credentials for Gemini API access and Google OAuth2 access.
3. Test with non-sensitive sample input, confirm the expected response, and inspect n8n execution logs for the exact workflow only.
4. Publish the workflow only after the credential, output, and permitted action are verified.

## 3. Connect a client only after the endpoint is verified

If the intended Gemini or Google product exposes a **Connected apps** or remote MCP flow, add the verified remote MCP URL and complete that provider's approval flow. Do not assume that every client supports remote MCP; verify the current product documentation first. Update any client task only with the public endpoint name and its permitted operations after a successful test response.

> The public HTTPS URL, webhook secret, MCP access token, n8n encryption key, Google OAuth refresh token, and Gemini API key are deployment secrets. They must stay in the target computer's environment or secret store and must not be written into this repository, an n8n workflow export, or a client prompt.
