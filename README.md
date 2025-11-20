# Ruby Dev Container Template

A containerized development environment for running claude-on-rails and claude-swarm safely, with full isolation from your host system.

## Features

- Ruby 3.3 with Rails support
- Claude Swarm for running multiple AI agents
- Claude-on-Rails integration
- Docker Compose orchestration
- VS Code Dev Container support
- Isolated environment protecting your host system

## Prerequisites

- Docker and Docker Compose installed
- VS Code with Remote Containers extension (optional)
- Claude Code installed and authenticated (run `claude login` if not already logged in)

## Quick Start

### Method 1: Using Docker Compose

1. Create your Rails app locally (on your host machine):
```bash
# Install Rails if you haven't already
gem install rails

# Create a new Rails app in your desired location
rails new myapp
cd myapp
```

2. Make sure you're logged in to Claude:
```bash
# Login to Claude if you haven't already
claude login
```

3. Navigate to this template directory and start the container:
```bash
cd /path/to/ruby-dev-container-template
docker compose build
docker compose run --rm claude-dev
```

4. Inside the container, navigate to your Rails app and run claude-swarm:
```bash
# Your local files are mounted at /workspace
cd /workspace

# Generate a claude-swarm.yml configuration file
claude-swarm generate

# Edit the generated file if needed, then start the swarm
claude-swarm start
```

### Method 2: Using VS Code Dev Container

1. Open your Rails app folder in VS Code
2. Copy the `.devcontainer` folder to your Rails app
3. When prompted, click "Reopen in Container"
4. Your app runs in an isolated container while files stay on your host

## Usage

### Running Claude Swarm

The container provides an isolated sandbox for claude-swarm to work in. Your Rails app files live on your host machine and are mounted into the container.

**First Time Setup:**
```bash
# Inside the container, navigate to your project
cd /workspace/your-rails-app

# Generate a claude-swarm.yml configuration file
claude-swarm generate

# Edit claude-swarm.yml to customize for your project
# Or copy the example configuration if preferred
# cp /workspace/claude-swarm.yml.example ./claude-swarm.yml
```

**Running Claude Swarm:**
```bash
# Start claude-swarm with multiple agents
claude-swarm start

# Or specify a custom config file
claude-swarm start my-config.yml

# View running sessions
claude-swarm ps

# Watch a specific session
claude-swarm watch SESSION_ID
```

### Working with Rails Apps

```bash
# Inside the container, install gems for your Rails app
bundle install

# Run Rails commands
rails server
rails console
rails test
```

Changes made by claude-swarm are written to your mounted local files, but the execution happens safely inside the container.

## Typical Workflow

1. **Create/have a Rails app on your local machine** (outside the container)
2. **Start the container** from this template directory:
   ```bash
   docker compose run --rm claude-dev
   ```
3. **Inside the container**, your current directory is mounted at `/workspace`
4. **Navigate to your Rails app** if it's in a subdirectory
5. **Run claude-swarm** to work on your code:
   ```bash
   claude-swarm generate    # First time only - generates claude-swarm.yml
   claude-swarm start       # Start the swarm
   ```
6. **Changes are written to your local files** on the host machine
7. **Exit the container** when done - your code stays on your host

## Security

The container runs as a non-root user (`developer`) for security. All changes are isolated to the container and mounted workspace directory. Claude-swarm cannot access anything outside the mounted directory, protecting your host system.

## Customization

- Edit `Dockerfile` to add additional system dependencies
- Modify `docker-compose.yml` to add services (databases, Redis, etc.)
- Update `.devcontainer/devcontainer.json` for VS Code preferences
