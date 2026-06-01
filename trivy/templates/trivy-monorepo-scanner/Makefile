.PHONY: scan scan-images scan-fs scan-git clean

scan:
	./scripts/scan-all.sh

scan-images:
	trivy image --config trivy.yaml

scan-fs:
	trivy filesystem --config trivy.yaml

scan-git:
	trivy repository --config trivy.yaml

clean:
	rm -rf trivy-results/
