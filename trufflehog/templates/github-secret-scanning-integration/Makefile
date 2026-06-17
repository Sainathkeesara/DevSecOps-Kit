.PHONY: scan scan-github clean

scan:
	./scripts/scan-github.sh

scan-github:
	TRUFFLEHOG_TARGET_REPO=https://github.com/example-org/example-repo.git ./scripts/scan-github.sh

clean:
	rm -f trufflehog-results.json trufflehog-summary.md trufflehog-scan.log
