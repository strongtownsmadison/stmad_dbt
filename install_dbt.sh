#!/bin/bash

# DBT Setup Script
# This script sets up a Python environment with dbt-core and dbt-postgres

set -e  # Exit on any error

echo "🚀 Starting DBT setup..."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Python based on OS
install_python() {
    echo "📦 Installing Python..."
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command_exists brew; then
            brew install python3
        else
            echo "❌ Homebrew not found. Please install Homebrew first or install Python manually."
            echo "Visit: https://brew.sh/"
            exit 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        if command_exists apt-get; then
            # Debian/Ubuntu
            sudo apt-get update
            sudo apt-get install -y python3 python3-pip python3-venv
        elif command_exists yum; then
            # CentOS/RHEL
            sudo yum install -y python3 python3-pip python3-venv
        elif command_exists dnf; then
            # Fedora
            sudo dnf install -y python3 python3-pip python3-venv
        elif command_exists pacman; then
            # Arch Linux
            sudo pacman -S python python-pip
        else
            echo "❌ Unsupported Linux distribution. Please install Python manually."
            exit 1
        fi
    else
        echo "❌ Unsupported operating system: $OSTYPE"
        echo "Please install Python manually and re-run this script."
        exit 1
    fi
}

# 1. Check if Python is installed, install if not found
echo "🔍 Checking for Python installation..."
if command_exists python3; then
    PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
    echo "✅ Python $PYTHON_VERSION found"
elif command_exists python; then
    PYTHON_VERSION=$(python --version 2>&1 | cut -d' ' -f2)
    if [[ $PYTHON_VERSION == 3.* ]]; then
        echo "✅ Python $PYTHON_VERSION found"
        # Create alias for consistency
        alias python3=python
    else
        echo "❌ Python 2.x detected. Python 3.x is required."
        install_python
    fi
else
    echo "❌ Python not found"
    install_python
fi

# 2. Create Python virtual environment
echo "🏗️  Creating virtual environment..."
if [ -d ".venv" ]; then
    echo "⚠️  Virtual environment '.venv' already exists. Removing it..."
    rm -rf .venv
fi

python3 -m venv .venv
echo "✅ Virtual environment created"

# 4. Install dbt packages
echo "📥 Installing dbt packages..."
python -m pip install --upgrade pip
python -m pip install dbt-core dbt-postgres
echo "✅ dbt-core and dbt-postgres installed"

# 5. Create profiles.yml
echo "📄 Creating dbt profiles.yml..."

# Create .dbt directory if it doesn't exist
mkdir -p ~/.dbt

# Create profiles.yml with template
cat > ~/.dbt/profiles.yml << 'EOL'
# DBT Profiles Configuration
# Edit the values below to match your PostgreSQL database configuration

default:
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
dbt --version