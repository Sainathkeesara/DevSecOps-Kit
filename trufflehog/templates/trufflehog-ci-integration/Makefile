# TruffleHog CI Integration Makefile
#
# Targets:
#   scan        - Run local scan (exits non-zero on findings)
#   scan-ci     - Run CI-mode scan with SARIF output
#   scan-git    - Scan git history only
#   verify      - Verify configuration syntax
#   install     - Install trufflehog locally

.PHONY: scan scan-ci scan-git verify install

TRUFFLEHOG ?= trufflehog
CONFIG_FILE = trufflehog-config.yaml
REPORT_DIR = reports
TIMESTAMP = $(shell date +%Y%m%d_%H%M%S)

scan: verify
	@echo "[make] Running local filesystem scan..."
	@./scripts/scan.sh

scan-ci: verify
	@echo "[make] Running CI scan with SARIF output..."
	@./scripts/scan-ci.sh

scan-git: verify
	@echo "[make] Running git history scan..."
	@$(TRUFFLEHOG) git file://. --since-commit HEAD~50 --json --config=$(CONFIG_FILE) --no-verification

verify:
	@echo "[make] Verifying configuration..."
	@$(TRUFFLEHOG) --version >/dev/null 2>&1 || (echo "trufflehog not found in PATH" && exit 1)
	@test -f $(CONFIG_FILE) || (echo "Config file $(CONFIG_FILE) not found" && exit 1)
	@echo "[make] Configuration OK"

install:
	@echo "[make] Installing trufflehog..."
	pip install --upgrade trufflehog

clean:
	@rm -rf $(REPORT_DIR)