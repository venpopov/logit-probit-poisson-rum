# Quick Answer: Connecting Zotero to GitHub Copilot Coding Agent

**Yes, you can connect your Zotero library to GitHub Copilot coding agent!**

The previous documentation was incorrect. GitHub Copilot coding agent **DOES** support custom MCP servers, and zotero-mcp **DOES** support Web API access. These can be combined to achieve what you want.

## What Changed

The original PR #10 incorrectly stated:
- ❌ "GitHub Copilot coding agent **cannot** connect to Zotero"
- ❌ "No custom MCP server support"

The corrected information:
- ✅ GitHub Copilot coding agent **CAN** connect to Zotero via Web API
- ✅ Repository administrators can configure custom MCP servers
- ✅ zotero-mcp supports both local and web API modes

## How to Set It Up

### Step 1: Get Zotero API Credentials

1. Go to https://www.zotero.org/settings/keys
2. Create a new private key with "Read Only" access to your library
3. Copy your API key and user ID (library ID)

### Step 2: Add Secrets to Your Repository

1. Go to your repo → Settings → Secrets and variables → Codespaces
2. Add two secrets:
   - `COPILOT_MCP_ZOTERO_API_KEY` = your Zotero API key
   - `COPILOT_MCP_ZOTERO_LIBRARY_ID` = your Zotero user ID

### Step 3: Configure the MCP Server

1. Go to your repo → Settings → Copilot → Coding agent
2. Add this JSON configuration:

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

3. Click "Save"

### Step 4: Use It!

Now you can open issues or PRs and ask the coding agent to:
- *"Search my Zotero library for papers by McFadden and add citations to references.bib"*
- *"Find papers on random utility models in my Zotero and cite them in the introduction"*

## How It Works

1. **Your Zotero library** syncs to zotero.org (automatically if you have sync enabled)
2. **GitHub Copilot coding agent** runs in a cloud sandbox with access to the zotero-mcp server
3. **zotero-mcp** uses your Web API credentials to access your library
4. **The agent** can search your library, get BibTeX entries, and update references.bib

## Sources

This solution combines two pieces of information you discovered:

1. **GitHub's MCP support**: https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/extend-coding-agent-with-mcp
2. **zotero-mcp Web API mode**: https://github.com/54yyyu/zotero-mcp#using-web-api-instead-of-local-api

## For Local Development (VS Code)

For local development, you can also use the `.vscode/mcp.json` configuration that's now in this repo. See `.vscode/README.md` for setup instructions.

## Full Documentation

For complete details, see `/meta/zotero-mcp-integration.md` which has been updated with the correct information.
