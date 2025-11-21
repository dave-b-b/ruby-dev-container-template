# Ruby on Rails + Claude Swarm Template

A GitHub template repository with a complete Rails 8 application pre-configured with [Claude Swarm](https://github.com/parruda/swarm) for AI-assisted development. Clone this template and start building with multiple specialized AI agents collaborating on your codebase.

## What is Claude Swarm?

Claude Swarm is a Ruby framework that orchestrates multiple AI agents working together as a team. Each agent has specialized roles (developer, reviewer, DBA) and can delegate tasks to each other, creating a collaborative AI development environment.

## Features

- **Rails 8** - Latest Rails with modern defaults
- **Claude Swarm** - Multi-agent AI collaboration pre-configured
- **SQLite** - Simple database setup, easy to migrate to PostgreSQL
- **Docker Support** - Optional containerized development
- **Ready to Deploy** - Kamal and Thruster included

## Prerequisites

- Ruby 3.2+
- Bundler
- Node.js and npm (for Claude CLI)
- Claude CLI: `npm install -g @anthropic-ai/claude-code`
- Anthropic API key ([get one here](https://console.anthropic.com/))

## Quick Start

### 1. Create from Template

Click **"Use this template"** on GitHub, or clone directly:

```bash
git clone https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git
cd YOUR-REPO-NAME
```

### 2. Set API Key

```bash
export ANTHROPIC_API_KEY='your-api-key-here'
```

Make it permanent by adding to your shell profile:

```bash
echo 'export ANTHROPIC_API_KEY="your-api-key-here"' >> ~/.zshrc
```

### 3. Install Dependencies

```bash
bundle install
```

### 4. Setup Database

```bash
rails db:create db:migrate
```

### 5. Authenticate Claude CLI

```bash
claude login
```

### 6. Configure Claude Swarm

Copy the example configuration:

```bash
cp claude-swarm.yml.example claude-swarm.yml
```

Edit `claude-swarm.yml` to customize your AI agents.

### 7. Start Using Swarm!

Run swarm with a task:

```bash
claude-swarm -p "Add a User model with email and password authentication"
```

Or run interactively:

```bash
claude-swarm
```

## Converting to API-Only Mode

This template includes a full-stack Rails app. To convert it to API-only:

### 1. Enable API Mode

Edit `config/application.rb`:

```ruby
config.api_only = true
```

### 2. Update Application Controller

Edit `app/controllers/application_controller.rb`:

```ruby
class ApplicationController < ActionController::API
end
```

### 3. Remove Unneeded Gems

Remove from `Gemfile`:

```ruby
gem 'propshaft'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'jbuilder'
gem 'image_processing'
gem 'web-console'  # from development group
```

Then run:

```bash
bundle install
```

### 4. Remove Asset Directories

```bash
rm -rf app/assets app/views app/helpers app/javascript
```

### 5. Done!

Your app is now API-only. Controllers will return JSON by default.

## Using Claude Swarm

### Interactive Mode

Chat with your AI team:

```bash
claude-swarm
```

### Task Mode

Give specific instructions:

```bash
claude-swarm -p "Build a RESTful API for blog posts with CRUD operations"
claude-swarm -p "Add user authentication with JWT tokens"
claude-swarm -p "Write RSpec tests for the Comment model"
```

### Swarm Configuration

The `claude-swarm.yml` file defines your AI instances (agents). The example includes:

- **developer** - Implements features and writes code
- **reviewer** - Reviews for security, performance, and best practices
- **dba** - Handles database schema and queries

Customize instances by editing their:
- **description** - The instance's role and responsibilities
- **model** - "sonnet" or "opus"
- **directory** - Working directory (usually ".")
- **connections** - Which instances this one can communicate with
- **allowed_tools** - Available tools (Read, Write, Edit, Bash)

## Example Workflows

### Build a Feature

```bash
claude-swarm -p "Create a REST API for managing tasks with:
- Task model (title, description, status, due_date)
- TasksController with full CRUD
- Validation and error handling
- RSpec tests"
```

### Code Review

```bash
claude-swarm -p "Review the entire codebase for:
- Security vulnerabilities
- N+1 queries
- Missing indexes
- Test coverage gaps"
```

### Database Optimization

```bash
claude-swarm -p "Optimize database performance:
- Add missing indexes
- Fix N+1 queries
- Improve slow queries
- Ensure migration reversibility"
```

### Additional Commands

```bash
claude-swarm ps                    # List running swarm sessions
claude-swarm list-sessions         # View all past sessions
claude-swarm clean                 # Remove stale sessions
claude-swarm init                  # Generate template config
claude-swarm --vibe                # Run with all tools enabled (skip permissions)
```

## Development

Start the Rails server:

```bash
rails server
```

Run tests:

```bash
rails test
```

## Docker Development (Recommended for Isolation)

For maximum security, run Claude Swarm in an isolated Docker container that can't access your host machine.

### Prerequisites

- Docker and Docker Compose installed
- Anthropic API key
- Claude CLI authenticated on your host (`claude login`)

### Quick Start with Docker

**1. Set your API key:**

```bash
export ANTHROPIC_API_KEY='your-api-key-here'
```

**2. Build and start the container:**

```bash
docker compose build
docker compose run --rm rails-dev
```

**3. Inside the container, install dependencies:**

```bash
bundle install
```

**4. Set up database:**

```bash
rails db:create db:migrate
```

**5. Configure Claude Swarm:**

```bash
cp claude-swarm.yml.example claude-swarm.yml
# Edit claude-swarm.yml as needed
```

**6. Run Claude Swarm:**

```bash
claude-swarm -p "Your task here"
```

### Docker Workflow

The Docker setup provides:

- **Isolation** - Claude Swarm runs in a sandboxed container
- **Non-root user** - Container runs as user `developer` (UID 1000)
- **Limited capabilities** - Minimal Linux capabilities for security
- **Volume mounts** - Your code is mounted from the host, changes sync both ways
- **Gem caching** - Dependencies cached in a volume for faster rebuilds

### Common Docker Commands

```bash
# Start interactive shell
docker compose run --rm rails-dev

# Run a one-off command
docker compose run --rm rails-dev rails console

# Run Rails server (accessible at http://localhost:3000)
docker compose run --rm --service-ports rails-dev rails server -b 0.0.0.0

# Run tests
docker compose run --rm rails-dev rails test

# Run Claude Swarm with a task
docker compose run --rm rails-dev claude-swarm -p "Add User model"

# Rebuild after changing Dockerfile.dev
docker compose build

# Clean up containers and volumes
docker compose down -v
```

### Security Features

The Docker setup includes several security layers:

1. **Container isolation** - Swarm can't access your host filesystem (except mounted code)
2. **Non-root execution** - All processes run as `developer` user
3. **Capability restrictions** - Only essential Linux capabilities enabled
4. **Read-only mounts** - Claude config mounted read-only
5. **Network isolation** - Container has its own network namespace

### Troubleshooting

**Claude authentication not working:**

Make sure you've run `claude login` on your host machine first. The Docker container mounts your Claude config from `~/.config/claude`.

**Permission errors:**

The container runs as UID 1000. If you have permission issues:

```bash
# On host, fix file ownership
sudo chown -R 1000:1000 .
```

**Gems not installing:**

Clear the gem cache volume:

```bash
docker compose down -v
docker compose build
```

## Production Deployment

For production deployment (without Claude Swarm), use the regular `Dockerfile`:

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
