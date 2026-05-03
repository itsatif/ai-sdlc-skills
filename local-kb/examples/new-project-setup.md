# Example: Setting Up Local KB for a New Repository

**Use Case:** Automatically generate knowledge base for any repository using Graphify to reduce token consumption

---

## 🎯 Objective

Create a local knowledge base using Graphify that provides instant context to AI agents, reducing token consumption by 71.5x.

---

## 📋 Prerequisites

1. Repository cloned locally
2. Graphify installed: `pip install graphifyy`
3. Git initialized

---

## 🚀 Step-by-Step Workflow

### Step 1: Clone or Navigate to Repository

```bash
# Clone a new repository
git clone https://github.com/your-org/your-project.git
cd your-project

# OR navigate to existing repository
cd ~/workspace/existing-project
```

### Step 2: Generate Knowledge Base with Graphify

```bash
# Generate local knowledge base using Graphify
graphify --output-dir .hyperbrain-kb
```

**Expected Output:**
```
🔍 Analyzing codebase...
📊 Found 347 files
🔧 Extracting AST nodes...
🔗 Linking cross-file references...
🎯 Detecting communities...
📝 Generating outputs...
✅ HTML: .hyperbrain-kb/graph.html
✅ JSON: .hyperbrain-kb/graph.json
✅ Report: .hyperbrain-kb/GRAPH_REPORT.md

✅ Knowledge base generated successfully!
📁 Location: .hyperbrain-kb/
📊 Token efficiency: 71.5x reduction
```

### Step 3: Review Generated Knowledge Base

```bash
# View the architecture report
cat .hyperbrain-kb/GRAPH_REPORT.md
```

**Example Output:**
```markdown
# Knowledge Graph Report

## Graph Statistics
- Nodes: 1,847 (functions, classes, modules)
- Edges: 3,421 (calls, imports, references)
- Communities: 12 (service clusters)
- Modularity: 0.67 (well-clustered)

## Architecture Overview
The project follows a layered architecture:
- Presentation Layer: Angular components
- Business Logic: Service layer
- Data Access: Repository pattern
- Database: PostgreSQL with migrations

## Technology Stack
- Frontend: Angular 16, TypeScript 5.0
- Backend: Node.js 18, Express 4.18
- Database: PostgreSQL 14
- Testing: Jest, Playwright
```

```bash
# Open interactive visualization (macOS)
open .hyperbrain-kb/graph.html

# On Linux
xdg-open .hyperbrain-kb/graph.html

# On Windows
start .hyperbrain-kb/graph.html
```

### Step 4: Query the Knowledge Base

```bash
# Navigate to KB directory
cd .hyperbrain-kb

# Query for architecture
graphify query "What is the project architecture?"

# Query for API endpoints
graphify query "List all REST endpoints"

# Trace execution paths
graphify path "AuthController" to "DatabaseService"

# Find dependencies
graphify query "What depends on UserService?"
```

### Step 5: Commit Knowledge Base to Repository

```bash
# Go back to repository root
cd ..

# Add KB to git
git add .hyperbrain-kb/

# Commit KB
git commit -m "docs: add HyperBrain knowledge base

- Auto-generated with Graphify
- Interactive HTML visualization
- Machine-readable JSON graph
- Architecture report
- 71.5x token reduction for AI agents"

# Push to remote
git push origin main
```

### Step 6: Use with AI Agents

Now when working with AI agents, they can load the KB for instant context:

```bash
# AI agent loads KB first
cat .hyperbrain-kb/GRAPH_REPORT.md

# Or loads the graph structure
cat .hyperbrain-kb/graph.json | jq '.nodes | length'

# Then AI can answer questions with full context
# AI: "Based on the knowledge base in .hyperbrain-kb/, this is an
#      Angular 16 project with 1,847 nodes and 3,421 edges.
#      The project uses Container/Presenter pattern with Express
#      backend and PostgreSQL database. I'll follow these patterns."
```

---

## 📊 Token Savings Comparison

### Without Local KB

```
AI Agent reads entire codebase:
- src/: 200,000 tokens
- tests/: 50,000 tokens
- configuration: 20,000 tokens
- Total: 270,000 tokens (exceeds 200K context!)
```

### With Local KB (Graphify)

```
AI Agent reads knowledge base:
- graph.json: 2,100 tokens (complete graph structure)
- GRAPH_REPORT.md: 2,000 tokens (architecture summary)
- Total: 4,100 tokens (71.5x reduction!)
```

**Benefits:**
- ✅ 71.5x token reduction (Graphify's AST extraction)
- ✅ Faster responses (less context to process)
- ✅ Lower costs (fewer tokens consumed)
- ✅ Better understanding (AST-based, not just text)
- ✅ Accurate (deterministic parsing with tree-sitter)
- ✅ Visual (interactive HTML exploration)

---

## 🔄 Updating the Knowledge Base

### Manual Update

```bash
# After making significant changes
git add .
git commit -m "feat: add new authentication system"

# Update KB with Graphify
graphify --output-dir .hyperbrain-kb --force

# Commit updated KB
git add .hyperbrain-kb/
git commit -m "docs: update knowledge base"
git push origin main
```

### Automatic Update with Git Hook

```bash
# Install git hook for auto-update
graphify hook install

# Now KB auto-updates on every commit
git add .
git commit -m "feat: add new feature"
# KB automatically updated!
```

### Watch Mode (Continuous Update)

```bash
# Enable watch mode for continuous updates
graphify --output-dir .hyperbrain-kb --watch

# KB updates automatically when files change!
```

---

## 💡 Advanced Usage

### Custom KB Configuration

Create `.hyperbrain-kb/config.json`:

```json
{
  "version": "1.0.0",
  "settings": {
    "include_patterns": [
      "**/*.ts",
      "**/*.js",
      "**/*.json",
      "**/*.md"
    ],
    "exclude_patterns": [
      "node_modules/**",
      "dist/**",
      "**/*.spec.ts"
    ],
    "features": {
      "extract_api_endpoints": true,
      "extract_database_schema": true,
      "analyze_patterns": true,
      "generate_graph": true
    }
  }
}
```

### Add Custom Documentation

Add project-specific knowledge:

```bash
# Create custom documentation file
cat > .hyperbrain-kb/CUSTOM.md << 'EOF'
# Custom Project Knowledge

## Team Conventions
- We use 2-space indentation
- PRs require 1 approval
- We follow GitFlow branching strategy

## Business Logic
- This project handles e-commerce transactions
- Payment processing via Stripe
- Inventory management integrated with ERP

## Important Notes
- Never commit API keys
- Always run tests before committing
- Use feature branches for new work
EOF

# Custom docs are automatically included in queries
```

---

## 🎯 Query Examples

### Query Architecture

```bash
# AI agent or user can query
node ~/.claude/skills/hyperbrain-skills/local-kb/bin/generate-kb.js query "What is the architecture?"

# Response (coming in future version):
# Based on .hyperbrain-kb/REPOSITORY_OVERVIEW.md:
# - Angular 16 SPA
# - Container/Presenter pattern
# - Express backend API
# - PostgreSQL database
# - Redis caching
```

### Query API Endpoints

```bash
node ~/.claude/skills/hyperbrain-skills/local-kb/bin/generate-kb.js query "List all API endpoints"

# Response:
# From .hyperbrain-kb/API_ENDPOINTS.md:
# - GET /api/products - List all products
# - POST /api/products - Create new product
# - GET /api/products/:id - Get product by ID
# ... (all endpoints listed)
```

---

## 📚 Team Collaboration

### Onboarding New Team Members

```bash
# New team member clones repository
git clone https://github.com/your-org/your-project.git
cd your-project

# They immediately have access to knowledge base
cat .hyperbrain-kb/REPOSITORY_OVERVIEW.md

# They understand the project in minutes, not hours!
```

### Shared Understanding

```bash
# Everyone on the team has the same context
# KB is version controlled and stays in sync
# No more "how does this work?" questions

# AI agents also have the same context
# Consistent responses across the team
```

---

## 🔍 Troubleshooting

### Issue: "KB not found"

```bash
# Solution: Generate KB first
node ~/.claude/skills/hyperbrain-skills/local-kb/bin/generate-kb.js generate
```

### Issue: "KB is outdated after code changes"

```bash
# Solution: Update KB
node ~/.claude/skills/hyperbrain-skills/local-kb/bin/generate-kb.js update

# Or use git hook for auto-update
node ~/.claude/skills/hyperbrain-skills/local-kb/bin/generate-kb.js hook install
```

### Issue: "Too much information in KB"

```bash
# Solution: Customize what's included
# Edit .hyperbrain-kb/config.json to add more exclude patterns
cat > .hyperbrain-kb/config.json << 'EOF'
{
  "settings": {
    "exclude_patterns": [
      "node_modules/**",
      "dist/**",
      "**/*.spec.ts",
      "src/tests/**",
      "src/e2e/**"
    ]
  }
}
EOF

# Regenerate KB
node ~/.claude/skills/hyperbrain-skills/local-kb/bin/generate-kb.js generate --force
```

---

## 🎓 Best Practices

### 1. Always Commit KB

```bash
# KB should be part of the repository
git add .hyperbrain-kb/
git commit -m "docs: add knowledge base"
```

### 2. Update Regularly

```bash
# Update KB after significant changes
# Use git hooks for automatic updates
```

### 3. Customize for Your Team

```bash
# Add team-specific documentation to .hyperbrain-kb/CUSTOM.md
# Include coding conventions, business logic, etc.
```

### 4. Use with AI Agents

```bash
# Always load KB at the start of AI sessions
# This provides immediate context
```

### 5. Share with Team

```bash
# KB is part of the repository
# Team automatically has it when they clone
# No separate documentation needed
```

---

## 🎯 Integration with HyperBrain Skills

### Complementary Skills

1. **graphify-integration** - Deep AST analysis for complex codebases
2. **superpowers-brainstorm** - Plan features using KB context
3. **expert-personas** - Expert reviews based on KB architecture
4. **tdd-workflow** - Write tests following KB patterns
5. **knowledge-bases** - Enhance with domain-specific knowledge

### Workflow Example

```bash
# Step 1: Generate KB for new repo
cd ~/workspace/new-project
node ~/.claude/skills/hyperbrain-skills/local-kb/bin/generate-kb.js generate

# Step 2: Commit KB to repository
git add .hyperbrain-kb/
git commit -m "docs: add knowledge base"

# Step 3: Use with HyperBrain skills
# AI: "Based on the knowledge base in .hyperbrain-kb/:
#      - This is an Angular 16 project
#      - Uses Container/Presenter pattern
#      - Express backend with PostgreSQL
#      - I'll follow these patterns for the new feature."
```

---

## 📊 Real-World Example

### Before Local KB

```
Scenario: New developer joins team
Timeline:
- Day 1: Clone repository, try to understand structure
- Day 2: Read through source code, still confused
- Day 3: Ask teammates lots of questions
- Day 4: Start to understand architecture
- Day 5: Finally productive

Total time to productivity: 5 days
```

### After Local KB

```
Scenario: New developer joins team
Timeline:
- Day 1: Clone repository
- Hour 1: Read .hyperbrain-kb/REPOSITORY_OVERVIEW.md
- Hour 2: Read .hyperbrain-kb/PROJECT_STRUCTURE.md
- Hour 3: Review .hyperbrain-kb/KEY_FILES.md
- Hour 4: Start working on first task

Total time to productivity: 4 hours (93% reduction!)
```

---

## 🚀 Summary

✅ **95% Token Reduction** - 10K tokens vs 200K+ tokens  
✅ **Instant Context** - Complete architecture in seconds  
✅ **Auto-Generated** - One command creates entire KB  
✅ **Always Updated** - Git hooks keep KB in sync  
✅ **Repository-Agnostic** - Works with any codebase  
✅ **Team Collaboration** - Shareable knowledge base  
✅ **Version Controlled** - KB evolves with code  

---

**Local KB Generator: Transform any repository into queryable knowledge!** 🚀
