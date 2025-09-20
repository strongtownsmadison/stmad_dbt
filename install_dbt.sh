#!/bin/bash

# DBT Setup Script with uv
# This script sets up a Python environment with dbt-core and dbt-postgres using uv

set -e  # Exit on any error

echo "🚀 Starting DBT setup with uv..."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install uv based on OS
install_uv() {
    echo "📦 Installing uv..."
    
    if command_exists curl; then
        curl -LsSf https://astral.sh/uv/install.sh | sh
        # Add uv to PATH for current session
        export PATH="$HOME/.local/bin:$PATH"
    elif command_exists wget; then
        wget -qO- https://astral.sh/uv/install.sh | sh
        # Add uv to PATH for current session
        export PATH="$HOME/.local/bin:$PATH"
    else
        echo "❌ Neither curl nor wget found. Please install one of them first."
        echo "Or install uv manually: https://docs.astral.sh/uv/getting-started/installation/"
        exit 1
    fi
    
    # Verify installation
    if command_exists uv; then
        echo "✅ uv installed successfully"
    else
        echo "❌ uv installation failed. Please install manually."
        echo "Visit: https://docs.astral.sh/uv/getting-started/installation/"
        exit 1
    fi
}

# 1. Check if uv is installed, install if not found
echo "🔍 Checking for uv installation..."
if command_exists uv; then
    UV_VERSION=$(uv --version 2>&1)
    echo "✅ $UV_VERSION found"
else
    echo "❌ uv not found"
    install_uv
fi

# 2. Check if pyproject.toml exists
if [ ! -f "pyproject.toml" ]; then
    echo "❌ pyproject.toml not found. Please create it first."
    echo "Run this script from a directory containing pyproject.toml"
    exit 1
fi

# 3. Create/sync virtual environment with uv
echo "🏗️  Creating virtual environment with uv..."
uv sync
echo "✅ Virtual environment created and dependencies installed"

# 4. Create profiles.yml
echo "📄 Creating dbt profiles.yml..."

# Create .dbt directory if it doesn't exist
mkdir -p ~/.dbt

# Create profiles.yml with template
cat > ~/.dbt/profiles.yml << 'EOL'
# DBT Profiles Configuration
# Edit the values below to match your PostgreSQL database configuration

stmad_dbt:
  outputs:
    dev:
      type: postgres
      host: madison-data.house
      user: "{{env_var('DBT_USER')}}"
      password: "{{env_var('DBT_PASSWORD')}}"
      port: 5432
      dbname: postgres
      schema: "dev_{{env_var('DBT_USER')}}"
      threads: 4
      keepalives_idle: 0
    
    prod:
      type: postgres
      host: madison-data.house
      user: "{{env_var('DBT_USER')}}"
      password: "{{env_var('DBT_PASSWORD')}}"
      port: 5432
      dbname: postgres
      schema: public
      threads: 4
      keepalives_idle: 0
  
  target: dev
EOL

echo "✅ profiles.yml created at ~/.dbt/profiles.yml"

# Display next steps
echo ""
echo "🎉 DBT setup complete!"
echo ""
echo "📋 Next steps:"
echo "   Set environment variables for database credentials:"
echo "   export DBT_USER=your_username"
echo "   export DBT_PASSWORD=your_password"
echo ""
echo "🔧 The profiles.yml uses environment variables:"
echo "   - DBT_USER: Your database username"
echo "   - DBT_PASSWORD: Your database password"
echo ""
echo ""
echo "To get started on development run:"
echo "   source ./dbt_start_dev.sh"
echo ""
echo "🔍 Verify installation:"
uv run dbt --version