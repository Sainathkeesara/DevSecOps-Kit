# Jenkins CLI Commands Reference
Common Jenkins CLI commands for sysadmins

## Purpose
This document provides quick reference CLI commands for Jenkins administration and operations.

## When to use
- Quick reference for common Jenkins operations
- Copy-paste into scripts or terminal
- Automation of Jenkins tasks

## Prerequisites
- Jenkins instance running (LTS 2.541+)
- jenkins-cli.jar or curl access
- API token for authentication

## Commands

### Job Management
```bash
# List all jobs
java -jar jenkins-cli.jar -s http://jenkins:8080 list-jobs

# Create a new job from XML
java -jar jenkins-cli.jar -s http://jenkins:8080 create-job myjob < config.xml

# Copy a job
java -jar jenkins-cli.jar -s http://jenkins:8080 copy-job source-job target-job

# Delete a job
java -jar jenkins-cli.jar -s http://jenkins:8080 delete-job myjob

# Enable/Disable a job
java -jar jenkins-cli.jar -s http://jenkins:8080 enable-job myjob
java -jar jenkins-cli.jar -s http://jenkins:8080 disable-job myjob
```

### Build Operations
```bash
# Trigger a build
java -jar jenkins-cli.jar -s http://jenkins:8080 build myjob

# Trigger a parameterized build
java -jar jenkins-cli.jar -s http://jenkins:8080 build -p PARAM1=value1 -p PARAM2=value2 myjob

# Get build console output
java -jar jenkins-cli.jar -s http://jenkins:8080 console myjob 42

# Stop a build
java -jar jenkins-cli.jar -s http://jenkins:8080 stop-build myjob 42

# List build queue
java -jar jenkins-cli.jar -s http://jenkins:8080 queue-list

# Cancel a queue item
java -jar jenkins-cli.jar -s http://jenkins:8080 cancel-queue-build 42
```

### Node/Agent Management
```bash
# List all nodes/agents
java -jar jenkins-cli.jar -s http://jenkins:8080 list-nodes

# Create a permanent agent
java -jar jenkins-cli.jar -s http://jenkins:8080 create-node agent1 -d /home/jenkins/agent1 -f agent1-launcher.xml

# Connect an agent
java -jar jenkins-cli.jar -s http://jenkins:8080 connect-node agent1

# Disconnect an agent
java -jar jenkins-cli.jar -s http://jenkins:8080 disconnect-node agent1

# Delete an agent
java -jar jenkins-cli.jar -s http://jenkins:8080 delete-node agent1

# Get agent log
java -jar jenkins-cli.jar -s http://jenkins:8080 agent-log agent1
```

### Plugin Management
```bash
# List installed plugins
java -jar jenkins-cli.jar -s http://jenkins:8080 list-plugins

# Install a plugin
java -jar jenkins-cli.jar -s http://jenkins:8080 install-plugin pipeline

# Uninstall a plugin
java -jar jenkins-cli.jar -s http://jenkins:8080 uninstall-plugin pipeline

# Check plugin updates
java -jar jenkins-cli.jar -s http://jenkins:8080 plugin-initialised
```

### Credential Management
```bash
# Add username/password credential
curl -X POST http://jenkins:8080/credentials/store/folder/store/credential -u user:token \
  -d '{\"id\": \"mycreds\", \"type\": \"UsernamePasswordCredentialsImpl\", \"username\": \"deploy\", \"password\": \"secret\"}'

# List credentials
curl -u user:token http://jenkins:8080/credentials/api/json

# Update credential
curl -X PUT http://jenkins:8080/credentials/store/folder/store/credential/mycreds -u user:token -d '{\"password\": \"newsecret\"}'

# Delete credential
curl -X DELETE http://jenkins:8080/credentials/store/folder/store/credential/mycreds -u user:token
```

### Pipeline Commands
```bash
# Validate Jenkinsfile
java -jar jenkins-cli.jar -s http://jenkins:8080 declarative-linter < Jenkinsfile

# Run pipeline from file
java -jar jenkins-cli.jar -s http://jenkins:8080 replay-pipeline myjob < pipeline.groovy

# Get pipeline steps
java -jar jenkins-cli.jar -s http://jenkins:8080 get-plugins
```

### System Information
```bash
# Get system information
java -jar jenkins-cli.jar -s http://jenkins:8080 systemInfo

# Get Jenkins version
java -jar jenkins-cli.jar -s http://jenkins:8080 version

# Get JVM information
java -jar jenkins-cli.jar -s http://jenkins:8080 java-version

# Reload configuration
java -jar jenkins-cli.jar -s http://jenkins:8080 reload-configuration
```

### User Management
```bash
# Create user
curl -X POST http://jenkins:8080/securityRealm/createAccountByAdmin -u admin:token \
  -d 'username=newuser&password=newpass&fullname=New User'

# List users
curl -u user:token http://jenkins:8080/securityRealm/api/json | jq '.users[]'

# Disable user
curl -X POST http://jenkins:8080/securityRealm/user/newuser/disable -u admin:token
```

### View Management
```bash
# Create a new view
java -jar jenkins-cli.jar -s http://jenkins:8080 create-view myview

# Delete a view
java -jar jenkins-cli.jar -s http://jenkins:8080 delete-view myview

# Add job to view
java -jar jenkins-cli.jar -s http://jenkins:8080 add-job-to-view myview myjob
```

### Using REST API with curl
```bash
# Get JSON API
curl -u user:token http://jenkins:8080/api/json

# Get job information
curl -u user:token http://jenkins:8080/job/myjob/api/json

# Get build information
curl -u user:token http://jenkins:8080/job/myjob/42/api/json

# Trigger build via REST
curl -X POST http://jenkins:8080/job/myjob/build -u user:token

# Get queue information
curl -u user:token http://jenkins:8080/queue/api/json

# Get computer (nodes) information
curl -u user:token http://jenkins:8080/computer/api/json
```

### Script Console
```bash
# Run Groovy script via CLI
java -jar jenkins-cli.jar -s http://jenkins:8080 groovy script.groovy

# Run Groovy script via REST
curl -X POST http://jenkins:8080/scriptText -u user:token \
  -d 'script=Jenkins.instance.plugins' 
```

### Archives and Logs
```bash
# Get build artifacts
curl -u user:token http://jenkins:8080/job/myjob/42/artifact/build.log

# Get workspace
curl -u user:token http://jenkins:8080/job/myjob/42/workspace/*zip*/myjob.zip

# Get fingerprint records
curl -u user:token http://jenkins:8080/fingerprint/api/json
```

### Master and Agent Communication
```bash
# Run command on agent
java -jar jenkins-cli.jar -s http://jenkins:8080 remoting agent1 "hostname"

# Transfer file to agent
java -jar jenkins-cli.jar -s http://jenkins:8080 connect-node agent1

# Check agent availability
curl -u user:token http://jenkins:8080/computer/agent1/api/json
```

### Security and Permissions
```bash
# List all users
java -jar jenkins-cli.jar -s http://jenkins:8080 list-users

# Get user permissions
java -jar jenkins-cli.jar -s http://jenkins:8080 get-credentials "mycreds" -scope SYSTEM

# Reload security realm
java -jar jenkins-cli.jar -s http://jenkins:8080 reload-securityrealm

# Export global credentials
curl -u user:token http://jenkins:8080/credentials/store/systemDomain/credentialIds

# Check user security permissions
curl -u user:token http://jenkins:8080/securityRealm/api/json | jq '.users'
```

### Queue Management
```bash
# Clear build queue
java -jar jenkins-cli.jar -s http://jenkins:8080 clear-queue

# Get queue item details
curl -u user:token http://jenkins:8080/queue/item/42/api/json

# Cancel all builds in queue
curl -X POST http://jenkins:8080/queue/cancelAllBuilds -u user:token

# View queue breakdown
curl -u user:token http://jenkins:8080/queue/api/json | jq '.items[] | {id, task_name, inQueueSince}'
```

### Label Management
```bash
# Create agent label
java -jar jenkins-cli.jar -s http://jenkins:8080 set-labels agent1 "docker,linux"

# List nodes by label
curl -u user:token http://jenkins:8080/label/docker/api/json

# Get label statistics
curl -u user:token http://jenkins:8080/label/api/json
```

### Build Parameters
```bash
# Get job parameters
curl -u user:token http://jenkins:8080/job/myjob/parameters/api/json

# Trigger parameterized build
curl -X POST http://jenkins:8080/job/myjob/buildWithParameters \
  -u user:token -d "PARAM1=value1&PARAM2=value2"

# Get last build parameters
curl -u user:token http://jenkins:8080/job/myjob/lastBuild/parameterDefinitions
```

### Folder Operations
```bash
# Create a folder
java -jar jenkins-cli.jar -s http://jenkins:8080 create-folder myfolder

# Delete a folder
java -jar jenkins-cli.jar -s http://jenkins:8080 delete-folder myfolder

# List folder jobs
curl -u user:token http://jenkins:8080/job/myfolder/api/json | jq('.jobs[]')

# Navigate into folder
java -jar jenkins-cli.jar -s http://jenkins:8080 list-jobs myfolder

# Copy job to folder
java -jar jenkins-cli.jar -s http://jenkins:8080 copy-job sourcefolder/source-job targetfolder/target-job
```

### Logs and Diagnostics
```bash
# Get Jenkins logs
curl -u user:token http://jenkins:8080/log/size/estimate

# Download all logs
curl -u user:token http://jenkins:8080/log/rss

# Get agent logs
curl -u user:token http://jenkins:8080/computer/agent1/log

# Get build timestep
curl -u user:token http://jenkins:8080/job/myjob/42/timesteps

# Get build causality
curl -u user:token http://jenkins:8080/job/myjob/42/causes
```

### Statistics and Metrics
```bash
# Get build statistics
curl -u user:token http://jenkins:8080/job/myjob/api/json | jq('.lastBuild.number, .lastBuild.duration, .lastBuild.result')

# Get overall load statistics
curl -u user:token http://jenkins:8080/overallLoad/api/json

# Get CPU usage
curl -u user:token http://jenkins:8080/monitoring/api/json

# Get thread dump
java -jar jenkins-cli.jar -s http://jenkins:8080 thread-dump

# Get executor information
curl -u user:token http://jenkins:8080/computer/api/json | jq('.computer[].executors[]')
```

### Cloud and Ephemeral Agents
```bash
# Configure cloud
java -jar jenkins-cli.jar -s http://jenkins:8080 configure-cloud

#Provision ephemeral agent
java -jar jenkins-cli.jar -s http://jenkins:8080 online-nodes

# Get cloud status
curl -u user:token http://jenkins:8080/cloud/api/json

# Terminate cloud agent
java -jar jenkins-cli.jar -s http://jenkins:8080 terminate-cloud agent1

# Check docker cloud capacity
curl -u user:token http://jenkins:8080/cloud/docker/api/json
```

### Backup and Migration
```bash
# Export job configuration
java -jar jenkins-cli.jar -s http://jenkins:8080 get-job myjob > myjob.xml

# Export all configurations
java -jar jenkins-cli.jar -s http://jenkins:8080 get-all-credentials > all-creds.xml

# Backup user configurations
java -jar jenkins-cli.jar -s http://jenkins:8080 export-users

# Get all nodes config
java -jar jenkins-cli.jar -s http://jenkins:8080 get-nodes > nodes.xml

# Export global config
java -jar jenkins-cli.jar -s http://jenkins:8080 export-config

# Import job configuration
java -jar jenkins-cli.jar -s http://jenkins:8080 create-job myjob < myjob.xml
```

## Verify
Test each command in a non-production Jenkins instance first:
```bash
# Verify CLI connectivity
java -jar jenkins-cli.jar -s http://jenkins:8080 who-am-i

# Verify authentication
curl -u user:token http://jenkins:8080/api/json | jq '.mode'
```

## Rollback
For accidental deletions or modifications:
- Use Jenkins backup plugin
- Use configuration as code plugin for version control
- Keep XML backups: `java -jar jenkins-cli.jar -s http://jenkins:8080 get-job myjob > myjob.xml`

## Common errors
- `Authentication required` — generate API token from Jenkins UI → user → configure → API token
- `No such file or directory` — ensure jenkins-cli.jar is present
- `403 Forbidden` — check Overall/Read permission
- `Connection refused` — check Jenkins is running and port 8080 is accessible
- `Missing CRUMB` — add `-crumb` flag to CLI commands

## References
- https://www.jenkins.io/doc/book/managing/cli/
- https://www.jenkins.io/doc/book/using/
- https://javadoc.jenkins.io/