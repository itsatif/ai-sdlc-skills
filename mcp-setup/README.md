# MCP Configuration Setup

**Part of AI-SDLC Skills Library**

**Purpose:** Setup and configure MCP (Model Context Protocol) servers for AI assistants with secure token management

**Version:** 1.0.0
**Last Updated:** 2026-05-03

---

## 🎯 Overview

This skill provides a complete setup system for MCP servers, enabling AI assistants to:
- Access external services (Notion, Figma, GitHub, Slack)
- Query databases (PostgreSQL, MongoDB, Redis)
- Perform actions on behalf of users
- Extend AI capabilities beyond base functionality

---

## 🚀 Quick Start

### Option 1: Automated Setup (Recommended)

```bash
# Navigate to mcp-setup directory
cd /path/to/hyperbrain-skills/mcp-setup

# Run automated setup script
./setup-mcp.sh
```

The script will:
1. Create `~/.claude/.env` file for storing tokens
2. Prompt you for API tokens
3. Install MCP servers globally
4. Update Claude settings with MCP configurations
5. Set proper file permissions (600)

### Option 2: Manual Setup

```bash
# 1. Create .env file
cp .env.example ~/.claude/.env

# 2. Edit and add your tokens
nano ~/.claude/.env

# 3. Set proper permissions
chmod 600 ~/.claude/.env

# 4. Install MCP servers
npm install -g @modelcontextprotocol/server-notion
npm install -g @modelcontextprotocol/server-figma
npm install -g @modelcontextprotocol/server-github
npm install -g @modelcontextprotocol/server-slack
npm install -g @modelcontextprotocol/server-postgres

# 5. Update Claude settings manually
# Edit ~/.claude/settings.json and add MCP configurations
```

---

## 📦 Supported MCP Servers

### Service Integration MCPs

| MCP Server | Purpose | Documentation |
|------------|---------|---------------|
| **Notion** | Document management, wikis, PRDs | https://developers.notion.com |
| **Figma** | Design system collaboration | https://www.figma.com/developers/api |
| **GitHub** | Repository management, PRs, issues | https://docs.github.com/en/rest |
| **Slack** | Team communication, notifications | https://api.slack.com |

### Database MCPs

| MCP Server | Purpose | Documentation |
|------------|---------|---------------|
| **PostgreSQL** | Relational database queries | https://www.postgresql.org/docs |
| **MySQL** | MySQL database access | https://dev.mysql.com/doc |
| **MongoDB** | NoSQL document operations | https://docs.mongodb.com |
| **Redis** | Key-value cache operations | https://redis.io/documentation |

### Custom MCPs

| MCP Server | Purpose |
|------------|---------|
| **Morpheus** | Knowledge graph queries |
| **Data Proxy** | Secure database/API access |

---

## 🔑 Getting API Tokens

### Notion

1. Go to https://www.notion.so/my-integrations
2. Click "New integration"
3. Give it a name (e.g., "AI Assistant")
4. Select workspace
5. Copy "Integration Token" (Internal Integration Secret)
6. Open your Notion database
7. Click "..." → "Add connections" → Select your integration
8. Copy database ID from URL: `https://notion.so/database/{DATABASE_ID}?v=...`

### Figma

1. Go to https://www.figma.com/settings
2. Scroll to "Personal Access Tokens"
3. Click "Create new token"
4. Give it a name (e.g., "AI Assistant")
5. Copy the token
6. Open your Figma file
7. Copy file ID from URL: `https://figma.com/file/{FILE_KEY}/...`

### GitHub

1. Go to https://github.com/settings/tokens
2. Click "Generate new token" → "Generate new token (classic)"
3. Select scopes:
   - `repo` (Full control of private repositories)
   - `workflow` (Update GitHub Action workflows)
   - `read:org` (Read org and team membership)
4. Copy token

**Security:** GitHub tokens expire after 90 days. Set a reminder to rotate them.

### Slack

1. Go to https://api.slack.com/apps
2. Click "Create New App"
3. Select "From scratch"
4. Give it a name and select workspace
5. Go to "OAuth & Permissions"
6. Add scopes:
   - `chat:write` (Send messages)
   - `channels:read` (View channels)
   - `channels:history` (Read messages)
7. Install app to workspace
8. Copy "Bot User OAuth Token" (starts with `xoxb-`)
9. Get channel ID:
   - Right-click channel → "Copy Link"
   - Extract ID from URL: `https://company.slack.com/archives/C1234567890`

---

## 🔐 Security Best Practices

### 1. Never Commit Access Tokens

**Add to `.gitignore`:**
```bash
# .gitignore
.env
.env.local
.env.*.local
*.pem
*.key
credentials.json
```

### 2. Use Environment-Specific Tokens

**Development:**
```bash
# .env.development
GITHUB_TOKEN=ghp_dev_token_with_read_only_scope
```

**Production:**
```bash
# .env.production
GITHUB_TOKEN=ghp_prod_token_with_full_scope
```

### 3. Set Proper File Permissions

```bash
# Restrict .env file to owner only
chmod 600 ~/.claude/.env

# Verify permissions
ls -la ~/.claude/.env
# Should show: -rw------- (600)
```

### 4. Token Rotation Schedule

| Service | Rotation Frequency |
|---------|-------------------|
| GitHub | Every 90 days (forced) |
| Slack | Every year |
| Notion | If compromised |
| Figma | If compromised |

### 5. Use Token Scopes Minimally

Only grant the minimum permissions needed:

**GitHub Token Scopes:**
- Development: `repo:status`, `read:org`
- Production: `repo`, `workflow`, `read:org`

**Slack Bot Scopes:**
- Notifications only: `chat:write`
- Full access: `chat:write`, `channels:read`, `channels:history`

---

## 🧪 Testing MCP Connections

### Test Notion Connection

```bash
curl -X GET https://api.notion.com/v1/users/me \
  -H "Authorization: Bearer $NOTION_API_KEY" \
  -H "Notion-Version: 2022-06-28"
```

**Expected output:** User object with name and email

### Test Figma Connection

```bash
curl -X GET "https://api.figma.com/v1/files/$FIGMA_FILE_KEY" \
  -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN"
```

**Expected output:** File object with name and lastModified

### Test GitHub Connection

```bash
# Using gh CLI
gh auth status

# Using curl
curl -X GET https://api.github.com/user \
  -H "Authorization: Bearer $GITHUB_TOKEN"
```

**Expected output:** GitHub user object

### Test Slack Connection

```bash
curl -X POST "https://slack.com/api/auth.test" \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN"
```

**Expected output:** `{"ok": true, "url": "..."}`

---

## 📝 Claude Configuration

### settings.json Structure

```json
{
  "mcpServers": {
    "notion": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-notion"],
      "env": {
        "NOTION_API_KEY": "${NOTION_API_KEY:}",
        "NOTION_DATABASE_ID": "${NOTION_DATABASE_ID:}"
      }
    },
    "figma": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-figma"],
      "env": {
        "FIGMA_ACCESS_TOKEN": "${FIGMA_ACCESS_TOKEN:}",
        "FIGMA_FILE_KEY": "${FIGMA_FILE_KEY:}"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN:}"
      }
    }
  }
}
```

### Environment Variable Syntax

- `${VARIABLE_NAME:}` - Use environment variable, default to empty if not set
- `${VARIABLE_NAME:default_value}` - Use environment variable, default to value if not set

---

## 🔍 Troubleshooting

### Issue: MCP Server Not Starting

**Symptoms:** AI assistant doesn't show MCP tools

**Solution:**
```bash
# Check if MCP server is installed
npm list -g @modelcontextprotocol/server-notion

# Reinstall if missing
npm install -g @modelcontextprotocol/server-notion

# Check Claude settings
cat ~/.claude/settings.json | grep -A 10 "mcpServers"

# Restart Claude Code completely
```

### Issue: Authentication Failed

**Symptoms:** 401 Unauthorized errors

**Solution:**
```bash
# Verify token is set
echo $NOTION_API_KEY

# Test token manually
curl -X GET https://api.notion.com/v1/users/me \
  -H "Authorization: Bearer $NOTION_API_KEY" \
  -H "Notion-Version: 2022-06-28"

# Check token has correct permissions
# Revisit service documentation for required scopes
```

### Issue: Environment Variables Not Loading

**Symptoms:** MCP servers can't access tokens

**Solution:**
```bash
# Verify .env file exists
ls -la ~/.claude/.env

# Check file permissions
chmod 600 ~/.claude/.env

# Verify .env format (no spaces around =)
cat ~/.claude/.env

# Restart Claude Code
# Environment variables are loaded at startup
```

### Issue: GitHub Token Expired

**Symptoms:** 401 Unauthorized for GitHub operations

**Solution:**
```bash
# Generate new token at https://github.com/settings/tokens
# Update .env file
sed -i.bak 's/^GITHUB_TOKEN=.*/GITHUB_TOKEN=ghp_new_token_here/' ~/.claude/.env

# Restart Claude Code
```

---

## 📚 Usage Examples

### Example 1: Create PRD in Notion

```bash
# User asks AI
User: "Create a PRD for the new SEC widget in Notion"

# AI activates Notion MCP
AI: "I'll create a PRD in Notion based on DeJoule KB..."

# Result: New page created in Notion with:
# - Feature description
# - Technical requirements
# - API endpoints
# - UI mockups reference
```

### Example 2: Generate Code from Figma

```bash
# User asks AI
User: "Generate Angular component from this Figma design"

# AI activates Figma MCP
AI: "I'll read the Figma file and generate code..."

# Result: Angular component created with:
# - Container/Presenter pattern
# - Responsive layout
# - Design tokens from Figma
```

### Example 3: Update GitHub Issue

```bash
# User asks AI
User: "Update the GitHub issue with implementation status"

# AI activates GitHub MCP
AI: "I'll update the issue with current progress..."

# Result: Issue updated with:
# - Implementation notes
# - Test coverage status
# - Deployment checklist
```

---

## 🚀 Advanced Usage

### Multiple GitHub Repositories

```bash
# .env file
GITHUB_TOKEN=ghp_your_token
GITHUB_REPOSITORY_MAIN=owner/main-repo
GITHUB_REPOSITORY_DOCS=owner/docs-repo
```

```json
// settings.json
{
  "mcpServers": {
    "github-main": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN:}",
        "GITHUB_REPOSITORY": "${GITHUB_REPOSITORY_MAIN:}"
      }
    },
    "github-docs": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN:}",
        "GITHUB_REPOSITORY": "${GITHUB_REPOSITORY_DOCS:}"
      }
    }
  }
}
```

### Multiple Figma Files

```json
{
  "mcpServers": {
    "figma-design-system": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-figma"],
      "env": {
        "FIGMA_ACCESS_TOKEN": "${FIGMA_ACCESS_TOKEN:}",
        "FIGMA_FILE_KEY": "${FIGMA_DESIGN_SYSTEM_KEY:}"
      }
    },
    "figma-ui-kit": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-figma"],
      "env": {
        "FIGMA_ACCESS_TOKEN": "${FIGMA_ACCESS_TOKEN:}",
        "FIGMA_FILE_KEY": "${FIGMA_UI_KIT_KEY:}"
      }
    }
  }
}
```

---

## ✅ Setup Checklist

Before using MCP servers:

- [ ] .env file created in ~/.claude/
- [ ] Access tokens configured in .env
- [ ] File permissions set to 600
- [ ] Claude settings.json updated with MCP servers
- [ ] MCP servers installed via npm
- [ ] Connections tested successfully
- [ ] Claude Code restarted to load MCP servers
- [ ] .env added to .gitignore

---

## 📞 Support

**Documentation:** See SKILL.md for detailed usage instructions
**Issues:** https://github.com/itsatif/hyperbrain-skills/issues

---

## 🎉 Summary

This MCP setup system enables AI assistants to:
- ✅ Access external services (Notion, Figma, GitHub, Slack)
- ✅ Query databases (PostgreSQL, MongoDB, Redis)
- ✅ Perform actions with proper authentication
- ✅ Extend capabilities securely

**Run the automated setup script to get started:**
```bash
./setup-mcp.sh
```

**Your AI assistant will have superpowers!** 🚀
