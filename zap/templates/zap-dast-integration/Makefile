.PHONY: quick-scan full-scan clean

TARGET_URL ?= $(or $(TARGET_URL),https://localhost:8080)
REPORTS ?= reports

quick-scan:
	@./scripts/run-zap-dast.sh "$(TARGET_URL)" "$(REPORTS)" plans/quick-scan.yaml

full-scan:
	@./scripts/run-zap-dast.sh "$(TARGET_URL)" "$(REPORTS)" plans/full-scan.yaml

clean:
	rm -rf "$(REPORTS)"