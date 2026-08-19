# last_verified: 2026-08-19 · GitGuardian ggshield

.PHONY: scan clean report

REPORT_DIR ?= reports
REPOS := repos.txt
SCAN_SCRIPT := scripts/scan-multi-repo.sh
AGG_SCRIPT := scripts/aggregate-report.sh

scan: $(REPORT_DIR) $(SCAN_SCRIPT)
	mkdir -p $(REPORT_DIR)
	bash $(SCAN_SCRIPT) $(REPOS) $(REPORT_DIR)
	bash $(AGG_SCRIPT) $(REPORT_DIR) > $(REPORT_DIR)/summary.json

report:
	bash $(AGG_SCRIPT) $(REPORT_DIR)

clean:
	rm -rf $(REPORT_DIR) /tmp/gg-scan-*

$(REPORT_DIR):
	mkdir -p $(REPORT_DIR)
