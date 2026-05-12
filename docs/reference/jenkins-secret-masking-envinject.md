# Jenkins Secret Credential Masking in Build Logs with EnvInject

## Purpose

This reference provides configuration patterns for masking sensitive credentials in Jenkins build logs using the EnvInject plugin. It covers environment variable injection, secret masking configuration, and automated credential handling to prevent sensitive data exposure in console output.

## When to use

- Masking API tokens, passwords, and secrets in build console output
- Injecting credentials from Jenkins credentials store into build environment
- Preventing secret exposure in logs for compliance (PCI-DSS, SOC2, HIPAA)
- Secure handling of deployment credentials, SSH keys, and database passwords
- Redacting environment variables during CI/CD pipeline execution

## Prerequisites

- Jenkins controller running (2.x or later)
- EnvInject plugin installed (version 2.4.0 or later)
- Credentials Plugin for credential management
- Appropriate Jenkins permissions (Admin or Job Configure)

---

## EnvInject Plugin Installation

### Install via Jenkins CLI

```bash
# Install EnvInject plugin
jenkins-plugin-cli --install envinject

# Or using Jenkins CLI
java -jar jenkins-cli.jar install-plugin envinject -deploy
```

### Install via Web UI

1. Navigate to **Manage Jenkins** → **Manage Plugins**
2. Select **Available** tab
3. Search for "EnvInject"
4. Check "EnvInject Plugin" and click **Install**
5. Restart Jenkins if required

---

## Basic Secret Masking Configuration

### Configure Global Secret Masking

Navigate to: **Manage Jenkins** → **Configure System** → **Environment Injector**

```groovy
# Enable secret masking globally
# Add to Jenkins startup properties:
-Dhudson.tasks.logger.enableHideSensitive=true
```

### Job-Level Secret Injection

**Pipeline (Jenkinsfile):**

```groovy
pipeline {
    agent any
    
    environment {
        // Direct secret injection (not recommended for production)
        // DB_PASSWORD = credentials('db-password')
        
        // Masked via EnvInject
        MASKED_SECRET = credentials('masked-api-token')
    }
    
    stages {
        stage('Build') {
            steps {
                echo "Building with masked credentials..."
                sh '''
                    echo "DB_HOST: ${DB_HOST}"
                    # DB_PASSWORD will appear as ***** in logs
                    echo "Running migration..."
                '''
            }
        }
    }
}
```

**Freestyle Job Configuration:**

1. Add **Build Environment** → **Inject environment variables**
2. Add properties file path or inline properties:

```properties
# secrets.properties
DB_PASSWORD=SecretP@ssw0rd123!
API_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
AWS_SECRET_KEY=abcdefghijklmnopqrstuvwxyz1234567890
```

---

## Masking Secrets from Credentials Store

### Using Credentials Binding

```groovy
pipeline {
    agent any
    
    environment {
        // Bind credentials to environment variables
        // Values are automatically masked in console output
        MAVEN_REPO_CREDS = credentials('maven-repo-credentials')
        DOCKER_REGISTRY_CREDS = credentials('docker-hub-creds')
    }
    
    stages {
        stage('Deploy') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY'),
                    string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_KEY')
                ]) {
                    sh '''
                        echo "Deploying to AWS..."
                        # AWS_ACCESS_KEY and AWS_SECRET_KEY are masked
                        aws s3 cp target/app.jar s3://my-bucket/
                    '''
                }
            }
        }
    }
}
```

### Using EnvInject with Credentials

```groovy
pipeline {
    agent any
    
    stages {
        stage('Setup') {
            steps {
                script {
                    // Read credential and inject as masked environment variable
                    def creds = credentials('my-secret-api-key')
                    env.MASKED_API_KEY = creds
                    
                    // Store in file for EnvInject (alternative method)
                    sh '''
                        echo "API_KEY=${API_KEY}" > secrets.env
                    '''
                }
                
                // Inject from file - values will be masked
                injectEnvFromFile('secrets.env')
            }
        }
    }
}

def injectEnvFromFile(String filePath) {
    def props = new Properties()
    new File(filePath).withInputStream { props.load(it) }
    
    // EnvInject will handle masking
    EnvironmentInjectorAction action = new EnvironmentInjectorAction(
        props as Map<String, String>,
        "",
        false
    )
    
    // Add to build actions
    currentBuild.rawBuild.addAction(action)
}
```

---

## Masking Custom Patterns

### Configure Custom Mask Words

**Via Jenkins Script Console:**

```groovy
import jenkins.model.Jenkins

// Add custom mask patterns
def maskPatterns = [
    'CUSTOM_SECRET_\\w+',
    'PRIVATE_KEY_[A-Z0-9]+',
    'DB_PASSWORD.*'
]

// Configure via system groovy
Jenkins.instance.getDescriptorByName('org.jenkinsci.plugins.envinject.EnvInjectGlobalConfiguration')?.setMaskPasswords(true)
```

**Via Job Configuration ( freestyle):**

1. **Build Environment** → **Mask passwords and secret variables**
2. Add **Password/Expression** mappings:

| Variable | Value |
|----------|-------|
| MY_API_KEY | ${MY_API_KEY} |
| DB_PASSWORD | ${DB_PASSWORD} |

### Groovy Masking in Pipeline

```groovy
pipeline {
    agent any
    
    environment {
        // Custom mask pattern
        MY_CUSTOM_VAR = credentials('custom-secret')
    }
    
    stages {
        stage('Test') {
            steps {
                script {
                    // Add mask pattern for this build
                    maskPatterns = [
                        'MY_CUSTOM_VAR',
                        'SENSITIVE_.*'
                    ]
                    
                    // Apply masking via EnvInject
                    envInject([
                        'MASK_PATTERNS': maskPatterns.join(',')
                    ])
                }
                
                echo "Running tests..."
                // MY_CUSTOM_VAR will be masked
            }
        }
    }
}
```

---

## Advanced: Masking from Files

### Inject Sensitive Variables from File

```groovy
pipeline {
    agent any
    
    stages {
        stage('Prepare') {
            steps {
                script {
                    // Create env file with secrets
                    sh '''
                        cat > build-secrets.env << 'EOF'
                        DATABASE_PASSWORD=SuperSecret123!
                        API_ENDPOINT=https://api.internal.example.com
                        PRIVATE_KEY=-----BEGIN RSA PRIVATE KEY-----\nMIIBOgIBAAJBALRiMLAHudeSA...\n-----END RSA PRIVATE KEY-----
                        EOF
                    '''
                }
                
                // Inject - content will be masked
                injectEnvFromFile('build-secrets.env', true)
            }
        }
    }
}

// Function to inject environment variables with masking
def injectEnvFromFile(String filePath, boolean maskValues = true) {
    def props = new Properties()
    new File(filePath).withInputStream { props.load(it) }
    
    def envVars = [:]
    props.each { key, value ->
        def maskedValue = maskValues ? '********' : value
        envVars[key] = value
    }
    
    // Inject environment variables
    envVars.each { key, value ->
        env[key] = value
    }
    
    // Log masked versions (not actual values)
    echo "Injected ${envVars.size()} environment variables"
    echo "Variables: ${envVars.keySet().join(', ')}"
}
```

### Secure File Handling

```bash
#!/usr/bin/env bash
# secure-inject.sh - Inject secrets with automatic cleanup

set -euo pipefail

SECRETS_FILE="${1:-secrets.env}"

log_info() {
    echo "[INFO] $*"
}

inject_secrets() {
    if [[ ! -f "$SECRETS_FILE" ]]; then
        log_info "No secrets file found, skipping injection"
        return 0
    fi
    
    log_info "Injecting secrets from $SECRETS_FILE"
    
    # Read and inject each line (format: KEY=VALUE)
    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        [[ "$key" =~ ^# ]] && continue
        [[ -z "$key" ]] && continue
        
        # Export as environment variable
        export "$key=$value"
        echo "Injected: $key=******"
    done < "$SECRETS_FILE"
    
    # Remove file after injection
    rm -f "$SECRETS_FILE"
    log_info "Secrets file removed"
}

# Dry-run mode
if [[ "${DRY_RUN:-false}" == "true" ]]; then
    log_info "DRY RUN: Would inject secrets from $SECRETS_FILE"
    if [[ -f "$SECRETS_FILE" ]]; then
        log_info "Keys: $(cut -d= -f1 "$SECRETS_FILE" | grep -v '^#' | tr '\n' ', ')"
    fi
else
    inject_secrets
fi
```

---

## Verify

### Verify Secret Masking is Active

```bash
# Build with secrets and check console output
# In Jenkins console:
# 1. Run build with secret injection
# 2. View console output
# 3. Search for secret patterns - should show ******

# Expected: "DB_PASSWORD=******"
# Not expected: "DB_PASSWORD=SuperSecret123!"
```

### Test via Jenkins Script Console

```groovy
// Test secret masking
import org.jenkinsci.plugins.envinject.service.*

def injector = new EnvInjectService()
def result = injector.checkMasking("TEST_PASSWORD=mysecret")

println "Masking check: ${result.isMasked()}"
println "Original: ${result.originalValue()}"
println "Masked: ${result.maskedValue()}"
```

### Verify EnvInject Plugin Status

```groovy
// Check EnvInject is loaded
println "EnvInject plugin version: " + 
    Jenkins.instance.getPlugin('envinject')?.getWrapper()?.getVersion()

// List injected environment variables for current build
println "Injected env vars: " + 
    EnvInjectVarList.getEnvVars(Jenkins.instance)
```

---

## Rollback

### Remove Secret Injection from Job

```groovy
// Pipeline - remove environment block
pipeline {
    agent any
    // Remove 'environment' section with secrets
    
    stages {
        stage('Build') {
            steps {
                // Use withCredentials instead for one-time access
                withCredentials([string(credentialsId: 'secret', variable: 'SECRET')]) {
                    sh './build.sh'
                }
            }
        }
    }
}
```

### Clear Environment Variables

```groovy
// Via Jenkins Script Console - clear all env inject settings
import org.jenkinsci.plugins.envinject.*

// Remove EnvInject actions from all jobs
Jenkins.instance.allItems(Job).each { job ->
    def actions = job.getAllActions()
    actions.removeAll { it instanceof EnvInjectJobPropertyAction }
    job.save()
}
```

### Restore Previous Job Configuration

```bash
# Restore from job configuration backup
JENKINS_URL="http://localhost:8080"
JOB_NAME="my-job"

# Get config.xml backup
curl -s -u admin:token "$JENKINS_URL/job/$JOB_NAME/config.xml" > config-backup.xml

# Restore
curl -s -X POST -u admin:token \
    -H "Content-Type: application/xml" \
    -d @config-backup.xml \
    "$JENKINS_URL/job/$JOB_NAME/config.xml"
```

---

## Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `Secret not masked in logs` | EnvInject not properly configured | Enable "Mask passwords and secret variables" in job config |
| `Credential not found` | Wrong credentials ID | Verify credential exists in Jenkins credentials store |
| `Permission denied` | Missing credentials permission | Add Credentials > Use permission to user/role |
| `Environment variable empty` | Inject order wrong | Ensure EnvInject runs before build steps |
| `Masking not working in pipeline` | Missing `withCredentials` | Use `withCredentials` block for secret access |
| `Plugin not loaded` | EnvInject not installed | Install EnvInject plugin from plugin manager |

---

## References

- EnvInject Plugin: https://plugins.jenkins.io/envinject/
- Credentials Plugin: https://plugins.jenkins.io/credentials/
- Jenkins Security: https://www.jenkins.io/doc/book/security/
- Masking Passwords: https://www.jenkins.io/doc/book/pipeline/syntax/#environment
- Jenkins Pipeline Syntax: https://www.jenkins.io/doc/book/pipeline/syntax/