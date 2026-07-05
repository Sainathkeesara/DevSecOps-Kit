TARGET_URL ?= http://localhost:8080
REPORTS ?= reports

.PHONY: quick-scan full-scan plan-scan clean

quick-scan:
	scripts/run-zap-dast.sh "$(TARGET_URL)" "$(REPORTS)" plans/quick-scan.yaml

full-scan:
	scripts/run-zap-dast.sh "$(TARGET_URL)" "$(REPORTS)" plans/full-scan.yaml

plan-scan:
	scripts/run-zap-dast.sh "$(TARGET_URL)" "$(REPORTS)" zap-automation-plan.yaml

clean:
	rm -rf "$(REPORTS)"
