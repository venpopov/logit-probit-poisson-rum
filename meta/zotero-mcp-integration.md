# Connecting Zotero to AI Coding Agents via MCP

## Summary

Yes, it is possible to connect your Zotero library to AI assistants using the **Model Context Protocol (MCP)**. The most mature solution is the [zotero-mcp](https://github.com/54yyyu/zotero-mcp) server by 54yyyu, which exposes your Zotero library to any MCP-compatible AI client. This enables AI agents to search your library, retrieve metadata, and **export BibTeX entries** — which is exactly what's needed to populate `references.bib`.

## What Works Today

### 1. VS Code Copilot Chat + zotero-mcp (Local — Recommended)

VS Code Copilot supports MCP servers in agent mode. You can configure `zotero-mcp` as a local MCP server in your VS Code settings, and then ask Copilot to:

- Search your Zotero library for papers by title, author, or keywords
- Retrieve BibTeX-formatted citation data via `zotero_get_item_metadata` (with `format="bibtex"`)
- Insert the citation key into your `.qmd` file and append the BibTeX entry to `references.bib`

**Setup steps:**

1. Install zotero-mcp:
   ```bash
   pip install git+https://github.com/54yyyu/zotero-mcp.git
   # or
   uv tool install "git+https://github.com/54yyyu/zotero-mcp.git"
   ```

2. Run the setup wizard:
   ```bash
   zotero-mcp setup
   ```

3. Add to your VS Code settings (`.vscode/settings.json` or user settings):
   ```json
   {
     "mcp": {
       "servers": {
         "zotero": {
           "command": "zotero-mcp",
           "env": {
             "ZOTERO_LOCAL": "true"
           }
         }
       }
     }
   }
   ```

4. Make sure Zotero 7+ is running locally with the local API enabled:
   - Open Zotero → Edit → Preferences → Advanced
   - Check "Allow other applications on this computer to communicate with Zotero"

5. (Recommended) Install the [Better BibTeX](https://retorque.re/zotero-better-bibtex/) plugin in Zotero for consistent citation keys.

6. In VS Code, open Copilot Chat in **Agent mode** and ask:
   > "Search my Zotero library for papers by McFadden on conditional logit and add the BibTeX entry to references.bib"

### 2. Claude Desktop + zotero-mcp

This is the most battle-tested setup. Add to your `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "zotero": {
      "command": "zotero-mcp",
      "env": {
        "ZOTERO_LOCAL": "true"
      }
    }
  }
}
```

### 3. Other MCP Clients

zotero-mcp works with any MCP-compatible client, including:
- [Cherry Studio](https://cherry-ai.com/)
- [Cursor](https://www.cursor.com/)
- [Chorus](https://chorus.sh)
- ChatGPT (via SSE transport + ngrok tunnel — see [setup guide](https://github.com/54yyyu/zotero-mcp/blob/main/docs/getting-started.md))

## What Does NOT Work (Yet)

### GitHub Copilot Coding Agent (github.com web-based)

The **GitHub Copilot coding agent** that runs on github.com (i.e., the agent that processes issues and creates PRs in a sandboxed cloud environment) **cannot** connect to your local Zotero library. This is because:

1. **The agent runs in a cloud sandbox** — it has no access to your local machine where Zotero runs.
2. **MCP servers must be local or web-accessible** — the agent would need your Zotero library exposed via the Zotero Web API, but it currently does not support user-configured MCP servers.
3. **No custom MCP server support** — as of early 2026, the GitHub Copilot coding agent only has access to a fixed set of MCP tools (GitHub API, browser, filesystem within the sandbox). Users cannot add custom MCP servers to it.

**Workaround for the coding agent:** You could maintain an auto-exported `.bib` file (via Better BibTeX's auto-export feature) committed to your repository, so that the coding agent can at least *read* existing citations. But it cannot search or add new ones from Zotero.

## Available Zotero MCP Tools

The `zotero-mcp` server provides these tools relevant to citation management:

| Tool | Description |
|------|-------------|
| `zotero_search_items` | Search library by title, author, keywords |
| `zotero_get_item_metadata` | Get metadata; supports `format="bibtex"` for BibTeX export |
| `zotero_get_collections` | List collections |
| `zotero_get_tags` | List tags |
| `zotero_get_recent` | Get recently added items |
| `zotero_semantic_search` | AI-powered conceptual search (requires setup) |
| `zotero_advanced_search` | Complex multi-criteria search |
| `zotero_search_by_tag` | Search using tag filters |

The key tool for citation management is `zotero_get_item_metadata` with `format="bibtex"`, which returns a properly formatted BibTeX entry including the Better BibTeX citation key.

## Alternative Zotero MCP Servers

| Project | Stars | Notes |
|---------|-------|-------|
| [54yyyu/zotero-mcp](https://github.com/54yyyu/zotero-mcp) | ~1400 | Most popular; local + web API; BibTeX export; semantic search |
| [cookjohn/zotero-mcp](https://github.com/cookjohn/zotero-mcp) | ~360 | Zotero plugin (TypeScript); deep integration |
| [kaliaboi/mcp-zotero](https://github.com/kaliaboi/mcp-zotero) | ~140 | TypeScript; Zotero Web API |
| [kujenga/zotero-mcp](https://github.com/kujenga/zotero-mcp) | ~130 | Python; Zotero Web API |
| [papersgpt/papersgpt-for-zotero](https://github.com/papersgpt/papersgpt-for-zotero) | ~2100 | Zotero plugin with MCP + multi-model AI |

## Recommended Workflow

For this Quarto manuscript project, the recommended workflow is:

1. **Install zotero-mcp** and **Better BibTeX** in Zotero
2. **Configure VS Code** with the MCP server (see setup above)
3. **Use Copilot Chat in agent mode** to:
   - Ask it to search your library: *"Find the Yellott 1977 paper on Luce's choice axiom in my Zotero"*
   - Ask it to add citations: *"Add @yellottRelationshipLucesChoice1977 to the discussion section and make sure it's in references.bib"*
   - Ask it to bulk-add references: *"Search my Zotero for all papers on random utility models and add their BibTeX entries to references.bib"*

4. For the **GitHub Copilot coding agent** (web-based), keep `references.bib` up to date via Better BibTeX auto-export so the agent can reference existing citations when making edits.

## Domains That Could Not Be Accessed

The following documentation sites could not be accessed during this research. If these contain important information, consider whitelisting them:

- `https://retorque.re/zotero-better-bibtex/` — Better BibTeX documentation (for CAYW / citation key configuration details)
- `https://code.visualstudio.com/docs/copilot/chat/mcp-servers` — VS Code Copilot MCP server configuration docs
- `https://stevenyuyy.us/zotero-mcp/` — zotero-mcp full documentation site
