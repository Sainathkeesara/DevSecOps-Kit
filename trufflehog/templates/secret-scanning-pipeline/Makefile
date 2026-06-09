.PHONY: scan scan-ci clean

# Run TruffleHog against all configured targets
scan:
	bash scripts/scan-all.sh

# Run with CI-friendly output format
scan-ci:
	bash scripts/scan-all.sh --ci

# Remove scan reports
clean:
	rm -rf reports/
