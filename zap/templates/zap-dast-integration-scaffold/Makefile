TARGET_URL ?= http://localhost:8080

.PHONY: quick-scan full-scan clean

quick-scan:
	scripts/run-zap-dast.sh $(TARGET_URL) reports plans/quick-scan.yaml

full-scan:
	scripts/run-zap-dast.sh $(TARGET_URL) reports plans/full-scan.yaml

clean:
	rm -rf reports/
