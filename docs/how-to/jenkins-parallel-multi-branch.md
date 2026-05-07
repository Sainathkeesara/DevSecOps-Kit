# Jenkins Parallel Multi-Branch Build Pipeline

## Purpose

This guide provides Jenkins pipeline Groovy snippets for implementing parallel multi-branch builds. It covers declarative and scripted pipeline patterns for concurrent branch execution, parallel stage execution, and efficient resource utilization in CI/CD workflows.

## When to use

- Building multiple branches concurrently to reduce overall build time
- Running parallel test suites (unit, integration, e2e) simultaneously
- Executing matrix builds across different configurations
- Optimizing pipeline performance for monorepo or multi-service projects

## Prerequisites

- Jenkins 2.x or later with Pipeline plugin
- Jenkins agent(s) with sufficient executors
- Git plugin for branch discovery
- Optional: Pipeline Utility Steps plugin for file operations

---

## Declarative Pipeline: Parallel Branch Builds

### Basic Parallel Stages

```groovy
pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            parallel {
                stage('Branch-A') {
                    when { branch 'feature-a' }
                    steps {
                        echo 'Building feature-a'
                        sh 'npm install && npm run build:branch-a'
                    }
                }
                stage('Branch-B') {
                    when { branch 'feature-b' }
                    steps {
                        echo 'Building feature-b'
                        sh 'npm install && npm run build:branch-b'
                    }
                }
            }
        }
        
        stage('Test') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        sh 'npm run test:unit'
                    }
                }
                stage('Integration Tests') {
                    steps {
                        sh 'npm run test:integration'
                    }
                }
                stage('E2E Tests') {
                    steps {
                        sh 'npm run test:e2e'
                    }
                }
            }
        }
    }
}
```

### Dynamic Parallel Branch Execution

```groovy
pipeline {
    agent any
    
    environment {
        // Define branch configurations
        BRANCH_CONFIGS = '''[
            {"name": "main", "env": "production"},
            {"name": "develop", "env": "staging"},
            {"name": "feature/*", "env": "dev"}
        ]'''
    }
    
    stages {
        stage('Discover Branches') {
            steps {
                script {
                    // Get all branches to build
                    def branches = []
                    sh '''
                        git branch -r | grep -v HEAD | sed 's/.*\\///' | head -20
                    '''.trim().split('\n').each { branch ->
                        branches.push(branch.trim())
                    }
                    env.BRANCH_LIST = branches.join(',')
                }
            }
        }
        
        stage('Parallel Build') {
            steps {
                script {
                    def branches = env.BRANCH_LIST.split(',')
                    def parallelStages = [:]
                    
                    branches.each { branch ->
                        def branchName = branch
                        parallelStages[branchName] = {
                            node {
                                checkout scm
                                sh """
                                    echo "Building branch: ${branchName}"
                                    ./build.sh --branch=${branchName}
                                """
                            }
                        }
                    }
                    parallel parallelStages
                }
            }
        }
    }
}
```

---

## Scripted Pipeline: Advanced Parallel Patterns

### Matrix Build with Parallel Axes

```groovy
node('linux') {
    def configurations = [
        [OS: 'ubuntu', JDK: '8'],
        [OS: 'ubuntu', JDK: '11'],
        [OS: 'ubuntu', JDK: '17'],
        [OS: 'centos', JDK: '8'],
        [OS: 'centos', JDK: '11']
    ]
    
    def parallelTasks = [:]
    
    configurations.each { config ->
        def os = config.OS
        def jdk = config.JDK
        def label = "linux&&${os}"
        
        parallelTasks["${os}-${jdk}"] = {
            node(label) {
                stage("Build ${os} / JDK ${jdk}") {
                    sh """
                        export JAVA_HOME=/opt/jdk-${jdk}
                        ./build.sh --os=${os} --jdk=${jdk}
                    """
                }
                
                stage("Test ${os} / JDK ${jdk}") {
                    sh """
                        export JAVA_HOME=/opt/jdk-${jdk}
                        ./test.sh
                    """
                }
            }
        }
    }
    
    parallel parallelTasks
}
```

### Parallel Test Execution with Results Aggregation

```groovy
pipeline {
    agent any
    
    stages {
        stage('Parallel Tests') {
            steps {
                script {
                    def testResults = [:]
                    def testTypes = ['unit', 'integration', 'e2e', 'static-analysis']
                    
                    testTypes.each { testType ->
                        testResults[testType] = {
                            sh "./run-tests.sh --type=${testType}"
                        }
                    }
                    
                    parallel testResults
                }
            }
        }
        
        stage('Aggregate Results') {
            steps {
                script {
                    // Collect and publish test results
                    junit allowEmptyResults: true, testResults: '**/test-results/*.xml'
                    publishHTML([
                        allowMissing: false,
                        alwaysLinkToLastBuild: true,
                        keepAll: true,
                        reportDir: 'reports',
                        reportFiles: 'index.html',
                        reportName: 'Test Report'
                    ])
                }
            }
        }
    }
}
```

---

## Multi-Branch Pipeline with Shared Libraries

### Library: Parallel Build Executor

```groovy
// vars/parallelBuild.groovy
def execute(Map config) {
    def branches = config.branches
    def buildScript = config.buildScript
    
    def tasks = [:]
    
    branches.each { branch ->
        tasks[branch] = {
            node(config.agent ?: 'any') {
                stage("Build ${branch}") {
                    sh buildScript
                }
            }
        }
    }
    
    parallel tasks
}
```

### Usage in Pipeline

```groovy
@Library('shared-library') _

pipeline {
    agent any
    
    stages {
        stage('Parallel Builds') {
            steps {
                script {
                    parallelBuild(
                        branches: ['main', 'develop', 'release/*'],
                        buildScript: './build.sh'
                    )
                }
            }
        }
    }
}
```

---

## Parallel Containerized Builds

### Docker-based Parallel Execution

```groovy
pipeline {
    agent any
    
    options {
        timeout(time: 1, unit: 'HOURS')
    }
    
    stages {
        stage('Parallel Docker Builds') {
            steps {
                script {
                    def images = [
                        'app-frontend',
                        'app-backend',
                        'app-worker',
                        'app-api-gateway'
                    ]
                    
                    def builds = [:]
                    
                    images.each { image ->
                        builds[image] = {
                            sh """
                                docker build -t ${image}:${env.BUILD_NUMBER} \
                                    --build-arg BUILD_REF=${env.GIT_COMMIT} \
                                    ./${image}/
                            """
                        }
                    }
                    
                    parallel builds
                }
            }
        }
        
        stage('Security Scan') {
            parallel {
                stage('Trivy Scan') {
                    sh 'trivy image --security-checks vuln app-frontend:${env.BUILD_NUMBER}'
                }
                stage('Hadolint') {
                    sh 'hadolint Dockerfile'
                }
            }
        }
        
        stage('Push Images') {
            steps {
                script {
                    // Push after all parallel builds pass
                    sh 'docker push app-frontend:${env.BUILD_NUMBER}'
                }
            }
        }
    }
}
```

---

## Optimizing Parallel Execution

### Agent Allocation Strategy

```groovy
pipeline {
    agent none
    
    stages {
        stage('Distribute Builds') {
            steps {
                script {
                    def branches = ['main', 'develop', 'feature-A', 'feature-B']
                    def agents = ['agent-1', 'agent-2', 'agent-3']
                    
                    def allocation = [:]
                    branches.eachWithIndex { branch, idx ->
                        def agent = agents[idx % agents.size()]
                        allocation[branch] = {
                            node(agent) {
                                sh "./build.sh --branch=${branch}"
                            }
                        }
                    }
                    
                    parallel allocation
                }
            }
        }
    }
}
```

### Throttle Concurrent Builds

```groovy
pipeline {
    options {
        throttleConcurrentBuilds(
            maxConcurrentTotal: 3,
            maxConcurrentPerNode: 2,
            categories: ['parallel-builds']
        )
    }
    
    stages {
        stage('Parallel Jobs') {
            parallel {
                stage('Job1') { steps { sh './job1.sh' } }
                stage('Job2') { steps { sh './job2.sh' } }
                stage('Job3') { steps { sh './job3.sh' } }
            }
        }
    }
}
```

---

## Error Handling in Parallel Stages

### Try-Catch with Error Aggregation

```groovy
pipeline {
    agent any
    
    stages {
        stage('Parallel with Error Handling') {
            steps {
                script {
                    def results = [:]
                    def errors = []
                    
                    def tasks = [
                        'build': { sh './build.sh' },
                        'test': { sh './test.sh' },
                        'analyze': { sh './analyze.sh' }
                    ]
                    
                    tasks.each { name, task ->
                        try {
                            task()
                            results[name] = 'SUCCESS'
                        } catch (Exception e) {
                            results[name] = "FAILED: ${e.message}"
                            errors << name
                        }
                    }
                    
                    // Report all results
                    echo "Results: ${results}"
                    
                    if (errors) {
                        error "Failed stages: ${errors.join(', ')}"
                    }
                }
            }
        }
    }
}
```

---

## Verify

### Verify Parallel Execution

```groovy
pipeline {
    agent any
    
    stages {
        stage('Verify Parallel') {
            steps {
                script {
                    def startTime = System.currentTimeMillis()
                    
                    parallel(
                        task1: { 
                            sh 'sleep 5; echo "Task 1 done"' 
                        },
                        task2: { 
                            sh 'sleep 3; echo "Task 2 done"' 
                        },
                        task3: { 
                            sh 'sleep 2; echo "Task 3 done"' 
                        }
                    )
                    
                    def duration = System.currentTimeMillis() - startTime
                    
                    // Should complete in ~5s (max of parallel tasks)
                    // Not 10s (sequential)
                    echo "Parallel execution took: ${duration}ms"
                    assert duration < 8000 : "Tasks did not run in parallel"
                }
            }
        }
    }
}
```

---

## Rollback

### Abort Running Parallel Jobs

```bash
# Via Jenkins CLI
java -jar jenkins-cli.jar -s $URL kill-build $JOB_NAME

# Via REST API
curl -X POST -u "$USER:$TOKEN" "$URL/job/$JOB_NAME/$BUILD_NUMBER/stop"

# Via script console
Jenkins.instance.getJob('JobName').getBuilds().each { build ->
    if (build.isBuilding()) {
        build.doStop()
    }
}
```

---

## Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `Executor capacity exceeded` | Too many parallel tasks | Add more agents or use throttleConcurrentBuilds |
| `Agent disconnected` | Agent lost during parallel execution | Add retry block or checkpoint |
| `OutOfMemoryError` | Too many parallel builds | Limit parallel tasks or increase agent memory |
| `Lock contention` | Resource locks in parallel | Use lock instead of semaphore for resources |
| `Duplicate build detected` | Same branch built twice | Add branch filter or build selector |

---

## References

- Jenkins Pipeline: https://www.jenkins.io/doc/book/pipeline/
- Parallel Steps: https://www.jenkins.io/doc/pipeline/steps/#parallel
- Jenkinsfile Examples: https://github.com/jenkinsci/pipeline-examples
- Multi-Branch Plugin: https://plugins.jenkins.io/workflow-branch-plugin/