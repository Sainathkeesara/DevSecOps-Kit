# Jenkins CLI Commands: Credential Rotation and Security Updates

## Purpose

This reference provides Jenkins CLI commands for automated credential rotation and security updates. It covers credential management, password/token rotation, security configuration updates, and automation scripts for maintaining Jenkins security posture.

## When to use

- Automating credential rotation in Jenkins
- Updating secrets and API tokens periodically
- Bulk credential management across Jenkins instances
- Security configuration updates and compliance
- Integrating credential rotation into CI/CD pipelines

## Prerequisites

- Jenkins controller running (Linux/Windows)
- `jenkins-cli.jar` or REST API access
- Jenkins user with Admin permissions (for credential management)
- API token configured for authentication

---

## Credential Management Commands

### List All Credentials

```bash
# Via REST API
curl -s -u "$USER:$TOKEN" \
  "$URL/credentials/store/system/domain/_/api/json" | \
  jq '.credentials[] | {id: .id, type: .typeName, description: .description}'

# Using Jenkins CLI
java -jar jenkins-cli.jar -s $URL list-credentials
```

### Get Credential Details

```bash
# Get specific credential
curl -s -u "$USER:$TOKEN" \
  "$URL/credentials/store/system/domain/_/credential/$CRED_ID/api/json"
```

### Create Username/Password Credential

```bash
# Create via REST
curl -s -X POST -u "$USER:$TOKEN" \
  -H "Content-Type: application/x-form-encoded" \
  -d "json={
    \"credentials\": {
      \"scope\": \"GLOBAL\",
      \"id\": \"new-creds-id\",
      \"username\": \"deploy-user\",
      \"password\": \"new-password\",
      \"description\": \"Rotated credential\"
    }
  }" \
  "$URL/credentials/store/system/domain/_/createCredentials"
```

### Update Existing Credential

```bash
# First get current config
curl -s -u "$USER:$TOKEN" \
  "$URL/credentials/store/system/domain/_/credential/$CRED_ID/api/json" | \
  jq . > current_credential.json

# Update via system groovy script
curl -s -X POST -u "$USER:$TOKEN" \
  --data-urlencode "script=
import com.cloudbees.plugins.credentials.Credentials
import com.cloudbees.plugins.credentials.domains.Domain
import com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl

def credentialsStore = com.cloudbees.plugins.credentials.CredentialsProvider.lookupStores(Jenkins.instance).first()
def domain = credentialsStore.getDomainHolder().getDomain('Global')

def newCred = new UsernamePasswordCredentialsImpl(
  Credentials.Scope.GLOBAL,
  'updated-creds-id',
  'Updated description',
  'new-username',
  'new-password'
)
credentialsStore.addCredentials(domain, newCred)
" \
  "$URL/scriptText"
```

---

## API Token Management

### List User API Tokens

```bash
# Get user API tokens
curl -s -u "$USER:$TOKEN" \
  "$URL/user/$TARGET_USER/api/json?tree=apiToken"

# Via Jenkins CLI
java -jar jenkins-cli.jar -s $URL get-credentials "system:global" -i $CRED_ID
```

### Create New API Token

```bash
# Create token via REST
curl -s -X POST -u "$USER:$PASSWORD" \
  -H "Content-Type: application/x-form-encoded" \
  -d "newTokenName=automation-token-$(date +%Y%m%d)" \
  "$URL/user/$USER/descriptorByName/jenkins.security.ApiTokenProperty/generateToken"

# Response contains token value - parse it
TOKEN_VALUE=$(curl -s -X POST -u "$USER:$PASSWORD" \
  -H "Content-Type: application/x-form-encoded" \
  -d "newTokenName=automation-token" \
  "$URL/user/$USER/descriptorByName/jenkins.security.ApiTokenProperty/generateToken" | \
  jq -r '.tokenValue')
```

### Revoke API Token

```bash
# Revoke specific token
curl -s -X POST -u "$USER:$TOKEN" \
  -H "Content-Type: application/x-form-encoded" \
  -d "tokenUuid=$TOKEN_UUID" \
  "$URL/user/$USER/descriptorByName/jenkins.security.ApiTokenProperty/revoke"
```

---

## Password Rotation Automation

### Script: Rotate All User Passwords

```bash
#!/usr/bin/env bash
set -euo pipefail

JENKINS_URL="${JENKINS_URL:-http://localhost:8080}"
USER="${JENKINS_USER:-admin}"
TOKEN="${JENKINS_TOKEN}"

rotate_password() {
  local target_user="$1"
  local new_password="$2"
  
  # Generate new API token as replacement
  response=$(curl -s -X POST -u "$USER:$TOKEN" \
    -H "Content-Type: application/x-form-encoded" \
    -d "newTokenName=rotated-$(date +%s)" \
    "$URL/user/$target_user/descriptorByName/jenkins.security.ApiTokenProperty/generateToken")
  
  echo "$response" | jq -r '.tokenValue // empty'
}

# List users and rotate tokens
users=$(curl -s -u "$USER:$TOKEN" "$JENKINS_URL/api/json?tree=users[name]" | \
  jq -r '.users[].name')

for user in $users; do
  if [[ "$user" != "admin" ]]; then
    new_token=$(rotate_password "$user")
    echo "Rotated token for $user: ${new_token:0:10}..."
  fi
done
```

### Script: Scheduled Credential Rotation

```bash
#!/usr/bin/env bash
# credential-rotation.sh - Run as cron job
# Schedule: 0 0 1 * * (monthly)

set -euo pipefail

CRED_IDS=("deploy-key" "github-token" "docker-hub" "aws-creds")
JENKINS_URL="${JENKINS_URL:-http://localhost:8080}"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

rotate_credential() {
  local cred_id="$1"
  local new_secret="$2"
  
  # Update via Groovy script
  curl -s -X POST -u "$USER:$TOKEN" \
    --data-urlencode "script=
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.impl.*
import jenkins.model.Jenkins

def store = CredentialsProvider.lookupStore(Jenkins.instance)
def cred = store.getCredentials(com.cloudbees.plugins.credentials.domains.Domain.global()).find{it.id == '$cred_id'}

if (cred) {
  // Update password/secret field based on credential type
  cred.password = new hudson.util.Secret('$new_secret')
  store.updateCredentials(com.cloudbees.plugins.credentials.domains.Domain.global(), cred, cred)
  println 'Updated: $cred_id'
} else {
  println 'Not found: $cred_id'
}
" \
    "$JENKINS_URL/scriptText"
}

for cred_id in "${CRED_IDS[@]}"; do
  log "Rotating credential: $cred_id"
  new_secret=$(openssl rand -base64 32)
  rotate_credential "$cred_id" "$new_secret"
done
```

---

## Security Configuration Updates

### Update Global Security Settings

```bash
# Enable remoting
curl -s -X POST -u "$USER:$TOKEN" \
  -H "Content-Type: application/x-form-encoded" \
  -d "_.enableSecurity=true" \
  "$URL/configureSecurity/configure"

# Disable CLI
curl -s -X POST -u "$USER:$TOKEN" \
  -H "Content-Type: application/x-form-encoded" \
  -d "_.enableCli=false" \
  "$URL/configureSecurity/configure"
```

### Update CSRF Protection

```bash
# Enable crumb validation
curl -s -X POST -u "$USER:$TOKEN" \
  -H "Content-Type: application/xml" \
  -d '@<project>
    <usecrumb>true</usecrumb>
    <crumbSessionScope>HUDSON</crumbSessionScope>
  </project>' \
  "$URL/manage/jenkins/security/configure"

# Get CSRF crumb
CRUMB=$(curl -s -u "$USER:$TOKEN" \
  "$JENKINS_URL/crumb/api/json" | jq -r '.crumb')
```

### Update Authorization Strategy

```bash
# Set to Matrix-based security
curl -s -X POST -u "$USER:$TOKEN" \
  -H "Content-Type: application/x-form-encoded" \
  -d "_.useSecurity=true&_.authorizationStrategy=globalMatrix" \
  "$URL/configureSecurity/configure"
```

---

## Bulk Credential Operations

### Export Credentials (Backup)

```bash
#!/usr/bin/env bash
# export-credentials.sh

JENKINS_URL="${JENKINS_URL:-http://localhost:8080}"
OUTPUT_FILE="jenkins-credentials-$(date +%Y%m%d).json"

curl -s -u "$USER:$TOKEN" \
  "$JENKINS_URL/credentials/store/system/domain/_/api/json" | \
  jq '[.credentials[] | {id: .id, type: .typeName, description: .description}]' \
  > "$OUTPUT_FILE"

echo "Exported to $OUTPUT_FILE"
```

### Import Credentials (Restore)

```bash
#!/usr/bin/env bash
# import-credentials.sh

jq -c '.[]' credentials.json | while read -r cred; do
  id=$(echo "$cred" | jq -r '.id')
  username=$(echo "$cred" | jq -r '.username // empty')
  password=$(echo "$cred" | jq -r '.password // empty')
  
  curl -s -X POST -u "$USER:$TOKEN" \
    -H "Content-Type: application/x-form-encoded" \
    -d "json={
      \"credentials\": {
        \"scope\": \"GLOBAL\",
        \"id\": \"$id\",
        \"username\": \"$username\",
        \"password\": \"$password\",
        \"description\": \"Imported\"
      }
    }" \
    "$JENKINS_URL/credentials/store/system/domain/_/createCredentials"
done
```

### Rotate Credentials by Pattern

```bash
#!/usr/bin/env bash
# rotate-by-pattern.sh

PATTERN="${1:-service-*}"
JENKINS_URL="${JENKINS_URL:-http://localhost:8080}"

credentials=$(curl -s -u "$USER:$TOKEN" \
  "$JENKINS_URL/credentials/store/system/domain/_/api/json" | \
  jq -r ".credentials[] | select(.id | test(\"$PATTERN\")) | .id")

for cred_id in $credentials; do
  echo "Rotating: $cred_id"
  new_secret=$(openssl rand -base64 32)
  
  # Update via REST
  curl -s -X PUT -u "$USER:$TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"password\": \"$new_secret\"}" \
    "$JENKINS_URL/credentials/store/system/domain/_/credential/$cred_id/"
done
```

---

## Security Updates

### Check for Plugin Security Warnings

```bash
# Get plugin security warnings
curl -s -u "$USER:$TOKEN" \
  "$URL/pluginManager/checkUpdates" | \
  jq '.data[] | select(.hasSecurityWarning == true)'

# Via CLI
java -jar jenkins-cli.jar -s $URL list-plugins | grep -i security
```

### Update Security Realm

```bash
# Switch to LDAP
curl -s -X POST -u "$USER:$TOKEN" \
  -H "Content-Type: application/x-form-encoded" \
  -d "_.realm=org.jenkinsci.plugins.security_realm.LdapRealm&..." \
  "$URL/configureSecurity/configure"
```

### Enable Audit Logging

```bash
# Configure audit logger
curl -s -X POST -u "$USER:$TOKEN" \
  --data-urlencode "script=
import jenkins.security.AuditListener
import hudson.logging.LogRecorder
import java.util.logging.Logger

class AuditLogger implements AuditListener {
  void record(String event) {
    Logger.getLogger('jenkins.audit').info(event)
  }
}

Jenkins.instance.getExtensionList(AuditListener.class).add(new AuditLogger())
" \
  "$URL/scriptText"
```

---

## Verify

### Verify Credential Update

```bash
# Test credential works - example for username/password
TEST_RESULT=$(curl -s -u "$USER:$NEW_TOKEN" "$JENKINS_URL/api/json")
if echo "$TEST_RESULT" | jq -e '.mode' > /dev/null 2>&1; then
  echo "Credential rotation successful"
else
  echo "Credential rotation failed"
  exit 1
fi
```

### Verify Security Settings

```bash
# Check CSRF protection
curl -s -u "$USER:$TOKEN" "$JENKINS_URL/api/json?tree=crumbRequestField" | \
  jq -r '.crumbRequestField // "not enabled"'

# Check CLI enabled
CLI_ENABLED=$(curl -s -u "$USER:$TOKEN" \
  "$JENKINS_URL/api/json?tree=cliPortEnabled")
echo "$CLI_ENABLED"
```

## Rollback

### Revert Credential Changes

```bash
# Restore from backup
bash import-credentials.sh backup-credentials.json

# Revert security settings
curl -s -X POST -u "$USER:$TOKEN" \
  -H "Content-Type: application/x-form-encoded" \
  -d "_.enableSecurity=false" \
  "$URL/configureSecurity/configure"
```

## Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `403 Forbidden` | No credentials permission | Ensure user has Credentials/Manage permission |
| `401 Unauthorized` | Invalid token | Regenerate API token at user configuration |
| `Credential not found` | Wrong credential ID | Verify credential ID via list-credentials |
| `Script approval required` | Groovy script blocked | Approve script in Manage Jenkins > In-process Script Approval |
| `Domain not found` | Invalid domain | Use 'Global' domain for system credentials |

---

## References

- Jenkins Credentials Plugin: https://plugins.jenkins.io/credentials/
- Jenkins Security: https://www.jenkins.io/doc/book/security/
- Jenkins API Token: https://www.jenkins.io/doc/book/security/api-token/