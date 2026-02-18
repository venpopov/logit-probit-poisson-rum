# Connecting Zotero to AI Coding Agents via MCP

## Summary

Yes, it is possible to connect your Zotero library to AI assistants using the **Model Context Protocol (MCP)**. The most mature solution is the [zotero-mcp](https://github.com/54yyyu/zotero-mcp) server by 54yyyu, which exposes your Zotero library to any MCP-compatible AI client. This enables AI agents to search your library, retrieve metadata, and **export BibTeX entries** — which is exactly what's needed to populate `references.bib`.

**Key capabilities:**
- ✅ **VS Code Copilot Chat** - Works with local or web API
- ✅ **GitHub Copilot Coding Agent** - Works via web API and repository MCP configuration
- ✅ **Claude Desktop** - Works with local or web API  
- ✅ **Other MCP clients** - ChatGPT, Cursor, Cherry Studio, Chorus, etc.

## Supported Platforms and Clients

### 1. VS Code Copilot Chat + zotero-mcp (Local — Recommended)

VS Code Copilot [supports MCP servers](https://code.visualstudio.com/docs/copilot/chat/mcp-servers) natively. MCP follows a client-server architecture where VS Code acts as the MCP client, connecting to MCP servers that provide tools. You can configure `zotero-mcp` as a local stdio MCP server, and then ask Copilot to:

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

3. Add to your VS Code MCP configuration. You have two options:

   **Option A — Workspace config** (`.vscode/mcp.json`, shareable via source control):
   ```json
   {
     "servers": {
       "zotero": {
         "command": "zotero-mcp",
         "env": {
           "ZOTERO_LOCAL": "true"
         }
       }
     }
   }
   ```

   **Option B — User profile** (available across all workspaces):
   Run `MCP: Add Server` from the Command Palette, provide the server info, and select **Global**.

   You can also install from the command line:
   ```bash
   code --add-mcp "{\"name\":\"zotero\",\"command\":\"zotero-mcp\",\"env\":{\"ZOTERO_LOCAL\":\"true\"}}"
   ```

4. Make sure Zotero 7+ is running locally with the local API enabled:
   - Open Zotero → Edit → Preferences → Advanced
   - Check "Allow other applications on this computer to communicate with Zotero"

5. (Recommended) Install the [Better BibTeX](https://retorque.re/zotero-better-bibtex/) plugin in Zotero for consistent citation keys. Note: as of Zotero 8, items have a Zotero-native citation key field that replaces the BBT citation key field, and keys now sync natively.

6. In VS Code, open Copilot Chat in **Agent mode** and ask:
   > "Search my Zotero library for papers by McFadden on conditional logit and add the BibTeX entry to references.bib"

   MCP tools are automatically invoked based on the tool description and the task. You can also reference tools directly with `#zotero_search_items` etc.

> **Note on trust:** VS Code will prompt you to confirm that you trust the MCP server when you start it for the first time. Local MCP servers run code on your machine, so only use servers from trusted sources.

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

## GitHub Copilot Coding Agent (github.com web-based)

### ✅ What DOES Work: Web API Configuration

The **GitHub Copilot coding agent** that runs on github.com (the agent that processes issues and creates PRs in a sandboxed cloud environment) **CAN** connect to your Zotero library using the **Zotero Web API** via custom MCP server configuration.

As of early 2026, GitHub allows **repository administrators to configure custom MCP servers** for the Copilot coding agent. This is done via JSON configuration in the repository settings. Combined with zotero-mcp's Web API support, this enables the coding agent to:

- Search your Zotero library for papers by title, author, or keywords
- Retrieve BibTeX-formatted citation data
- Insert citation keys and populate `references.bib`

**Setup steps:**

1. **Get your Zotero Web API credentials:**
   - Go to https://www.zotero.org/settings/keys
   - Click "Create new private key"
   - Give it a name (e.g., "GitHub Copilot MCP")
   - Under "Personal Library", select "Allow library access" with "Read Only" permission
   - Click "Save Key" and copy your API key
   - Your user ID is shown on the same page (e.g., `123456`)

2. **Configure repository secrets:**
   - Go to your repository on GitHub → Settings → Secrets and variables → Codespaces
   - Click "New repository secret"
   - Add `COPILOT_MCP_ZOTERO_API_KEY` with your Zotero API key as the value
   - Add `COPILOT_MCP_ZOTERO_LIBRARY_ID` with your Zotero user ID as the value

3. **Configure MCP server for Copilot coding agent:**
   - Go to your repository → Settings → Copilot → Coding agent
   - In the "MCP configuration" section, add:
   ```json
   {
     "mcpServers": {
       "zotero": {
         "type": "local",
         "command": "npx",
         "args": ["-y", "zotero-mcp@latest"],
         "env": {
           "ZOTERO_API_KEY": "COPILOT_MCP_ZOTERO_API_KEY",
           "ZOTERO_LIBRARY_ID": "COPILOT_MCP_ZOTERO_LIBRARY_ID",
           "ZOTERO_LIBRARY_TYPE": "user"
         },
         "tools": ["zotero_search_items", "zotero_get_item_metadata", "zotero_get_collections", "zotero_get_tags", "zotero_get_recent"]
       }
     }
   }
   ```
   - Click "Save"
   
   > **Note on "type: local"**: The type is "local" because the MCP server runs locally in the coding agent's sandbox (via `npx`). The "local" refers to how the MCP server is executed (as a local process), not where the Zotero data comes from. The server itself then connects to the Zotero Web API using your credentials.

4. **Use the coding agent:**
   - Open an issue or PR and ask the coding agent to:
     - *"Search my Zotero library for papers by McFadden on conditional logit and add the BibTeX entry to references.bib"*
     - *"Find papers on random utility models in my Zotero library and cite them in the introduction"*

> **Note:** The coding agent runs in a cloud sandbox, so it uses the **Zotero Web API** (not local API). Your Zotero desktop application does not need to be running, but your library must be synced to zotero.org.

> **Security:** Only enable read-only tools (`zotero_search_items`, `zotero_get_item_metadata`, etc.). Avoid `*` (all tools) to prevent write operations.

### Alternative: Better BibTeX Auto-Export

If you prefer not to configure the Web API, you can use Better BibTeX's [auto-export](https://retorque.re/zotero-better-bibtex/exporting/auto/) feature to keep `references.bib` automatically synced:

1. Right-click your collection in Zotero → "Export Collection…"
2. Select "Better BibTeX" translator and check `Keep updated`
3. Export to your repo's `references.bib`
4. (Optional) Enable git integration: `git config zotero.betterbibtex.push true` in your repo

This keeps `references.bib` in your GitHub repo always up to date, so the coding agent can *read* existing citations when making edits (but cannot search your library or add new citations autonomously).

## Better BibTeX CAYW (Cite As You Write)

Beyond the MCP approach, Better BibTeX provides a local HTTP API for citation picking at `http://127.0.0.1:23119/better-bibtex/cayw`. This is the same API used by the existing [VS Code Citation Picker for Zotero](https://marketplace.visualstudio.com/items?itemName=mblode.zotero) extension. Key features:

- **Multiple output formats**: `pandoc` (with optional brackets), `natbib`, `biblatex`, `mmd`, `typst`, `translate` (full BibTeX export), and more
- **Programmatic access**: The URL can be called via `curl` or any HTTP client
- **Full BibTeX export**: Use `format=translate&translator=bibtex` to get complete BibTeX entries
- **Pandoc citations**: Use `format=pandoc&brackets=1` to get `[@citekey]` format directly

Example to get a pandoc citation key:
```bash
curl -s "http://127.0.0.1:23119/better-bibtex/cayw?format=pandoc&brackets=1"
```

Example to export full BibTeX for selected items:
```bash
curl -s "http://127.0.0.1:23119/better-bibtex/cayw?format=translate&translator=bibtex"
```

This API could theoretically be integrated into a custom MCP server or VS Code extension that combines citation picking with AI-powered insertion.

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

### For Local Development (VS Code):

1. **Install zotero-mcp** and **Better BibTeX** in Zotero
2. **Configure VS Code** with the MCP server in `.vscode/mcp.json` (see setup above)
3. **Use Copilot Chat in agent mode** to:
   - Ask it to search your library: *"Find the Yellott 1977 paper on Luce's choice axiom in my Zotero"*
   - Ask it to add citations: *"Add @yellottRelationshipLucesChoice1977 to the discussion section and make sure it's in references.bib"*
   - Ask it to bulk-add references: *"Search my Zotero for all papers on random utility models and add their BibTeX entries to references.bib"*

### For GitHub Copilot Coding Agent:

1. **Set up Web API credentials** (see GitHub Copilot Coding Agent section above)
2. **Configure repository secrets** with `COPILOT_MCP_ZOTERO_API_KEY` and `COPILOT_MCP_ZOTERO_LIBRARY_ID`
3. **Add MCP configuration** in repository settings (Settings → Copilot → Coding agent)
4. **Create issues or PRs** and ask the coding agent to search your library and add citations

### For Both:

- **Set up Better BibTeX auto-export with git push** for your `references.bib`:
  - Right-click your collection → Export Collection → Better BibTeX → check `Keep updated`
  - Export to your repo's `references.bib`
  - Run `git config zotero.betterbibtex.push true` in your repo
  - Now BBT will auto-commit and push `references.bib` whenever citations change
  - This keeps `references.bib` always up to date for all environments

## Additional Resources

- [GitHub Docs: Extend Coding Agent with MCP](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/extend-coding-agent-with-mcp)
- [GitHub Docs: MCP and GitHub Copilot Coding Agent](https://docs.github.com/en/copilot/concepts/coding-agent/mcp-and-coding-agent)
- [zotero-mcp GitHub Repository](https://github.com/54yyyu/zotero-mcp)
- [zotero-mcp Documentation](https://stevenyuyy.us/zotero-mcp/)
- [VS Code MCP Documentation](https://code.visualstudio.com/docs/copilot/chat/mcp-servers)
- [Better BibTeX Documentation](https://retorque.re/zotero-better-bibtex/)
- [Model Context Protocol Specification](https://modelcontextprotocol.io/introduction)
