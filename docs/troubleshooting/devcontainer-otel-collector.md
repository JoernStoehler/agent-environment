# Troubleshooting: OTEL Collector Not Starting in Dev Container

## Problem
When using VS Code Dev Containers with docker-compose, the OTEL collector service fails to start automatically, resulting in the error:
```
❌ ERROR: OTEL collector is not running!
   This should not happen - the devcontainer should have started it automatically.
```

## Root Cause
There is a known VS Code bug where the `runServices` property in `devcontainer.json` is sometimes ignored, preventing dependent services from starting. This affects multi-service docker-compose setups.

Related issues:
- https://github.com/microsoft/vscode-remote-release/issues/9118
- https://github.com/microsoft/vscode-remote-release/issues/5295

## Solution
Remove the `runServices` property from `devcontainer.json` to let it default to starting all services:

```diff
 {
   "name": "Agent Environment",
   "dockerComposeFile": "docker-compose.yml",
   "service": "devcontainer",
-  "runServices": ["devcontainer", "otlp"],
+  // "runServices": ["devcontainer", "otlp"],  // Defaults to all services
   "workspaceFolder": "/workspaces",
```

When `runServices` is not specified, VS Code correctly starts all services defined in `docker-compose.yml`.

## Failed Attempts
The following approaches were tried but did not resolve the issue:

1. **Adding `shutdownAction: "none"`** - Prevents VS Code from stopping services but doesn't help with initial startup
2. **Using `depends_on` with health checks** - May cause timing issues with VS Code's container lifecycle management
3. **Explicitly listing services in `runServices`** - Triggers the VS Code bug

## Workaround (if needed)
If the issue persists, you can manually start the OTEL collector in a postCreateCommand script:

```bash
#!/bin/bash
# Start OTEL collector if not already running
if ! docker ps | grep -q -E "(otlp|otel)"; then
    cd /workspaces/agent-environment/.devcontainer
    docker compose up -d otlp
fi
```

## Verification
After rebuilding the devcontainer, verify the OTEL collector is running:
```bash
docker ps | grep -E "(otlp|otel)"
```

You should see the collector container running with exposed ports 4317, 4318, and 13133.

## Additional Notes
- The OTEL collector must have the health_check extension configured for proper health monitoring
- Ensure the collector configuration includes all necessary extensions and pipelines
- The `restart: unless-stopped` policy helps keep the collector running if it crashes