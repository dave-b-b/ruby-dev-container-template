#!/bin/bash
set -e

# Development entrypoint script for Docker container
# This script automatically sets up the development environment and starts Rails

echo "🚀 Starting Rails development environment..."

# Function to check if bundle is properly installed
check_bundle() {
  if ! bundle check &>/dev/null; then
    return 1
  fi
  return 0
}

# Function to check if database exists
check_database() {
  if ! rails db:version &>/dev/null; then
    return 1
  fi
  return 0
}

# 1. Check and install gems if needed
echo "📦 Checking gems..."
if ! check_bundle; then
  echo "📦 Installing missing gems..."
  bundle install
  echo "✅ Gems installed successfully"
else
  echo "✅ All gems are already installed"
fi

# 2. Prepare the database
echo "🗄️  Checking database..."
if ! check_database; then
  echo "🗄️  Setting up database..."
  rails db:create
  rails db:migrate
  rails db:seed 2>/dev/null || true  # Seed only if seeds.rb exists, ignore if not
  echo "✅ Database setup complete"
else
  echo "🗄️  Running pending migrations..."
  rails db:migrate
  echo "✅ Database is up to date"
fi

# 3. Clean up any stale server pid files
if [ -f tmp/pids/server.pid ]; then
  echo "🧹 Removing stale server.pid file..."
  rm -f tmp/pids/server.pid
fi

# 4. Start the Rails server or execute passed command
if [ $# -eq 0 ]; then
  echo "🚀 Starting Rails server on http://0.0.0.0:3000"
  echo "📝 Access your application at http://localhost:3000"
  exec rails server -b 0.0.0.0
else
  # If arguments are passed, execute them instead
  exec "$@"
fi