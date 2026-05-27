# docmost-mcp-server

Containerized [docmost-mcp](https://github.com/MrMartiniMo/docmost-mcp) — an MCP server for [Docmost](https://docmost.com) that lets AI agents manage documentation spaces and pages.

## Usage

```json
{
  "mcpServers": {
    "docmost": {
      "command": "docker",
      "args": ["run", "--rm", "-i",
        "-e", "DOCMOST_API_URL",
        "-e", "DOCMOST_EMAIL",
        "-e", "DOCMOST_PASSWORD",
        "ghcr.io/rafaribe/docmost-mcp-server:latest"
      ],
      "env": {
        "DOCMOST_API_URL": "https://docs.example.com/api",
        "DOCMOST_EMAIL": "user@example.com",
        "DOCMOST_PASSWORD": "password"
      }
    }
  }
}
```

## Environment Variables

| Variable | Description |
|---|---|
| `DOCMOST_API_URL` | Full URL to your Docmost API (e.g. `https://docs.example.com/api`) |
| `DOCMOST_EMAIL` | Docmost user email |
| `DOCMOST_PASSWORD` | Docmost user password |
