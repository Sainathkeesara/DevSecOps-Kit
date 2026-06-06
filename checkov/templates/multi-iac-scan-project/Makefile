.PHONY: scan scan-ci clean

# Run Checkov against the configured targets
scan:
	bash scan.sh

# Run Checkov with SARIF output (for CI artifact upload)
scan-ci:
	bash scan.sh --sarif

# Remove cached Checkov metadata
clean:
	rm -rf .checkov.cache
