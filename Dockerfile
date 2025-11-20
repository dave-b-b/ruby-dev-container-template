FROM ruby:3.3-slim

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    git \
    curl \
    libpq-dev \
    libsqlite3-dev \
    libvips \
    nodejs \
    npm \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

# Set up working directory
WORKDIR /workspace

# Install bundler and claude_swarm gem globally
# Note: Rails apps are created locally and mounted, not in the container
RUN gem install bundler claude_swarm

# Set up non-root user for security
RUN useradd -m -s /bin/bash developer && \
    chown -R developer:developer /workspace

# Switch to non-root user
USER developer

# Set GEM_HOME for user-installed gems (via bundle install)
# GEM_PATH includes both user gems and system gems
ENV GEM_HOME="/home/developer/.gems"
ENV GEM_PATH="/home/developer/.gems:/usr/local/bundle"
ENV PATH="/home/developer/.gems/bin:/usr/local/bundle/bin:/usr/local/bin:$PATH"

# Default command
CMD ["/bin/bash"]
