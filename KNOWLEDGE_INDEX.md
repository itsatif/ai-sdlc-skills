# AI-SDLC Knowledge Base Index

**Author:** Atif Salafi <atif8486@gmail.com>
**Purpose:** Master index for all organizational knowledge bases
**Version:** 1.0.0
**Last Updated:** 2026-05-03

---

## 📚 Complete Knowledge Library

The AI-SDLC Skills Library now includes comprehensive knowledge bases for all major platforms:

### 1. DeJoule Organizational Knowledge
**Location:** `dejoule-knowledge-base/`
- **Scope:** Complete DeJoule ecosystem
- **Contents:**
  - Organization overview and products
  - System architecture and data flows
  - All databases and their relationships
  - Complete API documentation
  - Frontend and backend patterns
  - Testing and deployment standards
  - Security and compliance
  - Team structure and workflows

**When to use:** Starting any DeJoule-related work

---

### 2. Backend Knowledge Base (jt-api-v2)
**Location:** `backend-knowledge-base/`
- **Scope:** Backend API microservice
- **Contents:**
  - Layered architecture pattern
  - Complete API endpoints (50+ routes)
  - Database interactions (PostgreSQL, InfluxDB, Redis)
  - Authentication/Authorization (JWT, RBAC)
  - Service layer patterns
  - Data transformation pipeline
  - Error handling strategies
  - Testing patterns
  - Deployment configuration

**When to use:** Working on jt-api-v2 backend code

---

### 3. IoT Knowledge Base
**Location:** `iot-knowledge-base/`
- **Scope:** Complete IoT platform
- **Contents:**
  - IoT platform architecture
  - MQTT broker and topic structure
  - Message patterns (telemetry, commands, feedback)
  - Data flows (ingestion, command execution)
  - IoT services (iot-application, iot-feedback-handler, hostServices)
  - InfluxDB schema for time-series data
  - Protocol specifications (BACnet, Modbus)
  - Error handling and monitoring
  - Deployment patterns

**When to use:** Working on IoT, MQTT, InfluxDB, or device integration

---

## 🔍 How to Use Knowledge Bases

### For AI Assistants

When installed, AI assistants automatically load these knowledge bases and can:

```bash
User: "Add a new endpoint to jt-api-v2 for device commands"

AI: [Activates Backend Knowledge Base]
    "I'll create a new endpoint following jt-api-v2 patterns:

    Architecture:
    - Controller layer (handle HTTP request)
    - Service layer (business logic)
    - Repository layer (data access)
    - Transformer (DTO → Domain → ViewModel)

    I'll create:
    1. POST /api/devices/:deviceId/command
    2. Validate with Joi schema
    3. Publish to MQTT broker
    4. Return command status"
```

### For Developers

#### Onboarding
1. Install skills: `./install.sh`
2. Browse knowledge bases: `ls ~/.claude/skills/`
3. Read relevant SKILL.md files
4. Start coding with full context

#### Development
```bash
# Before starting work
cat ~/.claude/skills/dejoule-knowledge-base/SKILL.md

# Or ask AI
"Explain the jt-api-v2 architecture"

# AI provides:
# - Layered architecture diagram
# - Key services and responsibilities
# - Database connections
# - Common patterns to follow
```

---

## 📊 Knowledge Graph Structure

Each knowledge base includes a `KNOWLEDGE_GRAPH.json` file with:

### Structured Data
```json
{
  "domain": "backend|iot|organization",
  "tech_stack": { ... },
  "architecture": { ... },
  "databases": { ... },
  "api_endpoints": { ... },
  "patterns": { ... },
  "deployment": { ... }
}
```

### Benefits
- **Programmatic Access**: Parse and use in tools
- **Graphify Integration**: Visualize knowledge graphs
- **Search**: JSON search across all domains
- **Validation**: Ensure completeness

---

## 🎯 Quick Reference

### By Domain

**Frontend Development:**
→ DeJoule Knowledge Base (Frontend sections)
→ Angular Patterns Skill
→ React Patterns Skill
→ Vue Patterns Skill

**Backend Development:**
→ Backend Knowledge Base (jt-api-v2)
→ Node.js Patterns Skill
→ Python Patterns Skill
→ Go Patterns Skill

**IoT Development:**
→ IoT Knowledge Base
→ MQTT Patterns Skill
→ Kafka Patterns Skill
→ InfluxDB Patterns Skill
→ IoT Architecture Skill

**Database Development:**
→ Database Patterns Skill
→ InfluxDB Patterns Skill
→ Backend Knowledge Base (DB sections)

---

## 🚀 Installation

### Install All Knowledge Bases

```bash
# Clone repository
git clone https://github.com/itsatif/ai-sdlc-skills.git ~/.claude/skills

# All knowledge bases included automatically
cd ~/.claude/skills
ls -la */SKILL.md */KNOWLEDGE_GRAPH.json
```

### Install Specific Knowledge Base

```bash
# Install only Backend knowledge
mkdir -p ~/.claude/skills
cp -r ai-sdlc-skills/backend-knowledge-base/* ~/.claude/skills/

# Install only IoT knowledge
cp -r ai-sdlc-skills/iot-knowledge-base/* ~/.claude/skills/
```

---

## 📈 Coverage Summary

| Domain | Skills | Knowledge Base | Coverage |
|--------|--------|----------------|----------|
| **Organization** | ✅ | ✅ | 100% |
| **Frontend** | ✅ | ✅ (DeJoule) | 100% |
| **Backend** | ✅ | ✅ (jt-api-v2) | 100% |
| **IoT** | ✅ | ✅ (IoT Platform) | 100% |
| **Databases** | ✅ | ✅ (All KBs) | 100% |
| **Testing** | ✅ | ✅ (All KBs) | 100% |
| **DevOps** | 🔄 | ✅ (DeJoule) | 80% |

---

## 🎓 Learning Paths

### For Frontend Developers
1. **Start:** DeJoule Knowledge Base (Frontend sections)
2. **Then:** Angular Patterns Skill
3. **Then:** State Management Skill
4. **Then:** TDD Workflow Skill

### For Backend Developers
1. **Start:** Backend Knowledge Base (jt-api-v2)
2. **Then:** Node.js Patterns Skill
3. **Then:** Database Patterns Skill
4. **Then:** TDD Workflow Skill

### For IoT Developers
1. **Start:** IoT Knowledge Base
2. **Then:** MQTT Patterns Skill
3. **Then:** InfluxDB Patterns Skill
4. **Then:** IoT Architecture Skill

### For Full-Stack Developers
1. **Start:** DeJoule Knowledge Base (Complete)
2. **Then:** Domain-specific skills as needed
3. **Then:** TDD Workflow Skill
4. **Then:** Architecture-specific skills

---

## 🔗 Integrations

### With Graphify Tool

```bash
# Use graphify on any knowledge graph
graphify backend-knowledge-base/KNOWLEDGE_GRAPH.json
graphify iot-knowledge-base/KNOWLEDGE_GRAPH.json
graphify dejoule-knowledge-base/KNOWLEDGE_GRAPH.json
```

### With Morpheus MCP

```bash
# Query knowledge graphs
morpheus query-graph "jt-api-v2"
morpheus query-graph "iot-application"
morpheus query-graph "dejoule"
```

---

## 📊 Statistics

### Total Knowledge
- **Organizational Knowledge:** 18,773 words
- **Backend Knowledge:** 12,456 words
- **IoT Knowledge:** 15,234 words
- **Total Documentation:** 46,463 words

### Entities Covered
- **Services:** 7+ microservices
- **Databases:** 4 (PostgreSQL, InfluxDB, Redis, MongoDB)
- **API Endpoints:** 50+ routes
- **MQTT Topics:** 6+ topic patterns
- **Components:** 645 frontend classes, 79 backend classes
- **Patterns:** 30+ documented patterns

---

## ✅ Quality Assurance

All knowledge bases are:
- ✅ **Comprehensive:** Cover all major aspects
- ✅ **Structured:** Organized for easy navigation
- ✅ **Searchable:** JSON knowledge graphs for queries
- ✅ **Actionable:** Include code examples and patterns
- ✅ **Maintainable:** Easy to update as systems evolve

---

**This master index provides a complete map of all organizational knowledge, enabling AI-assisted development with full context across all domains.** 🚀
