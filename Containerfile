FROM registry.redhat.io/rhel10/rhel-bootc:10.1

# Avoid interactive prompts
ENV container=podman

# Install dependencies
RUN dnf install -y \
    curl \
    tar \
    gzip \
    git \
    nodejs \
    shadow-utils \
    && dnf clean all

# Create non-root user (recommended for OpenClaw)
RUN useradd -m -u 1001 openclaw
USER openclaw
WORKDIR /home/openclaw

# Install OpenClaw (official install script)
RUN curl -fsSL https://openclaw.ai/install.sh | bash -s -- --no-onboard --verbose --npm --version "v2026.3.12"

# Expose default gateway port
EXPOSE 18789

# Add nodejs memory to 4G
ENV NODE_OPTIONS="--max-old-space-size=4096"

# Default command: run gateway in foreground (better for containers)
CMD ["openclaw", "gateway", "--port", "18789"]
