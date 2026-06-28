# Purpose: Custom ZAP Docker image with pre-configured Automation Framework plans
#          for CI-driven DAST scanning. Plans are embedded so no external context
#          files are required.
# Usage:
#   docker build -t my-zap:latest -f custom-zap-automation.Dockerfile .
#   docker run my-zap:latest zap.sh -cmd -autorun /zap/plans/quick-scan.yaml

FROM ghcr.io/zaproxy/zaproxy:stable AS base

LABEL org.opencontainers.image.title="Custom ZAP with Automation Framework plans"
LABEL org.opencontainers.image.description="Pre-configured ZAP Automation Framework plans for CI/CD DAST scanning"

USER root

# Create a default quick-scan plan (spider + passive scan only)
RUN mkdir -p /zap/plans && \
    cat > /zap/plans/quick-scan.yaml <<'PLANEOF' && \
env:
  contexts:
    - name: quick-target
      urls:
        - "{{TARGET_URL}}"
      includePaths:
        - ".*"
      excludePaths:
        - ".*\\.(css|js|png|jpg|jpeg|gif|ico|svg|woff2?|ttf|eot)(\\?.*)?$"
jobs:
  - type: spider
    parameters:
      context: quick-target
      maxDuration: 2
      subtreeOnly: false
  - type: passiveScan-config
    parameters:
      maxAlertsPerRule: 10
  - type: report
    parameters:
      template: traditional-json-plus
      reportDir: /zap/reports
      reportFileName: "zap-report-{{DATE:yyyyMMdd-HHmmss}}.json"
      reportTitle: "Quick DAST Scan — {{TARGET_URL}}"
      display: false
PLANEOF
    cat > /zap/plans/full-scan.yaml <<'PLANEOF'
env:
  contexts:
    - name: full-target
      urls:
        - "{{TARGET_URL}}"
      includePaths:
        - ".*"
      excludePaths:
        - ".*\\.(css|js|png|jpg|jpeg|gif|ico|svg|woff2?|ttf|eot)(\\?.*)?$"
jobs:
  - type: spider
    parameters:
      context: full-target
      maxDuration: 3
      subtreeOnly: false
  - type: spiderAjax
    parameters:
      context: full-target
      maxDuration: 5
      numberOfBrowsers: 1
  - type: passiveScan-config
    parameters:
      maxAlertsPerRule: 10
  - type: activeScan
    parameters:
      context: full-target
      maxDuration: 20
      threadPerHost: 4
      alertThreshold: MEDIUM
    policyDefinition:
      rules:
        - id: 40012
          threshold: MEDIUM
          strength: DEFAULT
        - id: 40018
          threshold: MEDIUM
          strength: DEFAULT
        - id: 90019
          threshold: MEDIUM
          strength: DEFAULT
    tests:
      - type: alertCount
        onFail: INFO
        action: raise_alerts
        risk: HIGH
        count: 0
        operator: "=="
  - type: report
    parameters:
      template: traditional-json-plus
      reportDir: /zap/reports
      reportFileName: "zap-report-{{DATE:yyyyMMdd-HHmmss}}.json"
      reportTitle: "Full DAST Scan — {{TARGET_URL}}"
      display: false
PLANEOF

RUN chown -R zap:zap /zap/plans && chmod 755 /zap/plans

USER zap

# Default runs the quick scan; override CMD for full-scan or custom plan
ENTRYPOINT ["zap.sh"]
CMD ["-cmd", "-autorun", "/zap/plans/quick-scan.yaml"]
