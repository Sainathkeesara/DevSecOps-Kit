# Trivy Jenkins Integration

---
SQUIRREL:
  title: "Trivy Jenkins Plugin Integration"
  category: "trivy"
  tags: ["trivy", "jenkins", "ci-cd", "container-scanning", "security"]
  last_verified: "2026-05-09"
  version: "Trivy Plugin 1.0.0+"
---

## Purpose

This guide provides steps to integrate Aqua Security Trivy vulnerability scanning into Jenkins CI/CD pipelines using the official Trivy Jenkins Plugin. Enables automated container image scanning, filesystem scanning, and IaC configuration validation as part of build workflows with configurable severity thresholds, SARIF output for GitHub Code Scanning, and automated failure gates.

## When to use

- Jenkins-based CI/CD pipelines requiring container image vulnerability scanning
- Implementing DevSecOps with Trivy as the security scanner
- Migrating from CLI-based Trivy to Jenkins plugin for standardized management
- Enforcing security gates before production deployments
- Generating compliance reports (SBOM, vulnerability findings)
- Integrating with GitHub Advanced Security or similar platforms

## Prerequisites

- Jenkins 2.495.1+ (LTS recommended)
- Java 11+ on Jenkins controller
- Docker installed on Jenkins agents (for image scanning)
- Trivy binary available on agents OR use plugin's built-in scanner
- Admin access to Jenkins for plugin installation
- Pipeline jobs using Jenkinsfile (Declarative or Scripted)

## Installation

### Step 1: Install Trivy Plugin

**Via Jenkins UI (Recommended):**
1. Navigate to `Manage Jenkins` → `Manage Plugins` → `Available`
2. Search for "Trivy"
3. Checkbox "Trivy Plugin" and click `Install without restart`
4. Wait for installation to complete

**Via CLI (Automated):**
```bash
# Use the integration script
./scripts/bash/ci_cd_toolkit/jenkins/trivy-jenkins-integration.sh \
  --install \
  --jenkins-url http://jenkins.example.com:8080 \
  --plugin-ver 1.0.0

# Or manually via Jenkins CLI
java -jar jenkins-cli.jar -s http://jenkins:8080/ install-plugin trivy
```

### Step 2: Configure Global Settings (Optional)

Navigate to `Manage Jenkins` → `Configure System` → `Trivy`:

| Setting | Description | Default |
|---------|-------------|---------|
| Trivy Binary Path | Custom path to trivy binary | Auto-detect |
| Disable Telemetry | Prevent Trivy telemetry collection | Enabled |
| Vulnerability DB Update | Auto-update vulnerability database | Enabled |
| Cache Directory | Trivy cache location | `$JENKINS_HOME/.trivy` |

### Step 3: Configure Agent Environment

Ensure Jenkins agents have:
- Docker daemon access (for image scanning): `docker ps` should work
- Sufficient disk space for vulnerability DB (~500MB)
- Network access to `github.com/aquasecurity` for DB updates

**Docker Agent Example:**
```dockerfile
FROM jenkins/agent:alpine
USER root
RUN apk add --no-cache docker-cli trivy
USER jenkins
```

## Integration Patterns

### Declarative Pipeline: Container Image Scan

```groovy
pipeline {
    agent any

    environment {
        REGISTRY = 'ghcr.io/myorg'
        IMAGE_NAME = 'myapp'
        TRIVY_SEVERITY = 'HIGH,CRITICAL'
        TRIVY_EXIT_CODE = '1'
    }

    stages {
        stage('Build') {
            steps {
                sh 'docker build -t ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} .'
            }
        }

        stage('Trivy Scan') {
            steps {
                script {
                    // Run Trivy scan via Jenkins plugin step
                    trivy imageScan(
                        image: "${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}",
                        format: 'sarif',
                        outputFile: 'trivy-results.sarif',
                        severity: 'HIGH,CRITICAL',
                        exitCode: 1,
                        ignoreUnfixed: false
                    )

                    // Archive scan results
                    archiveArtifacts artifacts: 'trivy-results.sarif', allowEmptyArchive: true

                    // Publish to GitHub Code Scanning (if GitHub repo)
                    // recordIssues tools: [trivy(pattern: 'trivy-results.sarif')]
                }
            }
            post {
                always {
                    // Cleanup Docker
                    sh "docker rmi ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} || true"
                }
            }
        }

        stage('Push') {
            when {
                expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-token']) {
                    sh 'docker push ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}'
                }
            }
        }
    }

    post {
        failure {
            mail to: 'security@example.com',
                 subject: "SECURITY SCAN FAILED: \${env.JOB_NAME} #\${env.BUILD_NUMBER}",
                 body: "Trivy found HIGH/CRITICAL vulnerabilities. See artifact: trivy-results.sarif"
        }
        success {
            script {
                if (fileExists('trivy-results.sarif')) {
                    echo 'Scan passed - no blocking vulnerabilities'
                }
            }
        }
    }
}
```

### Scripted Pipeline Example

```groovy
node {
    stage('Checkout') {
        checkout scm
    }

    stage('Build') {
        sh 'docker build -t myapp:${BUILD_NUMBER} .'
    }

    stage('Trivy Scan') {
        def scanResult = trivyImage(
            image: "myapp:${BUILD_NUMBER}",
            args: '--format sarif --output trivy.json'
        )
        echo "Found ${scanResult.vulnerabilities.size()} vulnerabilities"
    }
}
```

### Multi-Branch Pipeline with PR Scanning

```groovy
pipeline {
    agent any
    triggers {
        githubPush()
    }
    stages {
        stage('PR Security Scan') {
            when {
                branch 'PR-*'
            }
            steps {
                // Scan PR image if available
                script {
                    if (env.CHANGE_ID) {
                        sh '''
                            trivy image \
                                --format json \
                                --output pr-scan.json \
                                --severity CRITICAL \
                                myapp:pr-${CHANGE_ID}
                        '''
                        recordIssues tools: [trivy(pattern: 'pr-scan.json')]
                    }
                }
            }
        }
    }
}
```

## Verification

### Step 1: Verify Plugin Installation

```groovy
pipeline {
    agent any
    stages {
        stage('Verify Trivy') {
            steps {
                sh 'trivy --version'
                script {
                    // List installed plugins to confirm
                    def plugins = Jenkins.instance.pluginManager.plugins
                    plugins.each { p ->
                        if (p.shortName == 'trivy') {
                            echo "Trivy Plugin: ${p.version}"
                        }
                    }
                }
            }
        }
    }
}
```

### Step 2: Test Scan

```groovy
pipeline {
    agent any
    stages {
        stage('Test Trivy') {
            steps {
                // Scan a known vulnerable image (for testing only)
                sh '''
                    trivy image \
                        --severity HIGH,CRITICAL \
                        --format table \
                        alpine:3.14 || echo "Test scan complete"
                '''
            }
        }
    }
}
```

## Rollback

If Trivy plugin causes issues:

```groovy
pipeline {
    agent any
    stages {
        stage('Disable Trivy') {
            steps {
                script {
                    // Temporarily disable Trivy step if build fails
                    currentBuild.result = 'SUCCESS'
                    echo 'Trivy scan disabled due to errors - manual review required'
                }
            }
        }
    }
}
```

**Disable Plugin Completely:**
1. `Manage Jenkins` → `Manage Plugins` → `Installed`
2. Uncheck "Trivy Plugin" → `Disable`
3. Restart Jenkins

**Rollback Pipeline:**
```bash
# Revert Jenkinsfile changes
git revert <commit-hash>
git push origin main
```

## Common errors

**"No such tool: 'trivy'"**
- Install Trivy on agent: `apk add trivy` or `apt-get install trivy`
- Or configure plugin to use bundled binary (default)

**"Permission denied while trying to connect to Docker"**
- Add Jenkins user to docker group: `usermod -aG docker jenkins`
- Restart Jenkins agent

**"Failed to download vulnerability database"**
- Check network/firewall allows `https://github.com/aquasecurity` access
- Set proxy in `Manage Jenkins` → `Manage Plugins` → `Advanced`
- Increase HTTP timeout

**"Scan failed with exit code 1"**
- Configure severity threshold appropriately
- Use `--ignore-unfixed` for unfixed vulnerabilities
- Or set `TRIVY_EXIT_CODE=0` to not fail build (not recommended)

**"Out of memory during scan"**
- Increase agent memory: `-Xmx4g` for Java
- Use `--cache-backend redis` for shared cache
- Limit scan scope: `--ignore-dirs`, `--skip-dirs`

**SARIF parsing error in GitHub Code Scanning**
- Ensure SARIF version 2.1.0 format
- Use `trivy --format sarif --output results.sarif`
- Validate SARIF with `ajv` or similar validator

## Performance tuning

- **Cache database**: Mount persistent volume at `$JENKINS_HOME/.trivy`
- **Parallel scanning**: `--parallelism=4` (adjust based on CPU)
- **Skip files**: `--skip-dirs vendor,node_modules`
- **Only fixed**: `--only-fixed` to report only fixed vulnerabilities
- **Ignore unfixed**: `--ignore-unfixed` to exclude without patches

## Alternatives

- **CLI-only approach**: Use `sh 'trivy image ...'` without plugin (see tri-007)
- **Docker agent**: Run Trivy in Docker container: `docker run aquasec/trivy:latest image ...`
- **Shared library**: Extract Trivy logic to Jenkins Shared Library for consistency
- **External scanner**: Use dedicated security scanning platform (not Jenkins integrated)

## References

- Trivy Plugin: https://plugins.jenkins.io/trivy/
- Trivy Documentation: https://aquasecurity.github.io/trivy/
- Jenkins Pipeline Syntax: https://www.jenkins.io/doc/book/pipeline/syntax/
- SARIF Specification: https://docs.oasis-open.org/sarif/sarif/v2.1.0/
- GitHub Code Scanning: https://docs.github.com/en/code-security/code-scanning
