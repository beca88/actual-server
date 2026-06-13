# Stage 1: Base - install dependencies
# Uses full bookworm image for openssl compatibility with yarn workspaces
FROM node:18-bookworm AS base

RUN apt-get update && apt-get install -y openssl

WORKDIR /app

# Copy dependency files first (layer caching optimisation)
COPY .yarn ./.yarn
COPY yarn.lock package.json .yarnrc.yml ./

# Install production dependencies only
RUN yarn workspaces focus --all --production

# Stage 2: Production - lean final image
# Uses slim variant to reduce attack surface and image size
FROM node:18-bookworm-slim AS prod

# Install tini as PID 1 process manager (handles signal forwarding)
RUN apt-get update && apt-get install tini && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Create non-root user for security (principle of least privilege)
ARG USERNAME=actual
ARG USER_UID=1001
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

# Create data directory with correct ownership
RUN mkdir /data && chown -R ${USERNAME}:${USERNAME} /data

WORKDIR /app

ENV NODE_ENV=production
# Data directory for persistent budget files
ENV ACTUAL_DATA_DIR=/data

# Copy only production node_modules from base stage
COPY --from=base /app/node_modules /app/node_modules

# Copy application source files
COPY package.json app.js ./
COPY src ./src
COPY migrations ./migrations

# Switch to non-root user
USER ${USERNAME}

# Use tini as entrypoint for proper signal handling in containers
ENTRYPOINT ["/usr/bin/tini", "-g", "--"]

# Expose Actual Budget default port
EXPOSE 5006

CMD ["node", "app.js"]
