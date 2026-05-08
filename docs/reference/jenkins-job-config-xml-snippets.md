# Jenkins Job Configuration XML Snippets

---
SQUIRREL:
  title: "Jenkins Job Configuration XML Snippets"
  category: "jenkins"
  tags: ["jenkins", "job-config", "xml", "webhook", "github"]
  last_verified: "2026-05-07"
  version: "LTS 2.414+"
---

## Purpose

This reference provides reusable Jenkins job configuration XML snippets for GitHub webhook integration. Covers parameterized triggers, webhook authentication, secret token management, pipeline job definitions, and SCM polling configurations that can be copied into Jenkins job configs or used with the Jenkins REST API.

## When to use

- Configuring GitHub webhooks to trigger Jenkins builds automatically
- Setting up secret tokens for webhook authentication
- Creating parameterized jobs that accept webhook-triggered builds
- Configuring SCM polling with webhooks for commit-triggered builds
- Setting up multi-branch pipeline triggers from GitHub repositories

## Prerequisites

- Jenkins controller running (LTS 2.414+)
- GitHub plugin installed (`git` plugin, `github-api` plugin)
- GitHub webhook access (repository admin or owner permissions)
- API token for Jenkins REST API authentication
- `jq` for JSON parsing

---

## Basic FreeStyle Job with Webhook Trigger

### Minimal trigger config
```xml
<?xml version='1.1' encoding='UTF-8'?>
<project>
  <triggers>
    <hudson.triggers.SCMTrigger>
      <spec>H/5 * * * *</spec>
    </hudson.triggers.SCMTrigger>
  </triggers>
  <builders>
    <hudson.tasks.Shell>
      <command>echo "Build triggered"</command>
    </hudson.tasks.Shell>
  </builders>
</project>
```

### Webhook-triggered job (GitHub hook trigger)
```xml
<?xml version='1.1' encoding='UTF-8'?>
<project>
  <triggers>
    <hudson.triggers.SCMTrigger>
      <spec>${GITHUB_WEBHOOK_SECRET:""}</spec>
      <ignorePostCommitHooks>false</ignorePostCommitHooks>
    </hudson.triggers.SCMTrigger>
  </triggers>
  <builders>
    <hudson.tasks.Shell>
      <command>#!/bin/bash
echo "GitHub webhook trigger received"
echo "BRANCH: ${GIT_BRANCH}"
echo "COMMIT: ${GIT_COMMIT}"
</command>
    </hudson.tasks.Shell>
  </builders>
</project>
```

---

## Parameterized Webhook Job

### Job with build parameters from webhook payload
```xml
<?xml version='1.1' encoding='UTF-8'?>
<project>
  <description>Webhook-triggered parameterized build</description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <hudson.model.ParametersDefinitionProperty>
      <parameterDefinitions>
        <hudson.model.StringParameterDefinition>
          <name>BRANCH_NAME</name>
          <description>Git branch name from webhook</description>
          <defaultValue>main</defaultValue>
          <trim>false</trim>
        </hudson.model.StringParameterDefinition>
        <hudson.model.StringParameterDefinition>
          <name>COMMIT_SHA</name>
          <description>Git commit SHA</description>
          <defaultValue></defaultValue>
          <trim>false</trim>
        </hudson.model.StringParameterDefinition>
        <hudson.model.StringParameterDefinition>
          <name>PULL_REQUEST_NUMBER</name>
          <description>Pull request number</description>
          <defaultValue></defaultValue>
          <trim>false</trim>
        </hudson.model.StringParameterDefinition>
        <hudson.model.StringParameterDefinition>
          <name>EVENT_TYPE</name>
          <description>GitHub event type (push, pull_request, etc.)</description>
          <defaultValue>push</defaultValue>
          <trim>false</trim>
        </hudson.model.StringParameterDefinition>
      </parameterDefinitions>
    </hudson.model.ParametersDefinitionProperty>
  </properties>
  <triggers>
    <hudson.triggers.SCMTrigger>
      <spec></spec>
    </hudson.triggers.SCMTrigger>
  </triggers>
  <builders>
    <hudson.tasks.Shell>
      <command>#!/bin/bash
echo "=== Webhook Parameters ==="
echo "BRANCH: $BRANCH_NAME"
echo "COMMIT: $COMMIT_SHA"
echo "PR: $PULL_REQUEST_NUMBER"
echo "EVENT: $EVENT_TYPE"
</command>
    </hudson.tasks.Shell>
  </builders>
</project>
```

---

## GitHub Webhook Secret Token Configuration

### Configure secret token (Groovy via script console)
```bash
JENKINS_URL="http://localhost:8080"
JENKINS_USER="admin"
JENKINS_TOKEN="your-token"

# Set global GitHub webhook secret
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode 'script=
import org.jenkinsci.plugins.github.config.GitHubPluginConfig
def config = GitHubPluginConfig.get()
config.setHookSecret("your-webhook-secret-token")
config.save()
println("Webhook secret configured");
' \
  "$JENKINS_URL/script"
```

### Generate and store webhook secret
```bash
# Generate a random secret
SECRET=$(openssl rand -hex 32)
echo "Generated secret: $SECRET"

# Store in Jenkins credentials
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data "\
json={
  \"scope\": \"GLOBAL\",
  \"id\": \"github-webhook-secret\",
  \"type\": \"secret\",
  \"value\": \"$SECRET\"
}\
" \
  "$JENKINS_URL/credentials/store/system/domain/_/createCredentials"
```

---

## Multi-Branch Pipeline with Webhook Trigger

### Jenkinsfile (Jenkinsfile in repo)
```groovy
// Jenkinsfile for multi-branch pipeline with GitHub webhook
properties([
    pipelineTriggers([
        [
            $class: 'GitHubBranchSource',
            triggers: [
                [
                    $class: 'GitHubPushTrigger',
                    hooksSecret: 'GITHUB_WEBHOOK_SECRET'
                ]
            ]
        ]
    ])
])

pipeline {
    agent { label 'docker' }
    
    environment {
        GITHUB_TOKEN = credentials('github-token')
    }
    
    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "Branch: ${env.GITHUB_BRANCH}"
                    echo "Commit: ${env.GITHUB_COMMIT}"
                }
            }
        }
        
        stage('Build') {
            steps {
                sh '''
                    echo "Building ${GITHUB_BRANCH}"
                    docker build -t myapp:${GITHUB_COMMIT} .
                '''
            }
        }
        
        stage('Test') {
            steps {
                sh 'docker run --rm myapp:${GITHUB_COMMIT} test'
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            echo "Build successful for ${GITHUB_BRANCH}"
        }
        failure {
            echo "Build failed for ${GITHUB_BRANCH}"
        }
    }
}
```

### Multibranch pipeline job config
```xml
<?xml version='1.1' encoding='UTF-8'?>
<org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject>
  <properties>
    <org.jenkinsci.plugins.pipeline.modeldefinition.config.PipelineTriggersConventionProperty>
      <triggers>
        <hudson.triggers.SCMTrigger>
          <spec>.*</spec>
        </hudson.triggers.SCMTrigger>
      </triggers>
    </org.jenkinsci.plugins.pipeline.modeldefinition.config.PipelineTriggersConventionProperty>
  </properties>
  <sources>
    <org.jenkinsci.plugins.workflow.multibranch.DynaBondyBranchSource>
      <source>
        <org.jenkinsci.plugins.githubranchsource.builder.BasicGithubBranchSource>
          <id>github</id>
          <credentialsId>github-app-token</credentialsId>
          <repoOwner>your-org</repoOwner>
          <repository>your-repo</repository>
          <traits>
            <org.jenkinsci.plugins.githubranchsource.traits.SpecifyRefMode>
              <refMode>BRANCH</refMode>
            </org.jenkinsci.plugins.githubranchsource.traits.SpecifyRefMode>
            <org.jenkinsci.plugins.githubranchsource.traits.WildcardsIgnoreOrigin上海回报>
              <configuredRefType>ignore_origin</configuredRefType>
            </org.jenkinsci.plugins.githubranchsource.traits.WildcardsIgnoreOrigin上海回报>
          </traits>
        </org.jenkinsci.plugins.githubranchsource.builder.BasicGithubBranchSource>
      </source>
    </org.jenkinsci.plugins.workflow.multibranch.DynaBondyBranchSource>
  </sources>
</org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject>
```

---

## Generic Webhook Trigger (Jenkins Plugin)

### Install webhook plugin
```bash
# Via Jenkins CLI
java -jar jenkins-cli.jar -s "$JENKINS_URL" install-plugin generic-webhook-trigger
```

### Configure generic webhook job
```xml
<?xml version='1.1' encoding='UTF-8'?>
<project>
  <properties>
    <com.dabsquared.GitHubWebhookProperty>
      <webhookCauses>
        <string>Generic cause</string>
      </webhookCauses>
    </com.dabsquared.GitHubWebhookProperty>
    <hudson.model.ParametersDefinitionProperty>
      <parameterDefinitions>
        <hudson.model.StringParameterDefinition>
          <name>payload_repository</name>
          <description>Repository name from webhook</description>
          <defaultValue></defaultValue>
        </hudson.model.StringParameterDefinition>
        <hudson.model.StringParameterDefinition>
          <name>payload_ref</name>
          <description>Git ref (branch/tag)</description>
          <defaultValue></defaultValue>
        </hudson.model.StringParameterDefinition>
        <hudson.model.StringParameterDefinition>
          <name>payload_sha</name>
          <description>Commit SHA</description>
          <defaultValue></defaultValue>
        </hudson.model.StringParameterDefinition>
        <hudson.model.StringParameterDefinition>
          <name>payload_action</name>
          <description>Webhook action (opened, closed, etc.)</description>
          <defaultValue></defaultValue>
        </hudson.model.StringParameterDefinition>
      </parameterDefinitions>
    </hudson.model.ParametersDefinitionProperty>
  </properties>
  <triggers>
    <com.dabsquared.GitHubWebhookTrigger>
      <plugin>
        <spec>.*</spec>
        <token>github-webhook-token-12345</token>
      </plugin>
    </com.dabsquared.GitHubWebhookTrigger>
  </triggers>
  <builders>
    <hudson.tasks.Shell>
      <command>#!/bin/bash
echo "Webhook received from $payload_repository"
echo "Ref: $payload_ref"
echo "Action: $payload_action"
</command>
    </hudson.tasks.Shell>
  </builders>
</project>
```

---

## SCM Polling via Webhook

### Configure SCM polling for push triggers
```xml
<?xml version='1.1' encoding='UTF-8'?>
<project>
  <triggers>
    <hudson.triggers.SCMTrigger>
      <spec>H/5 * * * *</spec>
      <ignorePostCommitHooks>false</ignorePostCommitHooks>
    </hudson.triggers.SCMTrigger>
  </triggers>
  <scm>
    <hudson.plugins.git.GitSCM>
      <configVersion>2</configVersion>
      <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
          <url>https://github.com/your-org/your-repo.git</url>
          <credentialsId>github-credentials</credentialsId>
        </hudson.plugins.git.UserRemoteConfig>
      </userRemoteConfigs>
      <branches>
        <hudson.plugins.git.BranchSpec>
          <name>*/main</name>
        </hudson.plugins.git.BranchSpec>
      </branches>
      <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
      <submoduleCfg class="empty-list"/>
      <extensions/>
    </hudson.plugins.git.GitSCM>
  </scm>
</project>
```

### Webhook-triggered SCM polling
```bash
# Trigger SCM poll via HTTP
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/job/$JOB_NAME/polling"

# With webhook secret
curl -s -X POST \
  -H "X-Hub-Signature-256: sha256=$WEBHOOK_SIGNATURE" \
  -H "X-GitHub-Event: push" \
  "$JENKINS_URL/job/$JOB_NAME/polling"
```

---

## GitHub App Authentication

### Configure GitHub App for webhook access
```bash
# Create GitHub App credentials in Jenkins
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  -H "Content-Type: application/xml" \
  --data-binary @github-app-credentials.xml \
  "$JENKINS_URL/credentials/store/system/domain/_/createCredentials"
```

### GitHub App credentials XML
```xml
<com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
  <scope>GLOBAL</scope>
  <id>github-app-credentials</id>
  <description>GitHub App authentication</description>
  <username>GH_APP_CLIENT_ID</username>
  <password>GH_APP_CLIENT_SECRET</password>
</com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
```

---

## Bitbucket Webhook Integration

### Bitbucket webhook job config
```xml
<?xml version='1.1' encoding='UTF-8'?>
<project>
  <triggers>
    <com.dabsquared.BitbucketWebhookTrigger>
      <plugin>
        <spec>.*</spec>
        <token>bitbucket-webhook-token</token>
      </plugin>
    </com.dabsquared.BitbucketWebhookTrigger>
  </triggers>
  <scm>
    <hudson.plugins.git.GitSCM>
      <configVersion>2</configVersion>
      <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
          <url>git@bitbucket.org:your-org/your-repo.git</url>
          <credentialsId>bitbucket-ssh-key</credentialsId>
        </hudson.plugins.git.UserRemoteConfig>
      </userRemoteConfigs>
      <branches>
        <hudson.plugins.git.BranchSpec>
          <name>*/main</name>
        </hudson.plugins.git.BranchSpec>
      </branches>
    </hudson.plugins.git.GitSCM>
  </scm>
</project>
```

---

## Webhook Verification

### Verify webhook is registered
```bash
JENKINS_URL="http://localhost:8080"
JENKINS_USER="admin"
JENKINS_TOKEN="token"

# Check GitHub plugin config
curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/pluginManager/api/json?tree=plugins[shortName,version,enabled]" | \
  jq '.plugins[] | select(.shortName | contains("github"))'
```

### Test webhook delivery manually
```bash
# Send test webhook payload
WEBHOOK_URL="$JENKINS_URL/generic-webhook-trigger/invoke?token=github-webhook-token-12345"

curl -s -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "repository": "test-repo",
    "ref": "refs/heads/main",
    "commits": [{"sha": "abc123"}],
    "pusher": {"name": "test-user"}
  }'
```

### Check webhook trigger logs
```bash
# View recent builds triggered by webhook
curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/job/$JOB_NAME/api/json?tree=builds[number,result,timestamp,actions[parameters]]" | \
  jq '.builds[0:5]'
```

## Rollback

### Remove webhook trigger from job
```bash
# Disable job and remove trigger
JOB_NAME="your-job"

# Disable job
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/job/$JOB_NAME/disable"

# Restore original config
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-binary @backup-config.xml \
  -H "Content-Type: application/xml" \
  "$JENKINS_URL/job/$JOB_NAME/config.xml"
```

### Disable GitHub plugin globally
```bash
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode 'script=
import org.jenkinsci.plugins.github.config.GitHubPluginConfig
def config = GitHubPluginConfig.get()
config.setHookSecret(null)
config.save()
println("Webhook secrets cleared");
' \
  "$JENKINS_URL/script"
```

## Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `403 Forbidden` | Invalid token or missing permissions | Generate API token with correct permissions |
| `Webhook not triggered` | GitHub webhook not configured | Set webhook URL in GitHub repo settings |
| `Signature mismatch` | Webhook secret mismatch | Verify secret token in both GitHub and Jenkins |
| `404 Not Found` | Job name incorrect | Use exact job name, check for spaces |
| `No triggers configured` | Missing triggers section | Add `<triggers>` to job XML |
| `Credentials not found` | Wrong credentials ID | Create credential in Jenkins, use correct ID |
| `Hook secret required` | GitHub App not configured | Set GitHub App credentials first |

---

## References

- Jenkins Generic Webhook Trigger Plugin: https://plugins.jenkins.io/generic-webhook-trigger/
- GitHub Branch Source Plugin: https://plugins.jenkins.io/github-branch-source/
- Jenkins GitHub Integration: https://www.jenkins.io/doc/pipeline/steps/github/
- GitHub Webhooks Documentation: https://docs.github.com/en/developers/webhooks-and-events/webhooks