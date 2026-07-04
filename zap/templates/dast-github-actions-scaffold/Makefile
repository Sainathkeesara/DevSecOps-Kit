.PHONY: quick-scan full-scan clean

quick-scan:
	@bash scripts/run-dast-scan.sh "$$TARGET_URL" reports plans/quick-scan.yaml

full-scan:
	@bash scripts/run-dast-scan.sh "$$TARGET_URL" reports plans/full-scan.yaml

clean:
	rm -rf reports/*
