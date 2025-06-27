# Secrets Management

## Overview

Proper secrets management ensures sensitive data like API keys and tokens are never committed to version control.

## Environment Setup

### Local Development

1. **Create .env file**
   ```bash
   cp .env.example .env
   ```

2. **Add your secrets**
   ```bash
   # Edit .env with actual values
   HONEYCOMB_API_KEY=your-actual-key
   GEMINI_API_KEY=your-actual-key
   DATABASE_URL=postgresql://user:pass@localhost/db
   ```

3. **Verify .gitignore**
   ```bash
   # Ensure .env is ignored
   grep "^\.env$" .gitignore
   ```

### GitHub Codespaces

Use GitHub CLI to set repository secrets:

```bash
# Set individual secrets
gh secret set HONEYCOMB_API_KEY --app codespaces
gh secret set GEMINI_API_KEY --app codespaces
gh secret set DATABASE_URL --app codespaces

# List configured secrets
gh secret list --app codespaces
```

## Common Secrets

### API Keys
```bash
# AI/ML Services
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...
GEMINI_API_KEY=AI...

# Monitoring
HONEYCOMB_API_KEY=hcaik_... # or hcbik_ for EU
HONEYCOMB_DATASET=your-dataset

# External Services
TAVILY_API_KEY=tvly-...
STRIPE_API_KEY=sk_live_...
```

### Database Credentials
```bash
# PostgreSQL
DATABASE_URL=postgresql://user:password@host:5432/dbname

# Redis
REDIS_URL=redis://user:password@host:6379/0

# MongoDB
MONGODB_URI=mongodb://user:password@host:27017/dbname
```

### Cloud Provider Credentials
```bash
# AWS
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...
AWS_REGION=us-east-1

# Google Cloud
GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json
GCP_PROJECT_ID=your-project

# Azure
AZURE_CLIENT_ID=...
AZURE_CLIENT_SECRET=...
AZURE_TENANT_ID=...
```

## Best Practices

### 1. Use .env.example
Always maintain an `.env.example` with dummy values:
```bash
# .env.example
HONEYCOMB_API_KEY=your-honeycomb-key-here
DATABASE_URL=postgresql://localhost/dev
STRIPE_API_KEY=sk_test_dummy_key
```

### 2. Environment-Specific Secrets
```bash
# Development
DATABASE_URL=postgresql://localhost/dev_db

# Staging
DATABASE_URL=postgresql://staging-host/staging_db

# Production
DATABASE_URL=postgresql://prod-host/prod_db
```

### 3. Secret Rotation
- Rotate secrets regularly
- Update in all environments
- Use secret management tools for automation

### 4. Validation
Add startup checks:
```python
import os
import sys

required_vars = [
    'DATABASE_URL',
    'REDIS_URL',
    'SECRET_KEY'
]

missing = [var for var in required_vars if not os.getenv(var)]
if missing:
    print(f"Missing required environment variables: {', '.join(missing)}")
    sys.exit(1)
```

## Security Guidelines

### Never Commit
- Real API keys or tokens
- Database passwords
- SSL certificates or private keys
- Internal URLs with credentials
- Personal access tokens

### Safe Practices
- Use environment variables exclusively
- Keep production secrets separate
- Limit secret access by environment
- Audit secret usage regularly
- Use secret scanning tools

## Loading Secrets

### Automatic Loading
The devcontainer setup automatically loads `.env`:
- Local: Sources `.env` file on shell start
- Codespaces: Uses GitHub secrets

### Manual Loading
```bash
# Load in current shell
source .env

# Export specific variable
export API_KEY="value"

# Load with dotenv (Python)
from dotenv import load_dotenv
load_dotenv()
```

## Troubleshooting

### Secrets Not Loading
```bash
# Check if .env exists
ls -la .env

# Reload shell configuration
source ~/.bashrc

# Verify variables loaded
env | grep YOUR_VAR
```

### Wrong Environment
```bash
# Check current environment
echo $ENVIRONMENT

# In Codespaces?
echo $CODESPACES
```

### Permission Issues
```bash
# Fix .env permissions
chmod 600 .env
```

## CI/CD Secrets

### GitHub Actions
```yaml
env:
  DATABASE_URL: ${{ secrets.DATABASE_URL }}
  API_KEY: ${{ secrets.API_KEY }}
```

### Repository Secrets
```bash
# Set for Actions
gh secret set DATABASE_URL

# Set for Dependabot
gh secret set NPM_TOKEN --app dependabot
```

## Secret Management Tools

Consider using dedicated tools for production:
- HashiCorp Vault
- AWS Secrets Manager
- Azure Key Vault
- Google Secret Manager
- Kubernetes Secrets

These provide:
- Centralized management
- Access control
- Audit logging
- Automatic rotation
- Encryption at rest