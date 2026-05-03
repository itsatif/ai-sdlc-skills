# Local Knowledge Base Generator - Quick Reference

**Part of HyperBrain Skills Library**

**Version:** 1.0.0  
**Last Updated:** 2026-05-04

---

## 🎯 What is Local KB?

Automatically generate **compact, queryable knowledge bases** for any repository using **Graphify**, enabling AI agents to understand your codebase with **71.5x fewer tokens**.

### Key Benefits

✅ **71.5x Token Reduction** - Graphify's AST extraction vs raw files  
✅ **Instant Context** - Complete architecture in seconds  
✅ **Auto-Generated** - One command creates entire KB  
✅ **Always Updated** - Git hooks keep KB in sync  
✅ **Repository-Agnostic** - Works with any codebase  
✅ **Powered by Graphify** - Production-ready, battle-tested

---

## 🚀 Quick Start

### Prerequisites

Install Graphify (the engine behind Local KB):

```bash
pip install graphifyy
```

### Basic Usage

```bash
# Navigate to your repository
cd ~/workspace/my-project

# Generate local knowledge base using Graphify
/local-kb generate

# View the generated KB
cat .hyperbrain-kb/GRAPH_REPORT.md

# Open interactive visualization
open .hyperbrain-kb/graph.html
```

### Query the Knowledge Base

```bash
# Ask questions about the codebase
cd .hyperbrain-kb
graphify query "What is the project architecture?"
graphify query "List all API endpoints"
graphify query "How does authentication work?"

# Trace execution paths
graphify path "AuthController" to "DatabaseService"
```

---

## 📁 Knowledge Base Structure

```
.hyperbrain-kb/
├── graph.html                # Interactive knowledge graph visualization
├── graph.json                # Machine-readable graph (nodes, edges)
├── GRAPH_REPORT.md           # Human-readable architecture report
├── METADATA.json             # KB metadata and statistics
└── README.md                 # Quick start guide
```

---

## 💡 Common Workflows

### Workflow 1: New Repository Setup

```bash
# Clone a new repository
git clone https://github.com/org/new-project.git
cd new-project

# Generate knowledge base
/local-kb generate

# Review generated KB
cat .hyperbrain-kb/REPOSITORY_OVERVIEW.md

# Commit KB to repository
git add .hyperbrain-kb/
git commit -m "docs: add HyperBrain knowledge base"
git push origin main
```

### Workflow 2: Update Existing KB

```bash
# After making significant changes
git add .
git commit -m "feat: add new authentication system"

# Auto-update KB (via git hook)
# OR manually:
/local-kb update

# Commit updated KB
git add .hyperbrain-kb/
git commit -m "docs: update knowledge base"
```

### Workflow 3: Query for Context

```bash
# AI agents can query KB for context
/local-kb query "What is the authentication flow?"

# KB responds with structured context including:
# - Step-by-step flow
# - Files involved
# - Classes and functions
# - Dependencies
```

---

## 📊 Token Savings

### Without Local KB

```
AI Agent reads entire codebase:
- Frontend: 200,000 tokens
- Backend: 150,000 tokens
- Total: 350,000 tokens (exceeds 200K context!)
```

### With Local KB (via Graphify)

```
AI Agent reads knowledge base:
- graph.json: 2,100 tokens (complete graph)
- GRAPH_REPORT.md: 2,000 tokens (architecture)
- Total: 4,100 tokens (71.5x reduction!)
```

---

## 🔧 Configuration

### CLI Options

```bash
/local-kb generate [OPTIONS]

Options:
  --include PATTERN       Glob pattern for files to include [default: **/*]
  --exclude PATTERN       Glob pattern for files to exclude [default: node_modules/**]
  --output-dir PATH       Output directory [default: .hyperbrain-kb]
  --format FORMAT         Output format [markdown, json, both] [default: both]
  --verbose               Verbose output
  --force                 Overwrite existing KB
```

### Config File (.hyperbrain-kb/config.json)

```json
{
  "version": "1.0.0",
  "settings": {
    "include_patterns": ["**/*.ts", "**/*.js", "**/*.json"],
    "exclude_patterns": ["node_modules/**", "dist/**", "**/*.spec.ts"],
    "features": {
      "extract_api_endpoints": true,
      "extract_database_schema": true,
      "analyze_patterns": true,
      "generate_graph": true
    }
  }
}
```

---

## 🔄 Git Integration

### Auto-Update on Commit

```bash
# Install git hook
/local-kb hook install

# Now KB auto-updates on every commit
git add .
git commit -m "feat: add new feature"
# KB automatically updated and included in commit
```

### Remove Git Hook

```bash
/local-kb hook uninstall
```

---

## 🔍 Query Examples

### Architecture Questions

```bash
/local-kb query "What is the overall architecture?"
/local-kb query "How does frontend communicate with backend?"
```

### Implementation Questions

```bash
/local-kb query "How do I add a new API endpoint?"
/local-kb query "Where is authentication logic implemented?"
```

### Dependency Questions

```bash
/local-kb query "What databases are used?"
/local-kb query "What are the key external dependencies?"
```

### Pattern Questions

```bash
/local-kb query "What design patterns are used?"
/local-kb query "How are errors handled?"
```

---

## 🎯 Best Practices

### 1. Commit KB to Repository

```bash
# Always commit KB to version control
git add .hyperbrain-kb/
git commit -m "docs: add knowledge base"
git push origin main
```

### 2. Update Regularly

```bash
# Use git hooks for auto-update
/local-kb hook install

# Or update manually after significant changes
/local-kb update
```

### 3. Customize for Your Team

```bash
# Add team-specific documentation
echo "# Team Conventions" > .hyperbrain-kb/TEAM.md
echo "- We use 2-space indentation" >> .hyperbrain-kb/TEAM.md
```

### 4. Use with AI Agents

```bash
# When starting a new session, load KB first
/local-kb load

# Then AI has full context from the beginning
```

---

## 🛠️ Troubleshooting

### "KB not found"

```bash
# Solution: Generate KB first
/local-kb generate
```

### "KB is outdated"

```bash
# Solution: Update KB
/local-kb update
```

### "Too much information in KB"

```bash
# Solution: Customize include/exclude patterns
/local-kb generate --include "**/*.ts" --exclude "**/*.spec.ts"
```

---

## 📚 Quick Reference Commands

```bash
# Generation
/local-kb generate                              # Generate KB
/local-kb generate --force                      # Overwrite existing
/local-kb update                                # Update existing KB

# Querying
/local-kb query "architecture"                 # Query KB
/local-kb load                                  # Load KB for AI session

# Git Integration
/local-kb hook install                          # Install git hook
/local-kb hook uninstall                        # Remove git hook

# Information
/local-kb stats                                 # Show KB statistics
/local-kb validate                              # Validate KB completeness
```

---

## 🎯 Integration with HyperBrain

### Complementary Skills

- **graphify-integration** - Deep AST analysis for complex patterns
- **superpowers-brainstorm** - Plan features using KB context
- **expert-personas** - Expert reviews based on KB architecture
- **tdd-workflow** - Write tests based on KB patterns

---

**Local KB Generator: Instant repository context, minimal tokens!** 🚀
