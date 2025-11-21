# Ruby on Rails + Claude Swarm Template

A GitHub template repository with a complete Rails 8 application pre-configured with [Claude Swarm](https://github.com/parruda/swarm) for AI-assisted development. Clone this template and start building with multiple specialized AI agents collaborating on your codebase.

## What is Claude Swarm?

Claude Swarm is a Ruby framework that orchestrates multiple AI agents working together as a team. Each agent has specialized roles (developer, reviewer, DBA) and can delegate tasks to each other, creating a collaborative AI development environment.

## Features

- **Rails 8** - Latest Rails with modern defaults
- **Claude Swarm** - Multi-agent AI collaboration pre-configured
- **SQLite** - Simple database setup, easy to migrate to PostgreSQL
- **Docker Development** - Fully containerized development environment (recommended)
- **Ready to Deploy** - Kamal and Thruster included

## Prerequisites

### For Docker Development (Recommended)

- Docker and Docker Compose installed
- Claude CLI authenticated: `npm install -g @anthropic-ai/claude-code && claude login`

### For Local Development

- Ruby 3.2+
- Bundler
- Claude CLI: `npm install -g @anthropic-ai/claude-code && claude login`

## Quick Start (Docker)

### 1. Clone the Template

```bash
git clone https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git
cd YOUR-REPO-NAME
docker compose build
```

### 2. Start Development Shell

```bash
docker compose run --rm dev
```

Inside the container:

```bash
# Set up the app
bundle install

# Generate your swarm configuration
# IMPORTANT: The included claude-swarm.yml is for template maintenance only
claude-swarm generate

# Start using Claude Swarm
claude-swarm -p "Add a User model with email and password authentication"
```

### 3. Run Your App

In another terminal:

```bash
docker compose profile "" up -d
```

Visit http://localhost:3000

## Development Workflow

Use the `dev` service for all development work:

```bash
# Start development shell
docker compose run --rm dev

# Inside the container:
rails generate controller Pages home
rails generate model Post title:string
rails db:migrate
bundle add devise
claude-swarm -p "Build a REST API for posts"
```

The dev container gives you a bash shell with access to:
- Rails commands
- Database migrations
- Claude Swarm
- Bundle commands

All code changes sync between your host and container automatically.

## Running Your App

Start the Rails server to test what you built:

```bash
# Start Rails server
docker compose up web

# Or in background
docker compose up -d web

# View logs
docker compose logs -f web

# Stop
docker compose down
```

The Rails server runs on http://localhost:3000 with hot-reloading enabled.

## Using Claude Swarm

### Generate Your Configuration

**IMPORTANT:** You must generate your own swarm configuration for your project:

```bash
# Inside dev container
claude-swarm generate
```

This creates a `claude-swarm.yml` tailored for your application. The included file is for template maintenance only.

### Interactive Mode

```bash
claude-swarm
```

### Task Mode

```bash
claude-swarm -p "Build a RESTful API for blog posts with CRUD operations"
claude-swarm -p "Add user authentication with JWT tokens"
claude-swarm -p "Write RSpec tests for the Comment model"
```

### Swarm Configuration

After running `claude-swarm generate`, customize your `claude-swarm.yml`:

- **description** - The instance's role and responsibilities
- **model** - "sonnet" or "opus"
- **directory** - Working directory (usually ".")
- **connections** - Which instances this one can communicate with
- **allowed_tools** - Available tools (Read, Write, Edit, Bash)

Example agent types:
- **developer** - Implements features and writes code
- **reviewer** - Reviews for security, performance, and best practices
- **dba** - Handles database schema and queries

## Quick Start (Local Development)

```bash
# Clone and install
git clone https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git
cd YOUR-REPO-NAME
bundle install

# Set up database
rails db:create db:migrate

# Authenticate Claude CLI
claude login

# Generate your swarm configuration
claude-swarm generate

# Start using swarm
claude-swarm -p "Add a User model with email and password authentication"
```

## Converting to API-Only Mode

Edit `config/application.rb`:

```ruby
config.api_only = true
```

Edit `app/controllers/application_controller.rb`:

```ruby
class ApplicationController < ActionController::API
end
```

Remove from `Gemfile`:

```ruby
gem 'propshaft'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'jbuilder'
gem 'image_processing'
gem 'web-console'
```

Run `bundle install` and remove asset directories:

```bash
rm -rf app/assets app/views app/helpers app/javascript
```

## Docker Commands Reference

```bash
# Development
docker compose run --rm dev              # Open dev shell
docker compose run --rm dev rails console   # Run one command

# Running the app
docker compose up web                    # Start Rails server
docker compose up -d web                 # Start in background
docker compose logs -f web               # View logs
docker compose down                      # Stop

# Cleanup
docker compose down -v                   # Remove volumes (complete reset)
docker compose build --no-cache          # Rebuild from scratch
```

## Troubleshooting

**Claude authentication not working:**
Run `claude login` on your host machine first. The container mounts your Claude config.

**Permission errors:**
```bash
sudo chown -R 1000:1000 .
```

**Reset everything:**
```bash
docker compose down -v
docker compose build
```

## Production Deployment

Use the regular `Dockerfile` for production (without Claude Swarm):

```bash
docker build -t my-rails-app .
docker run -p 80:80 -e RAILS_MASTER_KEY=<your-key> my-rails-app
```

## Learn More

- [Claude Swarm Documentation](https://github.com/parruda/swarm)
- [Rails Guides](https://guides.rubyonrails.org/)
- [Anthropic API Docs](https://docs.anthropic.com/)

## License

This template is provided as-is for creating your own projects.
