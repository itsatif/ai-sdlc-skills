#!/bin/bash

###############################################################################
# MCP Installer - Automated MCP Server Setup
# Part of HyperBrain Skills Library
###############################################################################

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CLAUDE_SETTINGS="${CLAUDE_SETTINGS_PATH:-$HOME/.claude/settings.json}"
MCP_CONFIG_DIR="$REPO_ROOT/mcp-setup"
MCP_ONDEMAND_DIR="$REPO_ROOT/mcp-on-demand"
BACKUP_DIR="$HOME/.claude/mcp-backups"
ENV_FILE="$REPO_ROOT/.env.mcp"
ENV_EXAMPLE_FILE="$REPO_ROOT/.env.mcp.example"

# Associative array for MCP user configurations
declare -A MCP_USER_CONFIGS

# Functions
log_info() { echo -e "${BLUE}ℹ️  $*${NC}"; }
log_success() { echo -e "${GREEN}✅ $*${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $*${NC}"; }
log_error() { echo -e "${RED}❌ $*${NC}"; }
log_fix() { echo -e "${GREEN}🔧 Fixing:${NC} $*"; }
log_retry() { echo -e "${YELLOW}🔄 Retrying:${NC} $*"; }

# Error tracking
declare -a INSTALLATION_ERRORS=()
declare -a FIXED_ERRORS=()

# Error handling with feedback loop
handle_error() {
  local error_type="$1"
  local error_message="$2"
  local context="${3:-}"

  INSTALLATION_ERRORS+=("[$error_type] $error_message")

  case "$error_type" in
    NODE_NOT_FOUND)
      log_error "Node.js not found"
      log_info "Attempting automatic fix..."
      fix_node_missing
      ;;
    NODE_VERSION_OLD)
      log_error "Node.js version too old: $error_message"
      log_info "Attempting automatic fix..."
      fix_node_version_old
      ;;
    NPM_NOT_FOUND)
      log_error "npm not found"
      log_info "Attempting automatic fix..."
      fix_npm_missing
      ;;
    JQ_NOT_FOUND)
      log_warning "jq not found (recommended for JSON processing)"
      log_info "Attempting automatic fix..."
      fix_jq_missing
      ;;
    PERMISSION_DENIED)
      log_error "Permission denied: $error_message"
      log_info "Attempting automatic fix..."
      fix_permission_denied "$error_message"
      ;;
    NETWORK_ERROR)
      log_error "Network error: $error_message"
      log_info "Attempting automatic fix..."
      fix_network_error
      ;;
    CONFIG_VALIDATION)
      log_error "Configuration validation failed: $error_message"
      log_info "Attempting automatic fix..."
      fix_config_validation "$error_message"
      ;;
    CLAUDE_SETTINGS_MISSING)
      log_error "Claude settings file missing"
      log_info "Attempting automatic fix..."
      fix_claude_settings_missing
      ;;
    MCP_INSTALL_FAILED)
      log_error "MCP package installation failed: $error_message"
      log_info "Attempting automatic fix..."
      fix_mcp_install_failed "$error_message"
      ;;
    ENV_VAR_INVALID)
      log_warning "Invalid environment variable: $error_message"
      log_info "Attempting automatic fix..."
      fix_env_var_invalid "$error_message"
      ;;
    *)
      log_error "Unknown error: $error_message"
      log_info "No automatic fix available"
      return 1
      ;;
  esac
}

# Fix functions
fix_node_missing() {
  log_fix "Node.js not installed"

  # Detect OS
  local os_type=$(uname -s)

  case "$os_type" in
    Darwin)
      log_info "Detected macOS. Recommending Homebrew installation..."
      echo ""
      echo "To install Node.js on macOS:"
      echo "  1. Install Homebrew (if not installed):"
      echo "     /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
      echo ""
      echo "  2. Install Node.js:"
      echo "     brew install node"
      echo ""
      read -p "Attempt automatic Homebrew installation? [y/N] " -n 1 -r
      echo ""
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        if command -v brew &> /dev/null; then
          brew install node && FIXED_ERRORS+=("NODE_NOT_FOUND") && return 0
        else
          log_error "Homebrew not found. Please install manually."
        fi
      fi
      ;;
    Linux)
      log_info "Detected Linux. Recommending package manager installation..."
      echo ""
      echo "Choose installation method:"
      echo "  1) apt (Ubuntu/Debian)"
      echo "  2) dnf (Fedora)"
      echo "  3) pacman (Arch Linux)"
      echo "  4) nvm (recommended for any distro)"
      echo ""
      read -p "Enter choice [1-4]: " choice
      case "$choice" in
        1)
          sudo apt-get update && sudo apt-get install -y nodejs npm && FIXED_ERRORS+=("NODE_NOT_FOUND") && return 0
          ;;
        2)
          sudo dnf install nodejs npm && FIXED_ERRORS+=("NODE_NOT_FOUND") && return 0
          ;;
        3)
          sudo pacman -S nodejs npm && FIXED_ERRORS+=("NODE_NOT_FOUND") && return 0
          ;;
        4)
          log_info "Installing nvm (Node Version Manager)..."
          curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
          export NVM_DIR="$HOME/.nvm"
          [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
          nvm install 18 && nvm use 18 && FIXED_ERRORS+=("NODE_NOT_FOUND") && return 0
          ;;
      esac
      ;;
    MINGW*|MSYS*|CYGWIN*)
      log_error "Windows detected. Please install Node.js from https://nodejs.org/"
      ;;
    *)
      log_error "Unknown OS: $os_type"
      log_info "Please install Node.js from https://nodejs.org/"
      ;;
  esac

  return 1
}

fix_node_version_old() {
  local current_version="$1"
  log_fix "Node.js version $current_version is too old (need 18+)"

  if command -v nvm &> /dev/null; then
    log_info "nvm detected. Upgrading Node.js..."
    nvm install 18 && nvm use 18 && nvm alias default 18
    FIXED_ERRORS+=("NODE_VERSION_OLD")
    return 0
  elif command -v brew &> /dev/null; then
    log_info "Homebrew detected. Upgrading Node.js..."
    brew upgrade node && FIXED_ERRORS+=("NODE_VERSION_OLD") && return 0
  else
    log_info "Please install Node.js 18+ using nvm (recommended):"
    echo "  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash"
    echo "  nvm install 18"
    return 1
  fi
}

fix_npm_missing() {
  log_fix "npm not found"

  if command -v node &> /dev/null; then
    log_info "Node.js is installed but npm is missing. This is unusual."
    log_info "Attempting to reinstall Node.js..."
    if command -v brew &> /dev/null; then
      brew reinstall node && FIXED_ERRORS+=("NPM_NOT_FOUND") && return 0
    fi
  else
    log_error "Please install Node.js (which includes npm)"
    return 1
  fi
}

fix_jq_missing() {
  log_fix "jq not found (optional but recommended)"

  local os_type=$(uname -s)

  case "$os_type" in
    Darwin)
      if command -v brew &> /dev/null; then
        brew install jq && FIXED_ERRORS+=("JQ_NOT_FOUND") && return 0
      else
        log_info "Install Homebrew first: https://brew.sh/"
        return 1
      fi
      ;;
    Linux)
      if command -v apt-get &> /dev/null; then
        sudo apt-get install -y jq && FIXED_ERRORS+=("JQ_NOT_FOUND") && return 0
      elif command -v dnf &> /dev/null; then
        sudo dnf install -y jq && FIXED_ERRORS+=("JQ_NOT_FOUND") && return 0
      elif command -v pacman &> /dev/null; then
        sudo pacman -S jq && FIXED_ERRORS+=("JQ_NOT_FOUND") && return 0
      else
        log_info "Please install jq using your package manager"
        return 1
      fi
      ;;
  esac

  return 1
}

fix_permission_denied() {
  local operation="$1"
  log_fix "Permission denied for: $operation"

  if [[ "$operation" == *"npm install"* ]]; then
    log_info "npm permission error. Attempting fixes..."

    # Try using sudo
    echo ""
    read -p "Try installing with sudo? [y/N] " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      log_retry "Running npm install with sudo..."
      sudo npm install -g "$operation" && FIXED_ERRORS+=("PERMISSION_DENIED") && return 0
    fi

    # Try fixing npm permissions
    log_info "Alternative: Fix npm permissions to avoid sudo"
    echo ""
    echo "Run these commands to fix npm permissions:"
    echo "  mkdir -p ~/.npm-global"
    echo "  npm config set prefix '~/.npm-global'"
    echo "  echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc  # or ~/.zshrc"
    echo ""
    read -p "Apply this fix now? [y/N] " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      mkdir -p ~/.npm-global
      npm config set prefix '~/.npm-global'
      echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc
      export PATH=~/.npm-global/bin:$PATH
      FIXED_ERRORS+=("PERMISSION_DENIED")
      log_success "npm permissions fixed. Please restart your shell."
      return 0
    fi
  elif [[ "$operation" == *"$HOME/.claude"* ]]; then
    log_info "Claude settings permission error"
    log_info "Attempting to fix permissions..."
    chmod 755 "$HOME/.claude" 2>/dev/null || true
    chmod 644 "$HOME/.claude/settings.json" 2>/dev/null || true
    FIXED_ERRORS+=("PERMISSION_DENIED")
    return 0
  fi

  return 1
}

fix_network_error() {
  log_fix "Network connectivity issue"

  log_info "Checking network connectivity..."
  if ping -c 1 8.8.8.8 &> /dev/null; then
    log_success "Internet connectivity OK"
  else
    log_error "No internet connection. Please check your network."
    return 1
  fi

  # Check if behind proxy
  if [ -n "${http_proxy:-}" ] || [ -n "${https_proxy:-}" ]; then
    log_info "Proxy detected: http_proxy=$http_proxy"
    log_info "If npm fails, configure npm to use proxy:"
    echo "  npm config set proxy $http_proxy"
    echo "  npm config set https-proxy $https_proxy"
    read -p "Configure npm proxy now? [y/N] " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      [ -n "$http_proxy" ] && npm config set proxy "$http_proxy"
      [ -n "$https_proxy" ] && npm config set https-proxy "$https_proxy"
      FIXED_ERRORS+=("NETWORK_ERROR")
      return 0
    fi
  fi

  # Try clearing npm cache
  log_info "Clearing npm cache might help..."
  npm cache clean --force && FIXED_ERRORS+=("NETWORK_ERROR") && return 0

  return 1
}

fix_config_validation() {
  local error_msg="$1"
  log_fix "Configuration validation issue"

  if [[ "$error_msg" == *"Invalid JSON"* ]]; then
    log_info "JSON syntax error in configuration"
    if [ -f "$CLAUDE_SETTINGS" ]; then
      log_info "Attempting to fix JSON syntax..."
      # Backup first
      cp "$CLAUDE_SETTINGS" "${CLAUDE_SETTINGS}.broken"
      # Try to fix with jq if available
      if command -v jq &> /dev/null; then
        # Try to parse and fix
        if jq '.' "$CLAUDE_SETTINGS" > /tmp/settings.json.tmp 2>&1; then
          mv /tmp/settings.json.tmp "$CLAUDE_SETTINGS"
          FIXED_ERRORS+=("CONFIG_VALIDATION")
          return 0
        fi
      fi
      log_error "Could not auto-fix JSON. Manual intervention required."
      log_info "Backup saved to ${CLAUDE_SETTINGS}.broken"
      return 1
    fi
  fi

  return 1
}

fix_claude_settings_missing() {
  log_fix "Claude settings file missing"

  mkdir -p "$HOME/.claude"
  echo '{}' > "$CLAUDE_SETTINGS"
  FIXED_ERRORS+=("CLAUDE_SETTINGS_MISSING")
  log_success "Created Claude settings file"
  return 0
}

fix_mcp_install_failed() {
  local package="$1"
  log_fix "MCP package installation failed: $package"

  log_info "Attempting installation fixes..."

  # Try with sudo
  echo ""
  read -p "Try installing with sudo? [y/N] " -n 1 -r
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_retry "Installing $package with sudo..."
    if sudo npm install -g "$package"; then
      FIXED_ERRORS+=("MCP_INSTALL_FAILED")
      return 0
    fi
  fi

  # Try clearing npm cache
  log_info "Clearing npm cache and retrying..."
  npm cache clean --force
  if npm install -g "$package"; then
    FIXED_ERRORS+=("MCP_INSTALL_FAILED")
    return 0
  fi

  # Try using npx instead
  log_info "Trying to use npx instead of global install..."
  log_info "Note: This will update MCP configuration to use npx"
  read -p "Configure to use npx? [y/N] " -n 1 -r
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Update configuration to use npx
    log_info "MCP will use npx for this package"
    FIXED_ERRORS+=("MCP_INSTALL_FAILED")
    return 0
  fi

  return 1
}

fix_env_var_invalid() {
  local var_name="$1"
  log_fix "Invalid environment variable: $var_name"

  log_info "Common issues:"
  echo "  1. Variable contains special characters that need quoting"
  echo "  2. Variable has trailing/leading spaces"
  echo "  3. Variable contains newline characters"
  echo ""

  read -p "Re-enter $var_name: " new_value
  if [ -n "$new_value" ]; then
    MCP_USER_CONFIGS["$var_name"]="$new_value"
    FIXED_ERRORS+=("ENV_VAR_INVALID")
    log_success "Updated $var_name"
    return 0
  fi

  return 1
}

# Retry mechanism with exponential backoff
retry_with_backoff() {
  local max_attempts=3
  local attempt=1
  local delay=1

  while [ $attempt -le $max_attempts ]; do
    if "$@"; then
      return 0
    fi

    if [ $attempt -lt $max_attempts ]; then
      log_retry "Attempt $attempt/$max_attempts failed. Retrying in ${delay}s..."
      sleep $delay
      delay=$((delay * 2))
    fi

    attempt=$((attempt + 1))
  done

  return 1
}

# Verify installation and suggest fixes
verify_and_suggest_fixes() {
  log_info "Verifying installation and checking for issues..."

  local has_issues=false

  # Check Node.js
  if ! command -v node &> /dev/null; then
    handle_error "NODE_NOT_FOUND" "Node.js not found"
    has_issues=true
  else
    local node_version=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$node_version" -lt 18 ]; then
      handle_error "NODE_VERSION_OLD" "$node_version"
      has_issues=true
    fi
  fi

  # Check npm
  if ! command -v npm &> /dev/null; then
    handle_error "NPM_NOT_FOUND" "npm not found"
    has_issues=true
  fi

  # Check jq (optional)
  if ! command -v jq &> /dev/null; then
    handle_error "JQ_NOT_FOUND" "jq not found"
    # Don't set has_issues for jq (it's optional)
  fi

  # Check Claude settings
  if [ ! -f "$CLAUDE_SETTINGS" ]; then
    handle_error "CLAUDE_SETTINGS_MISSING" "Claude settings file not found"
    has_issues=true
  fi

  # Check if settings.json is valid JSON
  if [ -f "$CLAUDE_SETTINGS" ]; then
    if ! jq empty "$CLAUDE_SETTINGS" 2>/dev/null; then
      handle_error "CONFIG_VALIDATION" "Invalid JSON in $CLAUDE_SETTINGS"
      has_issues=true
    fi
  fi

  return $([ "$has_issues" = true ] && echo 1 || echo 0)
}

# Show error summary
show_error_summary() {
  echo ""
  echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}📊 Installation Summary${NC}"
  echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
  echo ""

  if [ ${#INSTALLATION_ERRORS[@]} -eq 0 ]; then
    log_success "No errors encountered during installation!"
  else
    log_warning "Encountered ${#INSTALLATION_ERRORS[@]} error(s):"
    echo ""

    for error in "${INSTALLATION_ERRORS[@]}"; do
      echo "  • $error"
    done
    echo ""

    if [ ${#FIXED_ERRORS[@]} -gt 0 ]; then
      log_success "Fixed ${#FIXED_ERRORS[@]} error(s):"
      echo ""
      for error in "${FIXED_ERRORS[@]}"; do
        echo "  ✅ $error"
      done
      echo ""

      local remaining_errors=$((${#INSTALLATION_ERRORS[@]} - ${#FIXED_ERRORS[@]}))
      if [ $remaining_errors -eq 0 ]; then
        log_success "All errors were automatically fixed!"
      else
        log_warning "$remaining_errors error(s) remain. Please address manually."
      fi
    fi
  fi

  echo ""
}

show_banner() {
  echo -e "${BLUE}"
  echo "╔════════════════════════════════════════════════════════════╗"
  echo "║           MCP Installer - HyperBrain Skills              ║"
  echo "║     Automated MCP Server Setup for Claude Code           ║"
  echo "╚════════════════════════════════════════════════════════════╝"
  echo -e "${NC}"
}

check_prerequisites() {
  log_info "Checking prerequisites..."

  local has_errors=false

  # Check Node.js with error handling
  if ! command -v node &> /dev/null; then
    handle_error "NODE_NOT_FOUND" "Node.js not found"
    has_errors=true
  else
    local node_version=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$node_version" -lt 18 ]; then
      handle_error "NODE_VERSION_OLD" "$node_version"
      has_errors=true
    else
      log_success "Node.js $(node -v)"
    fi
  fi

  # Check npm with error handling
  if ! command -v npm &> /dev/null; then
    handle_error "NPM_NOT_FOUND" "npm not found"
    has_errors=true
  else
    log_success "npm $(npm -v)"
  fi

  # Check Python (optional)
  if command -v python3 &> /dev/null; then
    log_success "Python $(python3 --version | cut -d' ' -f2)"
  else
    log_warning "Python not found (optional for some MCPs)"
  fi

  # Check jq (optional)
  if ! command -v jq &> /dev/null; then
    handle_error "JQ_NOT_FOUND" "jq not found"
    # jq is optional, don't set has_errors
  else
    log_success "jq $(jq --version)"
  fi

  # Check Claude settings directory
  if [ ! -d "$HOME/.claude" ]; then
    log_info "Creating Claude settings directory..."
    mkdir -p "$HOME/.claude" 2>/dev/null || {
      handle_error "PERMISSION_DENIED" "$HOME/.claude"
      has_errors=true
    }
  fi

  # Create settings.json if not exists
  if [ ! -f "$CLAUDE_SETTINGS" ]; then
    log_info "Creating Claude settings file..."
    echo '{}' > "$CLAUDE_SETTINGS" 2>/dev/null || {
      handle_error "PERMISSION_DENIED" "$CLAUDE_SETTINGS"
      has_errors=true
    }
  fi

  # Validate existing settings.json
  if [ -f "$CLAUDE_SETTINGS" ]; then
    if ! jq empty "$CLAUDE_SETTINGS" 2>/dev/null; then
      handle_error "CONFIG_VALIDATION" "Invalid JSON in $CLAUDE_SETTINGS"
      has_errors=true
    fi
  fi

  # Exit if there are critical errors
  if [ "$has_errors" = true ]; then
    echo ""
    log_error "Prerequisites check failed. Please fix the errors above."
    echo ""
    read -p "Continue anyway? [y/N] " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      log_info "Installation cancelled. Please fix the errors and try again."
      exit 1
    fi
  fi

  log_success "Prerequisites check complete"
}

backup_settings() {
  log_info "Backing up Claude settings..."
  mkdir -p "$BACKUP_DIR"
  local backup_file="$BACKUP_DIR/settings.json.backup.$(date +%Y%m%d_%H%M%S)"
  cp "$CLAUDE_SETTINGS" "$backup_file"
  log_success "Backup created: $backup_file"
}

# Interactive configuration for each MCP
configure_mcp_interactive() {
  local mcp_name="$1"
  local mcp_config="$2"

  echo ""
  echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}🔧 Configuring: ${GREEN}${mcp_name}${NC}${BLUE}"
  echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
  echo ""

  # Extract MCP details
  local description=$(echo "$mcp_config" | jq -r '.description // "No description"')
  local mcp_type=$(echo "$mcp_config" | jq -r '.type // "unknown"')
  local disabled=$(echo "$mcp_config" | jq -r '.disabled // false')

  echo -e "${YELLOW}Description:${NC} $description"
  echo -e "${YELLOW}Type:${NC} $mcp_type"
  echo ""

  # Check if already configured
  local has_existing_env=false
  local existing_vars=""

  case "$mcp_name" in
    notion)
      if [ -n "${NOTION_API_KEY:-}" ]; then
        has_existing_env=true
        existing_vars="NOTION_API_KEY=****"
      fi
      ;;
    github)
      if [ -n "${GITHUB_TOKEN:-}" ]; then
        has_existing_env=true
        existing_vars="GITHUB_TOKEN=****"
      fi
      ;;
    slack)
      if [ -n "${SLACK_TOKEN:-}" ]; then
        has_existing_env=true
        existing_vars="SLACK_TOKEN=****"
      fi
      ;;
    figma-console)
      if [ -n "${FIGMA_ACCESS_TOKEN:-}" ]; then
        has_existing_env=true
        existing_vars="FIGMA_ACCESS_TOKEN=****"
      fi
      ;;
    sentinel)
      if [ -n "${SENTRY_DSN:-}" ]; then
        has_existing_env=true
        existing_vars="SENTRY_DSN=****"
      fi
      ;;
    data-proxy|morpheus)
      # These use URLs, check config
      local url=$(echo "$mcp_config" | jq -r '.url // .command // "Not configured"')
      has_existing_env=true
      existing_vars="URL/Command: $url"
      ;;
  esac

  if [ "$has_existing_env" = true ]; then
    echo -e "${GREEN}✅ Existing configuration found:${NC}"
    echo "   $existing_vars"
    echo ""
    read -p "Use existing configuration? [Y/n] " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Nn]$ ]]; then
      has_existing_env=false
    else
      log_success "Using existing configuration for $mcp_name"
      return 0
    fi
  fi

  # Ask for required configuration based on MCP type
  case "$mcp_name" in
    notion)
      echo ""
      echo -e "${YELLOW}Required for Notion MCP:${NC}"
      echo "1. NOTION_API_KEY - Notion integration token"
      echo "2. NOTION_DATABASE_ID (optional) - Default database ID"
      echo ""
      echo -e "${BLUE}Get your token:${NC} https://www.notion.so/my-integrations"
      echo ""

      read -p "Enter NOTION_API_KEY (or press Enter to skip): " notion_key
      if [ -n "$notion_key" ]; then
        MCP_USER_CONFIGS["NOTION_API_KEY"]="$notion_key"
        log_success "NOTION_API_KEY configured"
      else
        log_warning "NOTION_API_KEY not provided - Notion MCP may not work"
      fi

      read -p "Enter NOTION_DATABASE_ID (optional, press Enter to skip): " notion_db
      if [ -n "$notion_db" ]; then
        MCP_USER_CONFIGS["NOTION_DATABASE_ID"]="$notion_db"
      fi
      ;;

    github)
      echo ""
      echo -e "${YELLOW}Required for GitHub MCP:${NC}"
      echo "1. GITHUB_TOKEN - GitHub personal access token"
      echo ""
      echo -e "${BLUE}Create token:${NC} https://github.com/settings/tokens"
      echo "Required scopes: repo, read:org"
      echo ""

      read -p "Enter GITHUB_TOKEN (or press Enter to skip): " github_token
      if [ -n "$github_token" ]; then
        MCP_USER_CONFIGS["GITHUB_TOKEN"]="$github_token"
        log_success "GITHUB_TOKEN configured"
      else
        log_warning "GITHUB_TOKEN not provided - GitHub MCP may not work"
      fi
      ;;

    slack)
      echo ""
      echo -e "${YELLOW}Required for Slack MCP:${NC}"
      echo "1. SLACK_TOKEN - Slack bot token"
      echo "2. SLACK_SIGNING_SECRET - Slack signing secret"
      echo ""
      echo -e "${BLUE}Get credentials:${NC} https://api.slack.com/apps"
      echo ""

      read -p "Enter SLACK_TOKEN (or press Enter to skip): " slack_token
      if [ -n "$slack_token" ]; then
        MCP_USER_CONFIGS["SLACK_TOKEN"]="$slack_token"
        log_success "SLACK_TOKEN configured"
      else
        log_warning "SLACK_TOKEN not provided - Slack MCP may not work"
      fi

      read -p "Enter SLACK_SIGNING_SECRET (optional, press Enter to skip): " slack_secret
      if [ -n "$slack_secret" ]; then
        MCP_USER_CONFIGS["SLACK_SIGNING_SECRET"]="$slack_secret"
      fi
      ;;

    figma-console)
      echo ""
      echo -e "${YELLOW}Required for Figma Console MCP:${NC}"
      echo "1. FIGMA_ACCESS_TOKEN - Figma personal access token"
      echo ""
      echo -e "${BLUE}Get token:${NC} https://www.figma.com/developers/api#access-tokens"
      echo ""

      read -p "Enter FIGMA_ACCESS_TOKEN (or press Enter to skip): " figma_token
      if [ -n "$figma_token" ]; then
        MCP_USER_CONFIGS["FIGMA_ACCESS_TOKEN"]="$figma_token"
        log_success "FIGMA_ACCESS_TOKEN configured"
      else
        log_warning "FIGMA_ACCESS_TOKEN not provided - Figma MCP may not work"
      fi
      ;;

    sentinel)
      echo ""
      echo -e "${YELLOW}Required for Sentinel MCP (Sentry):${NC}"
      echo "1. SENTRY_DSN - Sentry DSN"
      echo "2. SENTRY_AUTH_TOKEN - Sentry auth token (optional)"
      echo "3. SENTRY_ORG - Sentry organization (optional)"
      echo "4. SENTRY_PROJECT - Sentry project ID (optional)"
      echo ""
      echo -e "${BLUE}Get credentials:${NC} https://sentry.io/settings/"
      echo ""

      read -p "Enter SENTRY_DSN (or press Enter to skip): " sentry_dsn
      if [ -n "$sentry_dsn" ]; then
        MCP_USER_CONFIGS["SENTRY_DSN"]="$sentry_dsn"
        log_success "SENTRY_DSN configured"
      else
        log_warning "SENTRY_DSN not provided - Sentinel MCP may not work"
      fi

      read -p "Enter SENTRY_AUTH_TOKEN (optional, press Enter to skip): " sentry_token
      if [ -n "$sentry_token" ]; then
        MCP_USER_CONFIGS["SENTRY_AUTH_TOKEN"]="$sentry_token"
      fi

      read -p "Enter SENTRY_ORG (optional, press Enter to skip): " sentry_org
      if [ -n "$sentry_org" ]; then
        MCP_USER_CONFIGS["SENTRY_ORG"]="$sentry_org"
      fi

      read -p "Enter SENTRY_PROJECT (optional, press Enter to skip): " sentry_project
      if [ -n "$sentry_project" ]; then
        MCP_USER_CONFIGS["SENTRY_PROJECT"]="$sentry_project"
      fi
      ;;

    data-proxy)
      local url=$(echo "$mcp_config" | jq -r '.args[1] // "http://localhost:8100/sse"')
      echo ""
      echo -e "${YELLOW}Data Proxy MCP Configuration:${NC}"
      echo "This MCP connects to a local SSE proxy for database access."
      echo "Default URL: $url"
      echo ""
      echo -e "${BLUE}Requirements:${NC}"
      echo "- VPN connection (if accessing remote server)"
      echo "- Database credentials configured in the proxy"
      echo ""

      read -p "Use default URL? [Y/n] " -n 1 -r
      echo ""
      if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        MCP_USER_CONFIGS["DATA_PROXY_URL"]="$url"
        log_success "Data Proxy URL configured: $url"
      else
        read -p "Enter custom Data Proxy URL: " custom_url
        MCP_USER_CONFIGS["DATA_PROXY_URL"]="$custom_url"
        log_success "Data Proxy URL configured: $custom_url"
      fi
      ;;

    morpheus)
      local url=$(echo "$mcp_config" | jq -r '.url // "https://cody.smartjoules.org/sse"')
      echo ""
      echo -e "${YELLOW}Morpheus MCP Configuration:${NC}"
      echo "This MCP provides knowledge graph and codebase search capabilities."
      echo "Server URL: $url"
      echo ""
      echo -e "${BLUE}Note:${NC} Morpheus typically doesn't require authentication."
      echo "If your Morpheus instance requires authentication, please contact your administrator."
      echo ""

      read -p "Use default Morpheus configuration? [Y/n] " -n 1 -r
      echo ""
      if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        MCP_USER_CONFIGS["MORPHEUS_URL"]="$url"
        log_success "Morpheus URL configured: $url"
      else
        read -p "Enter custom Morpheus URL: " custom_url
        MCP_USER_CONFIGS["MORPHEUS_URL"]="$custom_url"
        log_success "Morpheus URL configured: $custom_url"
      fi
      ;;

    *)
      log_warning "No specific configuration required for $mcp_name"
      ;;
  esac

  echo ""
  log_success "Configuration complete for $mcp_name"
}

# Interactive prompt for each MCP
prompt_mcp_installation() {
  local mcp_name="$1"
  local mcp_config="$2"
  local mcp_type="$3"  # "always-on" or "on-demand"

  echo ""
  echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}📦 Found MCP: ${GREEN}${mcp_name}${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
  echo ""

  # Display MCP information
  local description=$(echo "$mcp_config" | jq -r '.description // "No description"')
  local mcp_type_tag=$(echo "$mcp_config" | jq -r '.type // "unknown"')
  local required=$(echo "$mcp_config" | jq -r '.required // false')

  echo -e "${YELLOW}Description:${NC}   $description"
  echo -e "${YELLOW}Type:${NC}          $mcp_type_tag"
  echo -e "${YELLOW}Required:${NC}      $required"
  echo -e "${YELLOW}Category:${NC}      $mcp_type"
  echo ""

  # Show what's needed
  echo -e "${BLUE}📋 This MCP requires:${NC}"
  case "$mcp_name" in
    notion)
      echo "  • NOTION_API_KEY (required)"
      echo "  • Notion integration token from https://www.notion.so/my-integrations"
      ;;
    github)
      echo "  • GITHUB_TOKEN (required)"
      echo "  • Personal access token from https://github.com/settings/tokens"
      echo "  • Required scopes: repo, read:org"
      ;;
    slack)
      echo "  • SLACK_TOKEN (required)"
      echo "  • Bot token from https://api.slack.com/apps"
      echo "  • SLACK_SIGNING_SECRET (optional)"
      ;;
    figma-console)
      echo "  • FIGMA_ACCESS_TOKEN (required)"
      echo "  • Personal access token from https://www.figma.com/developers/api"
      ;;
    sentinel)
      echo "  • SENTRY_DSN (required)"
      echo "  • SENTRY_AUTH_TOKEN (optional)"
      echo "  • Credentials from https://sentry.io/settings/"
      ;;
    data-proxy)
      echo "  • VPN connection (if accessing remote server)"
      echo "  • Database proxy URL (default: http://10.40.21.254:8100/sse)"
      ;;
    morpheus)
      echo "  • Server URL (default: https://cody.smartjoules.org/sse)"
      echo "  • No authentication typically required"
      ;;
    *)
      echo "  • Standard installation"
      ;;
  esac
  echo ""

  # Ask for confirmation
  if [ "$mcp_type" = "always-on" ]; then
    echo -e "${YELLOW}This is an always-on MCP and will start automatically with Claude Code.${NC}"
  else
    echo -e "${YELLOW}This is an on-demand MCP and will activate when you use trigger keywords.${NC}"
  fi
  echo ""

  read -p "Install and configure $mcp_name? [Y/n] " -n 1 -r
  echo ""

  if [[ $REPLY =~ ^[Nn]$ ]]; then
    log_warning "Skipping $mcp_name"
    return 1
  fi

  # If user wants to install, configure it interactively
  configure_mcp_interactive "$mcp_name" "$mcp_config"
  return 0
}

discover_mcp_configs() {
  log_info "Discovering MCP configurations..."

  local configs=()

  # Always-on MCPs
  if [ -f "$MCP_CONFIG_DIR/mcp-config.json" ]; then
    configs+=("$MCP_CONFIG_DIR/mcp-config.json")
    log_success "Found always-on MCP config"
  fi

  # On-demand MCPs
  if [ -f "$MCP_ONDEMAND_DIR/mcp-config.json" ]; then
    configs+=("$MCP_ONDEMAND_DIR/mcp-config.json")
    log_success "Found on-demand MCP config"
  fi

  if [ ${#configs[@]} -eq 0 ]; then
    log_error "No MCP configurations found in $REPO_ROOT"
    exit 1
  fi

  log_success "Found ${#configs[@]} MCP configuration(s)"
  printf '%s\n' "${configs[@]}"
}

install_npm_packages() {
  log_info "Installing npm-based MCP packages..."

  # Core MCP packages
  local packages=(
    "@modelcontextprotocol/server-notion"
    "@modelcontextprotocol/server-github"
    "@modelcontextprotocol/server-slack"
  )

  for pkg in "${packages[@]}"; do
    log_info "Installing $pkg..."

    # Check if already installed
    if npm list -g "$pkg" &> /dev/null; then
      log_success "$pkg already installed"
      continue
    fi

    # Try installation with retry
    if retry_with_backoff npm install -g "$pkg"; then
      log_success "$pkg installed"
    else
      # Handle failure with automatic fix attempt
      if handle_error "MCP_INSTALL_FAILED" "$pkg"; then
        # Fix was attempted, check if successful
        if npm list -g "$pkg" &> /dev/null; then
          log_success "$pkg installed (after fix)"
        else
          log_warning "$pkg installation failed. You can install it later manually."
        fi
      else
        log_warning "$pkg installation failed. You can install it later manually."
      fi
    fi
  done

  log_success "npm packages installation complete"
}

install_mcp_servers() {
  log_info "Installing MCP servers..."

  local configs=("$@")
  local mcp_servers="{}"
  local mcp_type="$2"

  # Parse each config file and prompt for each MCP
  for config_file in "${configs[@]}"; do
    if [ -f "$config_file" ]; then
      log_info "Processing $config_file..."

      # Get all MCP server names from this config
      if command -v jq &> /dev/null; then
        local mcp_names=$(jq -r '.mcpServers | keys[]' "$config_file" 2>/dev/null || echo "")

        for mcp_name in $mcp_names; do
          # Get MCP config
          local mcp_config=$(jq ".mcpServers[\"$mcp_name\"]" "$config_file")

          # Determine if always-on or on-demand
          local required=$(echo "$mcp_config" | jq -r '.required // false')
          local category="on-demand"
          if [ "$required" = "true" ]; then
            category="always-on"
          fi

          # Skip if user specified --type and this doesn't match
          if [ "$mcp_type" != "all" ] && [ "$mcp_type" != "$category" ]; then
            log_info "Skipping $mcp_name (type: $category, requested: $mcp_type)"
            continue
          fi

          # Interactive prompt
          if prompt_mcp_installation "$mcp_name" "$mcp_config" "$category"; then
            # User confirmed, add to installation list
            mcp_servers=$(jq --arg name "$mcp_name" --argjson config "$mcp_config" '. + {($name): $config}' <<< "$mcp_servers")
          fi
        done
      fi
    fi
  done

  # Check if any MCPs were selected
  local mcp_count=$(echo "$mcp_servers" | jq 'length' 2>/dev/null || echo "0")
  if [ "$mcp_count" -eq 0 ]; then
    log_warning "No MCP servers selected for installation"
    return 1
  fi

  log_success "Installing $mcp_count MCP server(s)"

  # Update Claude settings
  log_info "Updating Claude settings..."
  if command -v jq &> /dev/null; then
    # Merge existing mcpServers with new ones
    local temp_file=$(mktemp)
    jq --argjson mcp "$mcp_servers" '.mcpServers = $mcp' "$CLAUDE_SETTINGS" > "$temp_file"
    mv "$temp_file" "$CLAUDE_SETTINGS"
    log_success "Claude settings updated"
  else
    log_warning "jq not found. Please manually merge MCP config into $CLAUDE_SETTINGS"
    echo ""
    echo "Add this to your $CLAUDE_SETTINGS:"
    echo ""
    echo "$mcp_servers"
    echo ""
  fi
}

create_env_file() {
  log_info "Creating environment file..."

  local env_file="$ENV_FILE"

  # Create .env file with user-provided values
  {
    echo "# MCP Server Environment Variables"
    echo "# Generated by MCP Installer on $(date)"
    echo "# Load this file with: source $env_file"
    echo ""

    if [ -n "${MCP_USER_CONFIGS[NOTION_API_KEY]:-}" ]; then
      echo "# Notion MCP"
      echo "export NOTION_API_KEY=\"${MCP_USER_CONFIGS[NOTION_API_KEY]}\""
      if [ -n "${MCP_USER_CONFIGS[NOTION_DATABASE_ID]:-}" ]; then
        echo "export NOTION_DATABASE_ID=\"${MCP_USER_CONFIGS[NOTION_DATABASE_ID]}\""
      fi
      echo ""
    fi

    if [ -n "${MCP_USER_CONFIGS[GITHUB_TOKEN]:-}" ]; then
      echo "# GitHub MCP"
      echo "export GITHUB_TOKEN=\"${MCP_USER_CONFIGS[GITHUB_TOKEN]}\""
      echo ""
    fi

    if [ -n "${MCP_USER_CONFIGS[SLACK_TOKEN]:-}" ]; then
      echo "# Slack MCP"
      echo "export SLACK_TOKEN=\"${MCP_USER_CONFIGS[SLACK_TOKEN]}\""
      if [ -n "${MCP_USER_CONFIGS[SLACK_SIGNING_SECRET]:-}" ]; then
        echo "export SLACK_SIGNING_SECRET=\"${MCP_USER_CONFIGS[SLACK_SIGNING_SECRET]}\""
      fi
      echo ""
    fi

    if [ -n "${MCP_USER_CONFIGS[FIGMA_ACCESS_TOKEN]:-}" ]; then
      echo "# Figma Console MCP"
      echo "export FIGMA_ACCESS_TOKEN=\"${MCP_USER_CONFIGS[FIGMA_ACCESS_TOKEN]}\""
      echo ""
    fi

    if [ -n "${MCP_USER_CONFIGS[SENTRY_DSN]:-}" ]; then
      echo "# Sentinel MCP (Sentry)"
      echo "export SENTRY_DSN=\"${MCP_USER_CONFIGS[SENTRY_DSN]}\""
      if [ -n "${MCP_USER_CONFIGS[SENTRY_AUTH_TOKEN]:-}" ]; then
        echo "export SENTRY_AUTH_TOKEN=\"${MCP_USER_CONFIGS[SENTRY_AUTH_TOKEN]}\""
      fi
      if [ -n "${MCP_USER_CONFIGS[SENTRY_ORG]:-}" ]; then
        echo "export SENTRY_ORG=\"${MCP_USER_CONFIGS[SENTRY_ORG]}\""
      fi
      if [ -n "${MCP_USER_CONFIGS[SENTRY_PROJECT]:-}" ]; then
        echo "export SENTRY_PROJECT=\"${MCP_USER_CONFIGS[SENTRY_PROJECT]}\""
      fi
      echo ""
    fi

    if [ -n "${MCP_USER_CONFIGS[DATA_PROXY_URL]:-}" ]; then
      echo "# Data Proxy MCP"
      echo "export DATA_PROXY_URL=\"${MCP_USER_CONFIGS[DATA_PROXY_URL]}\""
      echo ""
    fi

    if [ -n "${MCP_USER_CONFIGS[MORPHEUS_URL]:-}" ]; then
      echo "# Morpheus MCP"
      echo "export MORPHEUS_URL=\"${MCP_USER_CONFIGS[MORPHEUS_URL]}\""
      echo ""
    fi

  } > "$env_file"

  log_success "Environment file created: $env_file"

  # Also create example file with placeholders
  local env_example="$ENV_EXAMPLE_FILE"
  cp "$env_file" "$env_example"

  # Replace actual values with placeholders in example
  sed -i.bak 's/"[^"]*"/"YOUR_VALUE_HERE"/g' "$env_example"
  rm -f "${env_example}.bak"

  log_success "Environment example created: $env_example"
}

verify_installation() {
  log_info "Verifying MCP installation..."

  if [ ! -f "$CLAUDE_SETTINGS" ]; then
    log_error "Claude settings not found"
    return 1
  fi

  if command -v jq &> /dev/null; then
    local mcp_count=$(jq '.mcpServers | length' "$CLAUDE_SETTINGS" 2>/dev/null || echo "0")
    log_success "MCP servers configured: $mcp_count"

    # List configured MCPs
    jq -r '.mcpServers | keys[]' "$CLAUDE_SETTINGS" 2>/dev/null | while read -r mcp; do
      local disabled=$(jq -r ".mcpServers[\"$mcp\"].disabled // false" "$CLAUDE_SETTINGS")
      local required=$(jq -r ".mcpServers[\"$mcp\"].required // false" "$CLAUDE_SETTINGS")
      local status="✅"
      if [ "$disabled" = "true" ]; then
        status="⏸️ "
      fi
      echo -e "  ${status} ${mcp} (required: ${required})"
    done
  else
    log_warning "Install jq for detailed verification"
  fi

  log_success "Verification complete"
}

show_next_steps() {
  echo ""
  log_info "Next steps:"
  echo ""

  if [ -s "$ENV_FILE" ]; then
    echo "1. Load environment variables:"
    echo "   source $ENV_FILE"
    echo ""
    echo "   Or add to your shell profile (~/.bashrc or ~/.zshrc):"
    echo "   echo 'source $ENV_FILE' >> ~/.zshrc"
    echo ""
  else
    echo "1. No environment variables were configured."
    echo "   You can add them later to $ENV_FILE"
    echo ""
  fi

  echo "2. Restart Claude Code"
  echo ""
  echo "3. Test MCP servers:"
  echo "   ./mcp-installer/bin/install-mcps.sh test"
  echo ""
  echo "4. Use MCPs in conversations:"
  echo "   - Use Morpheus to query knowledge graphs"
  echo "   - Use data-proxy to query databases"
  echo "   - Get Figma designs"
  echo "   - Check system health with Sentinel"
  echo ""

  # Show summary of configured MCPs
  if [ ${#MCP_USER_CONFIGS[@]} -gt 0 ]; then
    echo "✅ Configured with ${#MCP_USER_CONFIGS[@]} environment variable(s):"
    for key in "${!MCP_USER_CONFIGS[@]}"; do
      echo "   - $key"
    done
    echo ""
  fi
}

install_all() {
  show_banner
  check_prerequisites

  local install_type="${1:-all}"
  local include="${2:-}"
  local exclude="${3:-}"
  local auto_confirm="${4:-false}"

  log_info "Installation type: $install_type"

  if [ "$auto_confirm" != "true" ]; then
    echo ""
    read -p "Continue with installation? [y/N] " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      log_info "Installation cancelled"
      exit 0
    fi
  fi

  backup_settings

  local configs=()
  if [ "$install_type" = "all" ] || [ "$install_type" = "always-on" ]; then
    if [ -f "$MCP_CONFIG_DIR/mcp-config.json" ]; then
      configs+=("$MCP_CONFIG_DIR/mcp-config.json")
    fi
  fi

  if [ "$install_type" = "all" ] || [ "$install_type" = "on-demand" ]; then
    if [ -f "$MCP_ONDEMAND_DIR/mcp-config.json" ]; then
      configs+=("$MCP_ONDEMAND_DIR/mcp-config.json")
    fi
  fi

  if [ ${#configs[@]} -eq 0 ]; then
    log_error "No MCP configurations found"
    exit 1
  fi

  install_npm_packages
  if install_mcp_servers "${configs[@]}" "$install_type"; then
    create_env_file
    verify_installation
    show_next_steps
    show_error_summary
    log_success "Installation complete!"
  else
    show_error_summary
    log_warning "Installation cancelled - no MCP servers selected"
    exit 0
  fi
}

show_status() {
  show_banner

  log_info "MCP Installation Status"
  echo ""

  if [ ! -f "$CLAUDE_SETTINGS" ]; then
    log_error "Claude settings not found: $CLAUDE_SETTINGS"
    log_info "Run: /mcp-installer install"
    exit 1
  fi

  if command -v jq &> /dev/null; then
    local mcp_count=$(jq '.mcpServers | length' "$CLAUDE_SETTINGS" 2>/dev/null || echo "0")
    echo "Total MCP Servers: $mcp_count"
    echo ""

    jq -r '.mcpServers | to_entries[] | @json' "$CLAUDE_SETTINGS" 2>/dev/null | while read -r entry; do
      local name=$(echo "$entry" | jq -r '.key')
      local disabled=$(echo "$entry" | jq -r '.value.disabled // false')
      local required=$(echo "$entry" | jq -r '.value.required // false')
      local description=$(echo "$entry" | jq -r '.value.description // "No description"')

      if [ "$disabled" = "true" ]; then
        echo -e "⏸️  ${YELLOW}${name}${NC} (disabled)"
      elif [ "$required" = "true" ]; then
        echo -e "✅ ${GREEN}${name}${NC} (always-on)"
      else
        echo -e "🔄 ${BLUE}${name}${NC} (on-demand)"
      fi
      echo "   $description"
      echo ""
    done
  else
    log_warning "Install jq for detailed status"
  fi
}

show_help() {
  show_banner
  cat << EOF
Usage: /mcp-installer <command> [options]

Commands:
  install              Install all MCP servers
  status               Show installation status
  test                 Test MCP server connections
  list                 List all configured MCPs
  update               Update MCP servers
  uninstall            Uninstall MCP servers
  backup               Backup configuration
  help                 Show this help message

Options for 'install':
  --type TYPE          MCP type [always-on|on-demand|all] (default: all)
  --include SERVERS    Comma-separated MCPs to include
  --exclude SERVERS    Comma-separated MCPs to exclude
  --claude-settings    Custom Claude settings path
  --yes                Auto-confirm all prompts
  --dry-run            Show what would be installed
  --verbose            Verbose output
  --force              Reinstall even if exists

Examples:
  /mcp-installer install                    # Install all MCPs
  /mcp-installer install --type always-on  # Install always-on only
  /mcp-installer install --include "morpheus,data-proxy"
  /mcp-installer status                     # Show status
  /mcp-installer test                       # Test connections

Environment Variables:
  CLAUDE_SETTINGS_PATH     Custom Claude settings path
  PYTHON_MCP_EXECUTABLE    Python executable path
  NODE_MCP_EXECUTABLE      Node.js executable path
  MCP_INSTALL_DIR          Installation directory

EOF
}

# Main
main() {
  local command="${1:-help}"
  shift || true

  case "$command" in
    install)
      local install_type="all"
      local include=""
      local exclude=""
      local auto_confirm="false"

      while [[ $# -gt 0 ]]; do
        case $1 in
          --type)
            install_type="$2"
            shift 2
            ;;
          --include)
            include="$2"
            shift 2
            ;;
          --exclude)
            exclude="$2"
            shift 2
            ;;
          --yes)
            auto_confirm="true"
            shift
            ;;
          *)
            shift
            ;;
        esac
      done

      install_all "$install_type" "$include" "$exclude" "$auto_confirm"
      ;;
    status)
      show_status
      ;;
    test)
      log_info "Testing MCP connections..."
      log_warning "Test feature coming soon!"
      log_info "For now, verify by using MCPs in Claude Code"
      ;;
    list)
      show_status
      ;;
    help|--help|-h)
      show_help
      ;;
    *)
      log_error "Unknown command: $command"
      echo ""
      show_help
      exit 1
      ;;
  esac
}

main "$@"
