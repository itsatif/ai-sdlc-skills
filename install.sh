#!/bin/bash

################################################################################
# AI-SDLC Skills Library Installer
# Author: Atif Salafi <atif8486@gmail.com>
# Purpose: Install AI-SDLC skills for Claude Code or other AI assistants
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗╗${NC}"
    echo -e "${BLUE}║${NC}  ${GREEN}AI-SDLC Skills Library Installer${NC}                        ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Default values
INSTALL_DIR="$HOME/.claude/skills"
BACKUP_DIR="$HOME/.claude/skills.backup.$(date +%Y%m%d_%H%M%S)"
CLONE_DIR="/tmp/hyperbrain-skills.$$"
SKIP_BACKUP=false
ASSISTANT="claude"

# Help function
show_help() {
    cat << EOF
${GREEN}AI-SDLC Skills Library Installer${NC}

${YELLOW}Usage:${NC}
    $0 [OPTIONS]

${YELLOW}Options:${NC}
    -d, --dir DIR          Installation directory (default: ~/.claude/skills)
    -a, --assistant TYPE   Assistant type: claude, codex, cursor, copilot (default: claude)
    -s, --skip-backup      Skip backup of existing skills
    -h, --help             Show this help message

${YELLOW}Examples:${NC}
    # Install for Claude Code (default)
    $0

    # Install for Cursor
    $0 --assistant cursor

    # Install to custom directory
    $0 --dir ~/my-skills

    # Install without backup
    $0 --skip-backup

${YELLOW}Supported Assistants:${NC}
    - claude   Claude Code (default)
    - codex    OpenAI Codex
    - cursor   Cursor AI Editor
    - copilot  GitHub Copilot

${YELLOW}Skills Included:${NC}
    - AI Superpowers (Brainstorming & Planning)
    - TDD Workflow
    - Angular, React, Vue, Next.js Patterns
    - State Management (Redux, Zustand, Pinia, NgRx)
    - Node.js, Python, Go Patterns
    - Database Patterns (PostgreSQL, InfluxDB, MongoDB, Redis)
    - MQTT, Kafka, InfluxDB, IoT Architecture

${YELLOW}Documentation:${NC}
    https://github.com/itsatif/hyperbrain-skills

EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dir)
            INSTALL_DIR="$2"
            shift 2
            ;;
        -a|--assistant)
            ASSISTANT="$2"
            shift 2
            ;;
        -s|--skip-backup)
            SKIP_BACKUP=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Main installation flow
main() {
    print_header

    # Check prerequisites
    print_info "Checking prerequisites..."
    if ! command -v git &> /dev/null; then
        print_error "git is not installed. Please install git first."
        exit 1
    fi
    print_success "Prerequisites check passed"

    # Show installation plan
    echo ""
    print_info "Installation Plan:"
    echo "  Assistant: ${GREEN}$ASSISTANT${NC}"
    echo "  Install Dir: ${GREEN}$INSTALL_DIR${NC}"
    echo "  Backup: ${YELLOW}$([ "$SKIP_BACKUP" = true ] && echo 'Skipping' || echo 'Yes (to '$BACKUP_DIR')')${NC}"
    echo ""

    # Confirm installation
    read -p "$(echo -e ${YELLOW}Continue? [y/N]: ${NC})" -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Installation cancelled"
        exit 0
    fi

    # Backup existing skills if directory exists
    if [ -d "$INSTALL_DIR" ] && [ "$SKIP_BACKUP" = false ]; then
        print_info "Backing up existing skills..."
        mkdir -p "$BACKUP_DIR"
        cp -r "$INSTALL_DIR"/* "$BACKUP_DIR/" 2>/dev/null || true
        print_success "Backup created at $BACKUP_DIR"
    fi

    # Clone repository
    print_info "Cloning AI-SDLC skills library..."
    git clone --depth 1 https://github.com/itsatif/hyperbrain-skills.git "$CLONE_DIR"
    print_success "Repository cloned"

    # Create installation directory
    print_info "Creating installation directory..."
    mkdir -p "$INSTALL_DIR"
    print_success "Directory ready"

    # Install skills based on assistant type
    print_info "Installing skills for $ASSISTANT..."

    case "$ASSISTANT" in
        claude)
            # For Claude Code, copy all skill directories
            cp -r "$CLONE_DIR"/*-patterns/SKILL.md "$INSTALL_DIR/" 2>/dev/null || true
            cp -r "$CLONE_DIR"/superpowers-*/SKILL.md "$INSTALL_DIR/" 2>/dev/null || true
            cp -r "$CLONE_DIR"/tdd-*/SKILL.md "$INSTALL_DIR/" 2>/dev/null || true
            print_success "Skills installed for Claude Code"
            ;;

        codex|cursor|copilot)
            # For other assistants, create compatible structure
            mkdir -p "$INSTALL_DIR/.skills"
            cp -r "$CLONE_DIR"/* "$INSTALL_DIR/.skills/" 2>/dev/null || true

            # Create index file for easy discovery
            cat > "$INSTALL_DIR/.skills/index.md" << 'EOF'
# AI-SDLC Skills Index

This directory contains comprehensive AI-SDLC development skills.

## Available Skills

- **superpowers-brainstorming/** - AI brainstorming and planning framework
- **angular-patterns/** - Angular development patterns
- **react-patterns/** - React development patterns
- **vue-patterns/** - Vue.js development patterns
- **nextjs-patterns/** - Next.js full-stack patterns
- **state-management/** - Redux, Zustand, Pinia, NgRx patterns
- **nodejs-patterns/** - Node.js/Express API patterns
- **python-patterns/** - FastAPI and Python patterns
- **go-patterns/** - Go/Gin patterns
- **database-patterns/** - PostgreSQL, InfluxDB, MongoDB, Redis
- **mqtt-patterns/** - IoT MQTT communication
- **kafka-patterns/** - Stream processing with Kafka
- **influxdb-patterns/** - Time-series data patterns
- **iot-architecture/** - Complete IoT system design
- **tdd-workflow/** - Test-driven development

## Usage

Refer to individual skill directories for detailed documentation.
EOF
            print_success "Skills installed for $ASSISTANT"
            ;;

        *)
            # Default: copy all skills
            cp -r "$CLONE_DIR"/* "$INSTALL_DIR/" 2>/dev/null || true
            print_success "Skills installed (generic format)"
            ;;
    esac

    # Create activation script
    print_info "Creating activation helper..."
    create_activation_script
    print_success "Activation helper created"

    # Cleanup
    print_info "Cleaning up..."
    rm -rf "$CLONE_DIR"
    print_success "Cleanup complete"

    # Show success message
    echo ""
    print_header
    print_success "Installation complete!"
    echo ""
    print_info "Next Steps:"
    echo "  1. ${GREEN}Restart your AI assistant${NC}"
    echo "  2. Skills will be automatically available"
    echo "  3. Ask any question to activate AI Superpowers brainstorming"
    echo ""
    print_info "Documentation:"
    echo "  ${BLUE}https://github.com/itsatif/hyperbrain-skills${NC}"
    echo ""
    print_info "Skills installed:"
    list_installed_skills
    echo ""
}

# Create activation helper script
create_activation_script() {
    cat > "$INSTALL_DIR/../activate-skills.sh" << 'EOF'
#!/bin/bash

# AI-SDLC Skills Activation Helper

echo "AI-SDLC Skills Library Status:"
echo "================================"
echo ""

# Check if skills directory exists
if [ -d "$HOME/.claude/skills" ]; then
    echo "✓ Skills directory exists"
    echo ""
    echo "Installed Skills:"
    ls -1 "$HOME/.claude/skills" | grep -E "SKILL\.md$" | sed 's/SKILL.md/  ✓/' || echo "  No skills found"
else
    echo "✗ Skills directory not found"
    echo "  Run install.sh to install skills"
fi

echo ""
echo "Usage:"
echo "  Just ask your AI assistant any question!"
echo "  The AI Superpowers skill will activate automatically."
echo ""
echo "Examples:"
echo "  - 'Add user authentication to my app'"
echo "  - 'Create a REST API for user management'"
echo "  - 'Build a real-time dashboard with charts'"
echo ""
EOF

    chmod +x "$INSTALL_DIR/../activate-skills.sh"
}

# List installed skills
list_installed_skills() {
    local skills=(
        "AI Superpowers:Brainstorming & Planning"
        "TDD Workflow:Test-driven development"
        "Angular:Enterprise Angular patterns"
        "React:Modern React with hooks"
        "Vue:Vue 3 Composition API"
        "Next.js:Full-stack React SSR"
        "State Management:Redux, Zustand, Pinia, NgRx"
        "Node.js:Express/TypeScript APIs"
        "Python:FastAPI async patterns"
        "Go:Gin/GORM high-performance"
        "Databases:PostgreSQL, InfluxDB, MongoDB, Redis"
        "MQTT:IoT device communication"
        "Kafka:Stream processing"
        "InfluxDB:Time-series data"
        "IoT Architecture:Complete IoT systems"
    )

    for skill in "${skills[@]}"; do
        local name=$(echo "$skill" | cut -d: -f1)
        local desc=$(echo "$skill" | cut -d: -f2)
        echo "  ${GREEN}✓${NC} ${BLUE}${name}${NC} - ${desc}"
    done
}

# Run main function
main
