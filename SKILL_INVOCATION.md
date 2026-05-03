# How Skills Are Invoked - Complete Guide

**Version:** 2.0.0
**Last Updated:** 2026-05-03

---

## 🎯 Overview

After installing the AI-SDLC Skills Library, skills are invoked **automatically** by AI assistants based on:
1. **User's request context** - What the user is asking for
2. **Keyword detection** - Skill triggers in user prompts
3. **Project context** - Tech stack, file types, current work
4. **Superpowers Brainstorming** - Automatic activation for all requests

---

## 🚀 Automatic Activation Methods

### Method 1: Superpowers Brainstorming (AUTOMATIC - Always)

**Trigger:** ANY user request or question

**How it works:**
```
User: "Add a new widget showing real-time SEC"
         ↓
AI: [Activates Superpowers Brainstorming AUTOMATICALLY]
    "Let me understand your requirements first:
    1. What problem does this solve?
    2. Who are the users?
    3. What are the edge cases?
    4. How does this integrate with existing systems?"
         ↓
User: Provides answers
         ↓
AI: [Selects appropriate skills based on context]
    [Generates implementation plan]
    [Executes using selected skills]
```

**Behind the scenes:**
```bash
# AI reads SKILL.md files automatically
~/.claude/skills/superpowers-brainstorm/SKILL.md

# AI activates brainstorming framework
# - Generates mandatory questions
# - Creates multiple approaches
# - Selects best strategy
```

---

### Method 2: Context-Based Invocation (AUTOMATIC)

**Trigger:** File types, project structure, tech stack detection

**Example 1: Angular Project**
```
User: "Create a new component for user profile"
         ↓
AI: [Detects Angular project]
    [Sees angular.json, app.component.ts files]
    [Activates jouletrack-angular skill AUTOMATICALLY]
         ↓
AI: "I'll create this following Angular Container/Presenter pattern:
    - Container component: UserProfileContainer
    - Presenter component: UserProfile
    - Service: UserProfileService
    - Tests: UserProfile.component.spec.ts"
```

**Behind the scenes:**
```bash
# AI scans project files
AI: [Sees *.ts files, @angular imports]
    [Loads jouletrack-angular/SKILL.md]
    [Follows Container/Presenter pattern]
```

**Example 2: Backend API**
```
User: "Add a new endpoint for device commands"
         ↓
AI: [Detects backend project]
    [Sees Express/Node.js files]
    [Activates backend-knowledge-base AUTOMATICALLY]
         ↓
AI: "Based on jt-api-v2 architecture:
    - Controller layer (handle HTTP request)
    - Service layer (business logic)
    - Repository layer (data access)
    - Transformer (DTO → Domain → ViewModel)"
```

**Behind the scenes:**
```bash
# AI loads backend knowledge
AI: [Loads backend-knowledge-base/SKILL.md]
    [Checks API patterns]
    [Follows layered architecture]
```

**Example 3: IoT Integration**
```
User: "Subscribe to device telemetry updates"
         ↓
AI: [Detects IoT context]
    [Activates iot-knowledge-base AUTOMATICALLY]
         ↓
AI: "Based on IoT platform architecture:
    - MQTT topic: data/{siteId}/{controllerId}/{componentId}
    - QoS level: 0 (fire and forget for telemetry)
    - iot-application subscribes and writes to InfluxDB"
```

**Behind the scenes:**
```bash
# AI loads IoT knowledge
AI: [Loads iot-knowledge-base/SKILL.md]
    [Checks MQTT patterns]
    [Follows topic hierarchy]
```

---

### Method 3: Keyword-Based Invocation (AUTOMATIC)

**Trigger:** Specific keywords in user request

**Keyword → Skill Mapping:**

```javascript
// AI detects keywords and activates corresponding skills

"test" → tdd-workflow skill
"spec" → tdd-workflow skill
"e2e" → playwright-patterns skill
"playwright" → playwright-patterns skill

"mqtt" → mqtt-patterns skill
"iot" → iot-knowledge-base skill
"influxdb" → influxdb-patterns skill

"database" → database-patterns skill
"sql" → database-patterns skill
"query" → database-patterns skill

"notion" → MCP: Notion server
"figma" → MCP: Figma server
"github" → MCP: GitHub server
"slack" → MCP: Slack server
```

**Examples:**

```
User: "Write unit tests for this service"
AI: [Detects "test" keyword]
    [Activates tdd-workflow skill]
    "Following TDD Red-Green-Refactor..."

User: "Create an MQTT subscriber"
AI: [Detects "mqtt" keyword]
    [Activates mqtt-patterns skill]
    "Based on MQTT patterns..."

User: "Update this GitHub PR"
AI: [Detects "github" keyword]
    [Activates GitHub MCP server]
    [Updates PR via GitHub API]
```

---

### Method 4: Manual Invocation (USER-INITIATED)

**Trigger:** User explicitly references a skill

**Format 1: Direct Reference**
```
User: "Use the Angular patterns skill to create this component"
         ↓
AI: [Activates jouletrack-angular skill]
    "Following Angular Container/Presenter pattern..."
```

**Format 2: Ask About Skill**
```
User: "What does the TDD workflow skill tell me to do?"
         ↓
AI: [Loads tdd-workflow/SKILL.md]
    "According to TDD workflow:
    1. Write test first (RED)
    2. Run test - it should FAIL
    3. Write minimal implementation (GREEN)
    4. Run test - it should PASS
    5. Refactor (IMPROVE)
    6. Verify coverage (80%+)"
```

**Format 3: Explicit Context Loading**
```
User: "Activate the DeJoule Knowledge Base"
         ↓
AI: [Loads dejoule-knowledge-base/SKILL.md]
    [Loads dejoule-knowledge-base/KNOWLEDGE_GRAPH.json]
    "DeJoule Knowledge Base activated. I now have:
    - Complete organizational context
    - Product architecture
    - API endpoints
    - Frontend/backend patterns
    - Testing standards"
```

---

## 🔍 Behind the Scenes - How AI Detects Skills

### Step 1: Scan Installed Skills

```bash
# AI scans skills directory
~/.claude/skills/
├── superpowers-brainstorm/SKILL.md
├── tdd-workflow/SKILL.md
├── jouletrack-angular/SKILL.md
├── backend-knowledge-base/SKILL.md
├── iot-knowledge-base/SKILL.md
├── playwright-patterns/SKILL.md
├── qa-automation/SKILL.md
└── mcp-setup/SKILL.md
```

### Step 2: Parse SKILL.md Files

```markdown
# SKILL.md Structure (AI reads this)

## 🎯 When to Use This Skill
**Use for ALL Angular development:**
- Component development
- Service creation
- State management

## 🏗️ Architecture
Container/Presenter pattern:
- Container: Logic and data fetching
- Presenter: UI rendering

## 📝 Patterns
- Always use TypeScript
- Always write tests (80%+ coverage)
- Follow naming conventions
```

**AI extracts:**
- Trigger keywords ("Angular", "component", "service")
- When to use criteria
- Patterns to follow
- Code examples

### Step 3: Match User Request to Skills

```javascript
// AI's internal matching logic

user_request = "Create an Angular component for user profile"

// Extract keywords
keywords = extract_keywords(user_request)
// ["create", "angular", "component", "user", "profile"]

// Match to skills
matched_skills = []
for skill in skills:
  if keyword in skill.triggers:
    matched_skills.add(skill)

// Result: matched_skills = [jouletrack-angular, tdd-workflow]

// Select primary skill
primary_skill = select_highest_priority(matched_skills)
// Result: jouletrack-angular

// Activate skill
activate(primary_skill)
```

### Step 4: Load Skill Context

```bash
# AI loads skill files
AI reads: ~/.claude/skills/jouletrack-angular/SKILL.md
AI reads: ~/.claude/skills/dejoule-knowledge-base/SKILL.md
AI reads: ~/.claude/skills/tdd-workflow/SKILL.md

# AI now knows:
# - Angular Container/Presenter pattern
# - DeJoule organizational context
# - TDD workflow requirements
```

---

## 💡 Real-World Examples

### Example 1: Feature Development

```
User: "Add a new widget showing real-time SEC to the dashboard"

AI: [Activates Superpowers Brainstorming AUTOMATICALLY]
    "Let me understand your requirements:
    1. What is SEC? (Specific Energy Consumption)
    2. Where should it display? (Dashboard)
    3. Data source? (/api/dashboard/:siteId/sec)
    4. Update frequency? (Every 5 minutes)
    5. Any user interactions? (Drill-down to device level)"

User: "Yes, all of that"

AI: [Detects Angular project from files]
    [Activates jouletrack-angular skill]
    [Activates dejoule-knowledge-base]
    [Activates tdd-workflow skill]
    [Activates qa-automation skill]

    "I'll create following DeJoule patterns:

    Phase 1: Component Structure
    - SecWidgetContainer (logic, data fetching)
    - SecWidget (UI presentation)
    - SecWidgetService (API calls)

    Phase 2: Tests (TDD Red-Green-Refactor)
    - Unit tests (Jasmine)
    - Integration tests (Supertest)
    - E2E tests (Playwright)

    Phase 3: Implementation
    Following Container/Presenter pattern from DeJoule KB...
    [Generates code]"

    [Code generated with:]
    - Angular patterns (Container/Presenter)
    - DeJoule API endpoints
    - TDD test-first approach
    - 80%+ test coverage
    - Playwright E2E tests
```

### Example 2: Debugging Issue

```
User: "The MQTT connection keeps dropping"

AI: [Detects "MQTT" keyword]
    [Activates iot-knowledge-base AUTOMATICALLY]
    [Activates mqtt-patterns skill]

    "Based on IoT platform architecture:

    Common causes:
    1. High message throughput → Buffer full
       Solution: Increase buffer size in iot-application

    2. Network instability → Connection timeout
       Solution: Increase keepalive in MQTT client config

    3. InfluxDB slow writes → Backpressure
       Solution: Check batch size in iot-application

    Let me check your current configuration..."
    [Reads config files]
    [Provides specific solution based on IoT KB]"
```

### Example 3: MCP Integration

```
User: "Create a PRD for the mobile app in Notion"

AI: [Detects "Notion" keyword]
    [Activates Notion MCP server AUTOMATICALLY]
    [Activates Superpowers Brainstorming]

    "I'll create a PRD in Notion. Let me gather requirements first:
    1. Target platform? (iOS/Android/Both)
    2. Key features?
    3. Target users?
    4. Success metrics?"

    [After gathering requirements]

    "Creating PRD in Notion...
    [Uses Notion MCP API to create page]
    [Adds sections: Overview, Features, Tech Stack, Timeline]
    ✅ PRD created: https://notion.so/prd-mobile-app"

User: "Also link the Figma designs"

AI: [Activates Figma MCP server]
    "Fetching designs from Figma...
    [Uses Figma MCP API]
    [Adds links to Notion PRD]
    ✅ Figma designs linked"
```

---

## 🎯 Summary: How Skills Are Invoked

### AUTOMATIC Invocation (99% of cases)
1. **Superpowers Brainstorming** - ALWAYS activates first
2. **Context Detection** - Project type, files, tech stack
3. **Keyword Matching** - Test, MQTT, database, etc.
4. **Knowledge Base Loading** - Organizational context

### MANUAL Invocation (1% of cases)
1. **Explicit Reference** - "Use Angular patterns skill"
2. **Direct Question** - "What does TDD workflow say?"
3. **Context Activation** - "Activate DeJoule Knowledge Base"

---

## 🔧 Verification: Testing Skill Invocation

### Test 1: Automatic Activation
```
User: "Create a new Angular component"

Expected: AI should automatically:
- Activate Superpowers Brainstorming
- Detect Angular project
- Load jouletrack-angular skill
- Follow Container/Presenter pattern
- Generate component with tests
```

### Test 2: Keyword Detection
```
User: "Write tests for this service"

Expected: AI should automatically:
- Detect "test" keyword
- Activate tdd-workflow skill
- Follow Red-Green-Refactor
- Generate tests with 80%+ coverage
```

### Test 3: Knowledge Base Loading
```
User: "What is the jt-api-v2 architecture?"

Expected: AI should automatically:
- Detect "jt-api-v2" keyword
- Load backend-knowledge-base
- Explain layered architecture
- Show API endpoints
```

### Test 4: MCP Activation
```
User: "Update this GitHub PR"

Expected: AI should automatically:
- Detect "github" keyword
- Activate GitHub MCP server
- Update PR via API
- Confirm changes
```

---

## 🚀 Quick Start for Users

### After Installation

1. **Restart your AI assistant**
   ```bash
   # Close and reopen Claude Code/Cursor/Copilot
   ```

2. **Start using immediately**
   ```
   Just ask your question or request!
   Skills will activate automatically.
   ```

3. **Verify it's working**
   ```
   Ask: "What skills do you have available?"

   AI should list all installed skills:
   - Superpowers Brainstorming
   - TDD Workflow
   - Angular Patterns
   - Backend Knowledge Base
   - IoT Knowledge Base
   - Playwright Patterns
   - QA Automation
   - MCP Setup
   ```

---

## 📚 Summary

**Skills are invoked AUTOMATICALLY based on:**
- ✅ User request context
- ✅ Project type and files
- ✅ Keyword detection
- ✅ Superpowers Brainstorming (always first)

**Users don't need to:**
- ❌ Manually select skills
- ❌ Remember skill names
- ❌ Load skills explicitly
- ❌ Configure skill triggers

**Just ask your question, and AI will:**
1. Activate Superpowers Brainstorming
2. Detect relevant skills
3. Load appropriate knowledge bases
4. Follow established patterns
5. Generate code/tests/docs

**It's that simple!** 🚀
