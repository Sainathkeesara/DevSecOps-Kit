# last_verified: 2026-08-13 · syft n/a
.PHONY: scan clean

# Generate SBOMs and run Trivy scans for every image in images.txt
scan:
	bash scripts/scan-workload-images.sh

# Remove scan reports
clean:
	rm -rf reports/