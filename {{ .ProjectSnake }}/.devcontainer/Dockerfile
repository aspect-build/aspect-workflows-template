# Start with the standard devcontainers base (Ubuntu-based)
FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install dependencies (direnv + curl for downloading bazelisk)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       direnv curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install bazelisk (latest release)
RUN curl -L https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64 \
      -o /usr/local/bin/bazelisk \
    && chmod +x /usr/local/bin/bazelisk \
    && ln -s /usr/local/bin/bazelisk /usr/local/bin/bazel

# Install Buildifier (always latest)
# Even though bazel_env.bzl will download buildifier, the VSCode extension will complain if it's not
# found on the PATH in the environment where the editor is running.
RUN curl -L https://github.com/bazelbuild/buildtools/releases/latest/download/buildifier-linux-amd64 \
      -o /usr/local/bin/buildifier \
    && chmod +x /usr/local/bin/buildifier

# Hook direnv into bash (default Codespaces shell)
RUN echo 'eval "$(direnv hook bash)"' >> /etc/bash.bashrc
