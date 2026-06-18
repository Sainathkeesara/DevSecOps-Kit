.PHONY: scan clean

# Build image, generate SBOM, and run Grype vulnerability scan
scan:
	bash scripts/scan-sbom.sh

# Remove scan reports and build artifacts
clean:
	rm -rf reports/
