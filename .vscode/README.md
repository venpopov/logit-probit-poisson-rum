# VS Code MCP Configuration

This directory contains the Model Context Protocol (MCP) configuration for VS Code Copilot Chat.

## Zotero MCP Server

The `mcp.json` file configures the zotero-mcp server for local Zotero access.

### Prerequisites

1. **Install zotero-mcp:**
   ```bash
   pip install git+https://github.com/54yyyu/zotero-mcp.git
   # or
   uv tool install "git+https://github.com/54yyyu/zotero-mcp.git"
   ```
   
   **Note:** The `zotero-mcp` command must be in your PATH. If using `pip install`, ensure your Python scripts directory is in PATH. With `uv tool install`, this is handled automatically.

2. **Configure zotero-mcp:**
   ```bash
   zotero-mcp setup
   ```

3. **Enable Zotero local API:**
   - Open Zotero 7+ → Edit → Preferences → Advanced
   - Check "Allow other applications on this computer to communicate with Zotero"

4. **Install Better BibTeX (recommended):**
   - Download from https://retorque.re/zotero-better-bibtex/
   - Install in Zotero for consistent citation keys

### Usage

Once configured, you can use VS Code Copilot Chat in agent mode to:

- Search your Zotero library: *"Find papers on random utility models in my Zotero"*
- Add citations: *"Add citation for McFadden 1974 to references.bib"*
- Get BibTeX entries: *"Export BibTeX for papers on conditional logit"*

### Switching to Web API

To use the Zotero Web API instead of local access, update `mcp.json`:

```json
{
  "servers": {
    "zotero": {
      "command": "zotero-mcp",
      "env": {
        "ZOTERO_API_KEY": "your-api-key-here",
        "ZOTERO_LIBRARY_ID": "your-library-id",
        "ZOTERO_LIBRARY_TYPE": "user"
      }
    }
  }
}
```

Get your API key from: https://www.zotero.org/settings/keys

### More Information

See `/meta/zotero-mcp-integration.md` for detailed setup instructions and documentation.
