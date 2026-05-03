# AI-SDLC Skills Library - Quick Start Guide

**Version:** 2.0.0
**Last Updated:** 2026-05-03

---

## 🚀 Get Started in 3 Steps

### Step 1: Install Skills (2 minutes)

```bash
# One-command installation
curl -sSL https://raw.githubusercontent.com/itsatif/hyperbrain-skills/main/install.sh | bash

# Restart your AI assistant
# Skills are now active!
```

**What just happened:**
- ✅ Installed 18 technical skills
- ✅ Installed 4 knowledge bases (48,803 words)
- ✅ Configured AI Superpowers brainstorming
- ✅ Set up multi-assistant support

### Step 2: Setup MCP Servers (5 minutes)

```bash
# Navigate to MCP setup
cd ~/.claude/skills/mcp-setup

# Run automated setup
./setup-mcp.sh

# Enter your API tokens when prompted:
# - Notion (optional)
# - Figma (optional)
# - GitHub (recommended)
# - Slack (optional)
```

**What just happened:**
- ✅ Created `~/.claude/.env` for secure token storage
- ✅ Installed MCP servers globally
- ✅ Updated Claude settings with MCP configurations
- ✅ Set proper file permissions (600)

### Step 3: Start Using AI Superpowers! (Immediate)

```bash
# Open Claude Code and start working
# AI Superpowers activates automatically!

# Example requests:
"Add a new widget showing real-time SEC to the dashboard"
"Create a PRD for the mobile app feature"
"Generate E2E tests for the login flow"
"Review this PR and suggest improvements"
```

**What just happened:**
- ✅ AI automatically activates brainstorming
- ✅ AI asks clarifying questions
- ✅ AI generates multiple approaches
- ✅ AI selects appropriate skills
- ✅ AI follows your coding patterns
- ✅ AI generates tests automatically
- ✅ AI accesses external services (via MCP)

---

## 📚 What You Now Have

### Knowledge Bases (48,803 words)
- **DeJoule Organizational KB** - Complete ecosystem
- **Backend KB (jt-api-v2)** - API architecture
- **IoT Platform KB** - MQTT, InfluxDB, devices
- **QA Automation KB** - Test generation

### Technical Skills (18 Skills)
- **Frontend:** Angular, React, Vue, Next.js, State Management
- **Backend:** Node.js, Python, Go, Database Patterns
- **IoT:** Architecture, MQTT, Kafka, InfluxDB
- **Testing:** TDD, Playwright, QA Automation
- **Workflow:** Superpowers Brainstorming

### MCP Integration (7 Servers)
- **Notion** - Document management
- **Figma** - Design collaboration
- **GitHub** - Repository management
- **Slack** - Team communication
- **PostgreSQL** - Database queries
- **MongoDB** - NoSQL operations
- **Redis** - Cache operations

---

## 🎯 Common Use Cases

### Use Case 1: Create a New Feature

```bash
You: "Add user authentication to my Angular app"

AI: [Activates Superpowers Brainstorming]
    "Let me understand your authentication needs:
    1. What authentication methods?
    2. Any social logins needed?
    3. Role-based permissions?
    4. Compliance requirements?
    5. Session management?"

You: "Email/password with JWT, role-based access"

AI: [Selects Angular Patterns + TDD Workflow skills]
    "Perfect! I'll create:
    - Auth service (login, logout, token refresh)
    - Route guards (protected routes)
    - JWT interceptor (attach tokens to API calls)
    - Role-based directives (UI access control)
    - Unit tests (80%+ coverage)
    - E2E tests (Playwright)"
```

### Use Case 2: Debug an Issue

```bash
You: "The MQTT connection is dropping frequently"

AI: [Activates IoT Knowledge Base]
    "Based on IoT platform architecture:
    - Check MQTT broker logs
    - Verify QoS levels (telemetry uses QoS 0)
    - Check iot-application service health
    - Review InfluxDB write performance

    Common causes:
    1. High message throughput → Buffer full
    2. Network instability → Increase keepalive
    3. InfluxDB slow writes → Check batch size"
```

### Use Case 3: Generate Documentation

```bash
You: "Create a PRD for the new mobile app in Notion"

AI: [Activates Notion MCP + Superpowers Brainstorming]
    "I'll create a PRD in Notion with:
    - Feature overview
    - User stories
    - Technical requirements
    - API endpoints
    - UI mockups (from Figma)
    - Success metrics

    [Creates page in Notion]
    ✅ PRD created: https://notion.so/prd-mobile-app"
```

### Use Case 4: Code Review

```bash
You: "Review this PR for the new API endpoint"

AI: [Activates Backend Knowledge Base + Code Review skill]
    "Checking against jt-api-v2 patterns:
    ✅ Controller layer present
    ✅ Service layer present
    ✅ Repository layer present
    ✅ DTO transformation correct
    ❌ Missing error handling for InfluxDB timeout

    Here's the fix:
    [Generates code following jt-api-v2 patterns]"
```

---

## 🔧 Configuration Files

### ~/.claude/.env
```bash
# MCP server tokens (created by setup-mcp.sh)
GITHUB_TOKEN=ghp_your_token_here
NOTION_API_KEY=your_notion_token_here
FIGMA_ACCESS_TOKEN=your_figma_token_here
SLACK_BOT_TOKEN=xoxb-your-slack-token
```

### ~/.claude/settings.json
```json
{
  "mcpServers": {
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

---

## 📖 Learn More

### Detailed Documentation
- **[README.md](README.md)** - Complete library overview
- **[INSTALL.md](INSTALL.md)** - Installation guide
- **[KNOWLEDGE_INDEX.md](KNOWLEDGE_INDEX.md)** - Knowledge base index
- **[COMPLETE_LIBRARY_SUMMARY.md](COMPLETE_LIBRARY_SUMMARY.md)** - Full summary

### Skill-Specific Documentation
- **[superpowers-brainstorm/SKILL.md](superpowers-brainstorm/SKILL.md)** - AI planning framework
- **[tdd-workflow/SKILL.md](tdd-workflow/SKILL.md)** - Test-driven development
- **[mcp-setup/README.md](mcp-setup/README.md)** - MCP configuration

### Knowledge Bases
- **[dejoule-knowledge-base/SKILL.md](dejoule-knowledge-base/SKILL.md)** - Org knowledge
- **[backend-knowledge-base/SKILL.md](backend-knowledge-base/SKILL.md)** - Backend patterns
- **[iot-knowledge-base/SKILL.md](iot-knowledge-base/SKILL.md)** - IoT architecture
- **[qa-automation/SKILL.md](qa-automation/SKILL.md)** - Test automation

---

## ✅ Verification Checklist

After installation, verify:

- [ ] Skills installed: `ls ~/.claude/skills/`
- [ ] Knowledge bases loaded: Ask AI "What do you know about DeJoule?"
- [ ] Superpowers active: Ask any question, AI should brainstorm first
- [ ] MCP servers configured: `cat ~/.claude/settings.json | grep mcpServers`
- [ ] Tokens set: `cat ~/.claude/.env`
- [ ] AI assistant restarted

---

## 🆘 Troubleshooting

### Issue: Skills not loading

**Solution:**
```bash
# Verify skills are installed
ls ~/.claude/skills/

# Restart AI assistant completely

# Test with simple question
"What skills do you have available?"
```

### Issue: MCP servers not working

**Solution:**
```bash
# Verify tokens are set
cat ~/.claude/.env

# Test connections
curl -H "Authorization: Bearer $GITHUB_TOKEN" https://api.github.com/user

# Check Claude settings
cat ~/.claude/settings.json | grep -A 10 mcpServers

# Restart AI assistant
```

### Issue: AI not using knowledge base

**Solution:**
```bash
# Ask AI to activate knowledge base
"Activate DeJoule Knowledge Base"

# Verify knowledge base files exist
ls ~/.claude/skills/dejoule-knowledge-base/

# Check knowledge graph
cat ~/.claude/skills/dejoule-knowledge-base/KNOWLEDGE_GRAPH.json
```

---

## 🎉 You're Ready!

Your AI assistant now has:
- ✅ Complete organizational context
- ✅ AI-powered brainstorming and planning
- ✅ Technical skills for all domains
- ✅ Automated test generation
- ✅ Access to external services (Notion, Figma, GitHub, Slack)
- ✅ Database query capabilities
- ✅ Security best practices

**Start building with AI superpowers!** 🚀

---

## 📞 Support

**Issues:** https://github.com/itsatif/hyperbrain-skills/issues
**Author:** Atif Salafi <atif8486@gmail.com>
**Organization:** DeJoule / Smart Joules
