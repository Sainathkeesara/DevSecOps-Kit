# Jenkins Pipeline Retry Strategy Configuration

## Purpose

This reference provides Jenkins pipeline retry strategy configurations for handling transient failures in CI/CD pipelines. Covers declarative and scripted pipeline retry patterns, exponential backoff, error categorization, retry budgets, and integration with external retry mechanisms (GitHub Actions, Kubernetes).

## When to use

- Building pipelines with flaky tests or network-dependent steps
- Configuring retry logic for external API calls and service provisioning
- Setting up circuit breaker patterns for resilient pipelines
- Managing retry budgets to prevent infinite retry loops
- Handling transient infrastructure failures (network timeouts, spot instances)

## Prerequisites

- Jenkins controller running (LTS 2.414+)
- Pipeline plugin installed (pipeline-model-definition)
- Appropriate credentials and agent access
- Understanding of pipeline syntax (declarative vs scripted)

---

## Declarative Pipeline Retry

### Basic retry on failure
```groovy
pipeline {
    agent any
    
    stages {
        stage('Deploy') {
            steps {
                script {
                    retry(count: 3) {
                        sh './deploy.sh'
                    }
                }
            }
        }
    }
}
```

### Retry with condition
```groovy
pipeline {
    agent any
    
    stages {
        stage('API Test') {
            steps {
                script {
                    retry(count: 3) {
                        def response = sh(
                            script: 'curl -s -o /dev/null -w "%{http_code}" http://api.example.com/health',
                            returnStdout: true
                        ).trim()
                        if (response != '200') {
                            error "API health check failed with status: $response"
                        }
                    }
                }
            }
        }
    }
}
```

---

## Retry with Exponential Backoff

### Manual exponential backoff
```groovy
pipeline {
    agent any
    
    stages {
        stage('External API Call') {
            steps {
                script {
                    def attempt = 0
                    def maxAttempts = 5
                    def baseDelay = 2
                    
                    while (attempt < maxAttempts) {
                        attempt++
                        try {
                            sh 'curl -s -X POST http://external-api.example.com/deploy'
                            echo "API call successful on attempt $attempt"
                            break
                        } catch (Exception e) {
                            if (attempt >= maxAttempts) {
                                error "Failed after $maxAttempts attempts: ${e.message}"
                            }
                            def delay = baseDelay * Math.pow(2, attempt - 1)
                            echo "Attempt $attempt failed, retrying in ${delay}s..."
                            sleep(delay)
                        }
                    }
                }
            }
        }
    }
}
```

### Jitter-aware exponential backoff
```groovy
def retryWithJitter(int maxAttempts, int baseDelaySeconds, Closure action) {
    def attempt = 0
    while (attempt < maxAttempts) {
        attempt++
        try {
            return action()
        } catch (Exception e) {
            if (attempt >= maxAttempts) {
                throw e
            }
            def delay = baseDelaySeconds * Math.pow(2, attempt - 1)
            def jitter = Math.random() * delay * 0.1
            def totalDelay = delay + jitter
            echo "Attempt $attempt failed, retrying in ${totalDelay as int}s..."
            sleep(totalDelay as int)
        }
    }
}

pipeline {
    agent any
    
    stages {
        stage('Flaky Service') {
            steps {
                script {
                    retryWithJitter(5, 3) {
                        sh './flaky-service-check.sh'
                    }
                }
            }
        }
    }
}
```

---

## Retry with Error Categorization

### Categorize errors for selective retry
```groovy
pipeline {
    agent any
    
    stages {
        stage('Deploy Service') {
            steps {
                script {
                    def attempt = 0
                    def maxAttempts = 4
                    
                    while (attempt < maxAttempts) {
                        attempt++
                        try {
                            sh './deploy.sh'
                            echo "Deployment successful on attempt $attempt"
                            break
                        } catch (Exception e) {
                            def errorMsg = e.message ?: ''
                            
                            if (errorMsg.contains('timeout') || 
                                errorMsg.contains('connection refused') ||
                                errorMsg.contains('503') ||
                                errorMsg.contains('502')) {
                                // Transient error - retry
                                if (attempt >= maxAttempts) {
                                    error "Deployment failed after $maxAttempts attempts"
                                }
                                def delay = 5 * attempt
                                echo "Transient error, retrying in ${delay}s: $errorMsg"
                                sleep(delay)
                            } else {
                                // Permanent error - don't retry
                                error "Non-transient error, aborting: $errorMsg"
                            }
                        }
                    }
                }
            }
        }
    }
}
```

### HTTP status-based retry
```groovy
def retryOnHttpStatus(int maxAttempts, String url, List retryableCodes) {
    def attempt = 0
    while (attempt < maxAttempts) {
        attempt++
        def status = sh(
            script: "curl -s -o /dev/null -w '%{http_code}' -X GET '$url'",
            returnStdout: true
        ).trim()
        
        if (status in retryableCodes) {
            if (attempt >= maxAttempts) {
                error "HTTP $status persisted after $maxAttempts attempts"
            }
            def delay = 3 * attempt
            echo "HTTP $status, retrying in ${delay}s..."
            sleep(delay)
        } else {
            echo "HTTP $status - success"
            return status
        }
    }
}

pipeline {
    agent any
    
    stages {
        stage('Health Check') {
            steps {
                script {
                    retryOnHttpStatus(5, 'http://service:8080/health', ['000', '503', '502', '504'])
                }
            }
        }
    }
}
```

---

## Retry Budgets

### Global retry budget (limit total retries)
```groovy
pipeline {
    agent any
    
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }
    
    stages {
        stage('Build') {
            steps {
                script {
                    def retryCount = 0
                    def maxRetries = 3
                    
                    while (retryCount < maxRetries) {
                        try {
                            sh './build.sh'
                            break
                        } catch (Exception e) {
                            retryCount++
                            if (retryCount >= maxRetries) {
                                currentBuild.result = 'FAILURE'
                                error "Build failed after $maxRetries retries"
                            }
                            echo "Build retry $retryCount/$maxRetries: ${e.message}"
                            sleep(10)
                        }
                    }
                }
            }
        }
    }
}
```

### Per-stage retry budget
```groovy
pipeline {
    agent any
    
    stages {
        stage('Unit Tests') {
            options {
                timeout(time: 30, unit: 'MINUTES')
            }
            steps {
                script {
                    def retries = 0
                    def maxRetries = 2
                    while (retries < maxRetries) {
                        try {
                            sh './run-tests.sh'
                            break
                        } catch (Exception e) {
                            retries++
                            if (retries >= maxRetries) throw e
                            echo "Test retry $retries/$maxRetries"
                            sleep(5)
                        }
                    }
                }
            }
        }
        
        stage('Integration Tests') {
            options {
                timeout(time: 60, unit: 'MINUTES')
            }
            steps {
                script {
                    def retries = 0
                    def maxRetries = 3
                    while (retries < maxRetries) {
                        try {
                            sh './run-integration-tests.sh'
                            break
                        } catch (Exception e) {
                            retries++
                            if (retries >= maxRetries) throw e
                            echo "Integration test retry $retries/$maxRetries"
                            sleep(10)
                        }
                    }
                }
            }
        }
    }
}
```

---

## Circuit Breaker Pattern

### Simple circuit breaker
```groovy
class CircuitBreaker {
    def failures = 0
    def threshold = 3
    def resetTimeout = 60
    def lastFailure = 0
    def state = 'CLOSED' // CLOSED, OPEN, HALF_OPEN
    
    def call(Closure action) {
        def now = System.currentTimeMillis() / 1000
        
        if (state == 'OPEN') {
            if (now - lastFailure >= resetTimeout) {
                echo "Circuit HALF_OPEN - testing..."
                state = 'HALF_OPEN'
            } else {
                error "Circuit OPEN - blocking execution"
            }
        }
        
        try {
            def result = action()
            if (state == 'HALF_OPEN') {
                echo "Circuit CLOSED - service recovered"
                state = 'CLOSED'
                failures = 0
            }
            return result
        } catch (Exception e) {
            failures++
            lastFailure = now
            if (failures >= threshold) {
                echo "Circuit OPEN - too many failures"
                state = 'OPEN'
            }
            throw e
        }
    }
}

def breaker = new CircuitBreaker()

pipeline {
    agent any
    
    stages {
        stage('External API') {
            steps {
                script {
                    breaker {
                        sh './external-api-call.sh'
                    }
                }
            }
        }
    }
    
    post {
        failure {
            echo "Pipeline failed - circuit breaker state: ${breaker.state}"
        }
    }
}
```

---

## Scripted Pipeline Retry

### Basic scripted retry
```groovy
node {
    stage('Deploy') {
        def attempt = 0
        def maxAttempts = 3
        
        while (attempt < maxAttempts) {
            attempt++
            try {
                sh './deploy.sh'
                echo "Deployment succeeded on attempt $attempt"
                break
            } catch (Exception e) {
                if (attempt == maxAttempts) {
                    echo "Deployment failed after $maxAttempts attempts"
                    throw e
                }
                echo "Attempt $attempt failed: ${e.message}"
                sleep(10)
            }
        }
    }
}
```

### Scripted retry with timeout
```groovy
node {
    stage('Database Migration') {
        def attempt = 0
        def maxAttempts = 3
        def timeout = 120
        
        while (attempt < maxAttempts) {
            attempt++
            try {
                timeout(time: timeout, unit: 'SECONDS') {
                    sh '''
                        echo "Running migration..."
                        ./migrate.sh
                    '''
                }
                echo "Migration succeeded"
                break
            } catch (Exception e) {
                if (attempt == maxAttempts) {
                    currentBuild.result = 'FAILURE'
                    error "Migration failed after $maxAttempts attempts"
                }
                echo "Migration attempt $attempt failed: ${e.message}"
                sleep(30)
            }
        }
    }
}
```

---

## Kubernetes Agent Retry

### Retry on Kubernetes agent provisioning failures
```groovy
pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: jnlp
    image: jenkins/inbound-agent:latest
    resourceRequestCpu: 500m
    resourceLimitCpu: 2
    resourceRequestMemory: 512Mi
    resourceLimitMemory: 2Gi
'''
            defaultContainer 'jnlp'
        }
    }
    
    stages {
        stage('Deploy') {
            steps {
                script {
                    retry(count: 2) {
                        sh './deploy.sh'
                    }
                }
            }
        }
    }
    
    options {
        timeout(time: 30, unit: 'MINUTES')
        retryBuild(googler: 3)
    }
}
```

---

## GitHub Actions Retry Integration

### Combine Jenkins retry with GitHub Actions
```yaml
# .github/workflows/retry-demo.yml
name: Jenkins Pipeline with Retry

on:
  push:
    branches: [main]

jobs:
  trigger-jenkins:
    runs-on: ubuntu-latest
    steps:
      - name: Trigger Jenkins Build
        run: |
          for i in {1..3}; do
            response=$(curl -s -o /dev/null -w "%{http_code}" \
              -X POST -u "${{ secrets.JENKINS_USER }}:${{ secrets.JENKINS_TOKEN }}" \
              "${{ vars.JENKINS_URL }}/job/pipeline/build")
            
            if [ "$response" -eq 201 ]; then
              echo "Build triggered successfully"
              exit 0
            fi
            
            echo "Attempt $i failed with HTTP $response"
            if [ $i -lt 3 ]; then
              sleep 10
            fi
          done
          exit 1
```

---

## Verify

### Verify retry configuration
```groovy
pipeline {
    agent any
    
    stages {
        stage('Test Retry') {
            steps {
                script {
                    def attempts = []
                    retry(count: 2) {
                        attempts << [ts: new Date().toString()]
                        echo "Retry attempt ${attempts.size()}"
                        if (attempts.size() < 2) {
                            error "Simulated failure for retry testing"
                        }
                        echo "Success after ${attempts.size()} attempt(s)"
                    }
                }
            }
        }
    }
}
```

### Monitor retry metrics
```bash
# Get build with retry info
curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/job/$JOB_NAME/lastBuild/api/json" | \
  jq '{
    number: .number,
    result: .result,
    duration: .duration,
    actions: .actions
  }'
```

## Rollback

### Disable retry for specific run
```groovy
// Run pipeline without retry by modifying the run configuration
// Via Jenkins REST API:
curl -s -X POST -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/job/$JOB_NAME/disable"
```

### Revert to basic pipeline
```groovy
// Remove retry blocks and use basic error handling
pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                sh './build.sh'
            }
        }
    }
}
```

## Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `retry count exceeded` | All retries failed | Increase maxAttempts, check underlying error |
| `timeout during retry` | Retry delay too long | Reduce sleep between retries |
| `infinite retry loop` | No exit condition in retry | Always include maxAttempts limit |
| `stuck in HALF_OPEN` | Circuit breaker never closes | Check service health, increase reset timeout |
| `nested retry not allowed` | Retry inside another retry | Flatten retry structure |
| `retry after timeout` | Step-level timeout exceeded | Increase step timeout or remove timeout |

---

## References

- Jenkins Pipeline Retry: https://www.jenkins.io/doc/pipeline/steps/workflow-step/
- Pipeline Basic Steps: https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/
- Pipeline Development: https://www.jenkins.io/doc/book/pipeline/development/
- Circuit Breaker Pattern: https://martinfowler.com/bliki/CircuitBreaker.html
