# Topics
> A map of what is here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## docs  -  221 files
- **notes** (4): [spurious script reference cleanup](../docs/notes/2026-08-23-spurious-script-reference-cleanup.md), [workflow stubs review](../docs/notes/2026-08-19-workflow-stubs-review.md), [spurious placeholder cleanup](../docs/notes/2026-08-17-spurious-placeholder-cleanup.md)
  - _...and 1 more under `docs/notes/` - browse the folder._

## scripts  -  196 files
- **notes** (4): [shell quickstart trip ups](../scripts/notes/2026-10-15-shell-quickstart-trip-ups.md), [lib claim fix](../scripts/notes/2026-10-14-lib-claim-fix.md), [explore scripts directory](../scripts/notes/2026-09-20-explore-scripts-directory.md)
  - _...and 1 more under `scripts/notes/` - browse the folder._
- **configs** (1): [shared script config](../scripts/configs/2026-10-18-shared-script-config.yaml)
- **snippets** (2): [kit helper logging retry](../scripts/snippets/2026-10-15-kit-helper-logging-retry.sh), [first utility script](../scripts/snippets/2026-09-20-first-utility-script.sh)

## trufflehog  -  49 files
- **primer:** [0000 primer trufflehog](../trufflehog/notes/0000-primer-trufflehog.md)
- **notes** (4): [explore cli](../trufflehog/notes/2026-07-27-explore-cli.md), [install trufflehog](../trufflehog/notes/2026-05-27-install-trufflehog.md), [following trufflehog quickstart](../trufflehog/notes/2026-05-27-following-trufflehog-quickstart.md)
  - _...and 1 more under `trufflehog/notes/` - browse the folder._
- **docs** (4): [trufflehog secrets database migration guide](../trufflehog/docs/trufflehog-secrets-database-migration-guide.md), [trufflehog output formats json sarif csv](../trufflehog/docs/trufflehog-output-formats-json-sarif-csv.md), [trufflehog integration reference secret detection](../trufflehog/docs/trufflehog-integration-reference-secret-detection.md)
  - _...and 1 more under `trufflehog/docs/` - browse the folder._
- **scripts** (3): [pre commit scan pipeline](../trufflehog/scripts/pre-commit-scan-pipeline.sh), [multi repo scan pipeline](../trufflehog/scripts/multi-repo-scan-pipeline.sh), [analyze trufflehog results](../trufflehog/scripts/analyze-trufflehog-results.py)
- **configs** (2): [trufflehog custom regex config](../trufflehog/configs/trufflehog-custom-regex-config.yaml), [custom detector rules](../trufflehog/configs/custom-detector-rules.yaml)
- **snippets** (3): [first secret scan](../trufflehog/snippets/2026-10-14-first-secret-scan.sh), [scan github repo for secrets](../trufflehog/snippets/scan-github-repo-for-secrets.sh), [fake secrets test](../trufflehog/snippets/fake-secrets-test.sh)
- **templates** (26): [trufflehog config](../trufflehog/templates/trufflehog-ci-integration/trufflehog-config.yaml), [scan](../trufflehog/templates/trufflehog-ci-integration/scripts/scan.sh), [scan ci](../trufflehog/templates/trufflehog-ci-integration/scripts/scan-ci.sh)
  - _...and 23 more under `trufflehog/templates/` - browse the folder._
- **manifests** (2): [trufflehog pr secret scan reusable](../trufflehog/manifests/trufflehog-pr-secret-scan-reusable.yaml), [trufflehog cicd pipeline](../trufflehog/manifests/trufflehog-cicd-pipeline.yaml)
- **dockerfiles** (2): [pre commit scanner](../trufflehog/dockerfiles/pre-commit-scanner.Dockerfile), [pipeline scanner](../trufflehog/dockerfiles/pipeline-scanner.Dockerfile)
- **notebooks** (3): [trufflehog scan modes comparison](../trufflehog/notebooks/trufflehog-scan-modes-comparison.ipynb), [detector comparison patterns](../trufflehog/notebooks/detector-comparison-patterns.ipynb), [analyzing trufflehog false positives](../trufflehog/notebooks/analyzing-trufflehog-false-positives.ipynb)

## checkov  -  45 files
- **primer:** [0000 primer checkov](../checkov/notes/0000-primer-checkov.md)
- **notes** (4): [checkov quickstart trip ups](../checkov/notes/2026-05-27-checkov-quickstart-trip-ups.md), [cli vs sdk comparison](../checkov/notes/2026-05-26-cli-vs-sdk-comparison.md), [scan terraform plan](../checkov/notes/2026-05-25-scan-terraform-plan.md)
  - _...and 1 more under `checkov/notes/` - browse the folder._
- **docs** (6): [pre commit hook with version pinning](../checkov/docs/pre-commit-hook-with-version-pinning.md), [multi cloud policy management](../checkov/docs/multi-cloud-policy-management.md), [checkov v3 upgrade checklist](../checkov/docs/checkov-v3-upgrade-checklist.md)
  - _...and 3 more under `checkov/docs/` - browse the folder._
- **scripts** (4): [validate policies](../checkov/scripts/validate-policies.sh), [scan terraform plan](../checkov/scripts/scan-terraform-plan.sh), [deep terraform plan scan](../checkov/scripts/deep-terraform-plan-scan.sh)
  - _...and 1 more under `checkov/scripts/` - browse the folder._
- **configs** (3): [platform config](../checkov/configs/platform-config.yaml), [checkov skip severity config](../checkov/configs/checkov-skip-severity-config.yaml), [checkov ci config](../checkov/configs/checkov-ci-config.yaml)
- **snippets** (4): [terraform scan custom policies](../checkov/snippets/terraform-scan-custom-policies.py), [scan terraform dir](../checkov/snippets/scan-terraform-dir.py), [scan kubernetes](../checkov/snippets/scan-kubernetes.sh)
  - _...and 1 more under `checkov/snippets/` - browse the folder._
- **templates** (16): [example caller workflow](../checkov/templates/reusable-workflow-custom-policies/example-caller-workflow.yml), [restrict ec2 public ip](../checkov/templates/reusable-workflow-custom-policies/custom-policies/restrict_ec2_public_ip.yaml), [no public s3 buckets](../checkov/templates/reusable-workflow-custom-policies/custom-policies/no_public_s3_buckets.yaml)
  - _...and 13 more under `checkov/templates/` - browse the folder._
- **manifests** (3): [layered checkov ci pr gate deep scan merge block](../checkov/manifests/layered-checkov-ci-pr-gate-deep-scan-merge-block.yaml), [checkov sarif pr blocking](../checkov/manifests/checkov-sarif-pr-blocking.yaml), [checkov gitlab ci multi cloud drift](../checkov/manifests/checkov-gitlab-ci-multi-cloud-drift.yaml)
- **notebooks** (4): [compare static vs plan scanning](../checkov/notebooks/compare-static-vs-plan-scanning.ipynb), [compare custom policy expressiveness](../checkov/notebooks/compare-custom-policy-expressiveness.ipynb), [compare cross module scanning limitations](../checkov/notebooks/compare-cross-module-scanning-limitations.ipynb)
  - _...and 1 more under `checkov/notebooks/` - browse the folder._
- **policies** (1): [no public s3 buckets](../checkov/policies/no-public-s3-buckets/no_public_s3_buckets.yaml)

## templates  -  45 files
- **primer:** [0000 primer templates](../templates/notes/0000-primer-templates.md)
- **notes** (2): [templates quickstart](../templates/notes/2026-10-19-templates-quickstart.md), [0000 primer templates](../templates/notes/0000-primer-templates.md)
- **docs** (1): [linux automation deploy path](../templates/docs/2026-10-19-linux-automation-deploy-path.md)
- **scripts** (1): [template catalog validator](../templates/scripts/template-catalog-validator.py)
- **configs** (3): [template index config](../templates/configs/2026-10-19-template-index-config.yaml), [first template variables](../templates/configs/2026-09-20-first-template-variables.yaml), [flat vs cookiecutter variable profiles](../templates/configs/flat-vs-cookiecutter-variable-profiles.yaml)
- **snippets** (1): [minimal template snippet](../templates/snippets/2026-10-19-minimal-template-snippet.py)
- **templates** (3): [app](../templates/templates/2026-09-20-first-project-template/{{cookiecutter.project_slug}}/app.py), [cookiecutter](../templates/templates/2026-09-20-first-project-template/cookiecutter.json), [README](../templates/templates/2026-09-20-first-project-template/README.md)

## syft  -  44 files
- **primer:** [0000 primer syft](../syft/notes/0000-primer-syft.md)
- **notes** (5): [first image sbom](../syft/notes/2026-10-27-first-image-sbom.md), [sbom format comparison](../syft/notes/2026-05-30-sbom-format-comparison.md), [syft quickstart trip ups](../syft/notes/2026-05-29-syft-quickstart-trip-ups.md)
  - _...and 2 more under `syft/notes/` - browse the folder._
- **docs** (8): [syft integration reference](../syft/docs/syft-integration-reference.md), [syft format migration guide](../syft/docs/syft-format-migration-guide.md), [sbom output formats reference](../syft/docs/sbom-output-formats-reference.md)
  - _...and 5 more under `syft/docs/` - browse the folder._
- **scripts** (5): [scan docker images aggregate sboms](../syft/scripts/2026-10-27-scan-docker-images-aggregate-sboms.sh), [syft sbom generation](../syft/scripts/syft-sbom-generation.py), [sbom vuln pipeline](../syft/scripts/sbom-vuln-pipeline.sh)
  - _...and 2 more under `syft/scripts/` - browse the folder._
- **configs** (1): [.syft](../syft/configs/.syft.yaml)
- **snippets** (3): [syft cli output formats](../syft/snippets/2026-10-27-syft-cli-output-formats.sh), [first sbom](../syft/snippets/2026-10-14-first-sbom.sh), [tried sbom formats](../syft/snippets/tried-sbom-formats.sh)
- **templates** (13): [trivy](../syft/templates/syft-trivy-k8s-scan-scaffold/trivy.yaml), [syft](../syft/templates/syft-trivy-k8s-scan-scaffold/syft.yaml), [scan workload images](../syft/templates/syft-trivy-k8s-scan-scaffold/scripts/scan-workload-images.sh)
  - _...and 10 more under `syft/templates/` - browse the folder._
- **manifests** (4): [syft remote state backend deployment](../syft/manifests/syft-remote-state-backend-deployment.yaml), [syft gha sbom oci push attestation](../syft/manifests/syft-gha-sbom-oci-push-attestation.yaml), [syft gha multi arch sbom registry auth](../syft/manifests/syft-gha-multi-arch-sbom-registry-auth.yaml)
  - _...and 1 more under `syft/manifests/` - browse the folder._
- **dockerfiles** (1): [multi stage sbom](../syft/dockerfiles/multi-stage-sbom.Dockerfile)
- **notebooks** (4): [syft format comparison patterns](../syft/notebooks/syft-format-comparison-patterns.ipynb), [source vs library multiarch](../syft/notebooks/source-vs-library-multiarch.ipynb), [sbom layer package analysis](../syft/notebooks/sbom-layer-package-analysis.ipynb)
  - _...and 1 more under `syft/notebooks/` - browse the folder._

## trivy  -  40 files
- **primer:** [0000 primer trivy](../trivy/notes/0000-primer-trivy.md)
- **notes** (8): [trivy first image scan](../trivy/notes/2026-10-19-trivy-first-image-scan.md), [quickstart trip ups](../trivy/notes/2026-10-14-quickstart-trip-ups.md), [install trivy first container scan](../trivy/notes/2026-09-05-install-trivy-first-container-scan.md)
  - _...and 5 more under `trivy/notes/` - browse the folder._
- **docs** (6): [trivy integration reference container scanning](../trivy/docs/trivy-integration-reference-container-scanning.md), [trivy database migration guide](../trivy/docs/trivy-database-migration-guide.md), [sbom scanning reference guide](../trivy/docs/sbom-scanning-reference-guide.md)
  - _...and 3 more under `trivy/docs/` - browse the folder._
- **scripts** (6): [multi target scanner](../trivy/scripts/multi-target-scanner.sh), [image vuln pipeline](../trivy/scripts/image-vuln-pipeline.sh), [ignore rules pipeline](../trivy/scripts/ignore-rules-pipeline.sh)
  - _...and 3 more under `trivy/scripts/` - browse the folder._
- **configs** (4): [minimal trivy config](../trivy/configs/2026-10-19-minimal-trivy-config.yaml), [trivy scan config](../trivy/configs/trivy-scan-config.yaml), [trivy ci gate](../trivy/configs/trivy-ci-gate.yml)
  - _...and 1 more under `trivy/configs/` - browse the folder._
- **snippets** (1): [scan docker image](../trivy/snippets/scan-docker-image.sh)
- **templates** (10): [trivy](../trivy/templates/trivy-monorepo-scanner/trivy.yaml), [scan all](../trivy/templates/trivy-monorepo-scanner/scripts/scan-all.sh), [README](../trivy/templates/trivy-monorepo-scanner/README.md)
  - _...and 7 more under `trivy/templates/` - browse the folder._
- **manifests** (2): [trivy sarif code scanning](../trivy/manifests/trivy-sarif-code-scanning.yaml), [trivy operator deployment](../trivy/manifests/trivy-operator-deployment.yaml)
- **dockerfiles** (1): [custom policies](../trivy/dockerfiles/custom-policies.Dockerfile)
- **notebooks** (2): [trivy scan mode comparison](../trivy/notebooks/trivy-scan-mode-comparison.ipynb), [trivy sarif output processing](../trivy/notebooks/trivy-sarif-output-processing.ipynb)

## ansible  -  34 files
- **notes** (3): [followed ansible quickstart what tripped me up](../ansible/notes/2026-08-25-followed-ansible-quickstart-what-tripped-me-up.md), [verify ansible cve 2026 33228 paths](../ansible/notes/2026-08-17-verify-ansible-cve-2026-33228-paths.md), [roles vs tasks](../ansible/notes/roles-vs-tasks.md)
- **docs** (1): [wired ansible infrastructure workflow](../ansible/docs/wired-ansible-infrastructure-workflow.md)
- **scripts** (5): [first ad hoc command](../ansible/scripts/2026-10-27-first-ad-hoc-command.sh), [bootstrap node](../ansible/scripts/2026-08-04-bootstrap-node.sh), [reusable inventory generator from terraform outputs for ansible](../ansible/scripts/reusable-inventory-generator-from-terraform-outputs-for-ansible.py)
  - _...and 2 more under `ansible/scripts/` - browse the folder._
- **configs** (3): [inventory groups host vars](../ansible/configs/2026-09-15-inventory-groups-host-vars.yaml), [terraform nginx integration](../ansible/configs/terraform-nginx-integration.yaml), [small ansible project](../ansible/configs/small-ansible-project.yaml)
- **snippets** (1): [minimal ansible playbook package service](../ansible/snippets/2026-08-25-minimal-ansible-playbook-package-service.yaml)
- **templates** (21): [main](../ansible/templates/project-scaffold-ansible-terraform-kubernetes/terraform/modules/vpc/main.tf), [main](../ansible/templates/project-scaffold-ansible-terraform-kubernetes/terraform/main.tf), [kustomization](../ansible/templates/project-scaffold-ansible-terraform-kubernetes/kubernetes/overlays/dev/kustomization.yaml)
  - _...and 18 more under `ansible/templates/` - browse the folder._

## codeql  -  32 files
- **primer:** [0000 primer codeql](../codeql/notes/0000-primer-codeql.md)
- **notes** (5): [install codeql first query](../codeql/notes/2026-10-27-install-codeql-first-query.md), [install codeql first query](../codeql/notes/2026-08-26-install-codeql-first-query.md), [codeql datalog gotchas](../codeql/notes/2026-06-14-codeql-datalog-gotchas.md)
  - _...and 2 more under `codeql/notes/` - browse the folder._
- **docs** (4): [wired custom queries into ci](../codeql/docs/wired-custom-queries-into-ci.md), [query writing patterns dataflow javascript typescript](../codeql/docs/query-writing-patterns-dataflow-javascript-typescript.md), [codeql integration reference](../codeql/docs/codeql-integration-reference.md)
  - _...and 1 more under `codeql/docs/` - browse the folder._
- **scripts** (2): [first codeql analysis](../codeql/scripts/first-codeql-analysis.sh), [codeql security issue detector](../codeql/scripts/codeql-security-issue-detector.py)
- **configs** (2): [first codeql analysis](../codeql/configs/first-codeql-analysis.yml), [codeql analysis workflow](../codeql/configs/codeql-analysis-workflow.yaml)
- **snippets** (6): [hardcoded secrets](../codeql/snippets/2026-10-27-hardcoded-secrets.ql), [first codeql query](../codeql/snippets/2026-09-24-first-codeql-query.py), [my first codeql commands](../codeql/snippets/my-first-codeql-commands.sh)
  - _...and 3 more under `codeql/snippets/` - browse the folder._
- **templates** (7): [custom suite](../codeql/templates/custom-query-pack-ci-harness/suites/custom-suite.qls), [test pack](../codeql/templates/custom-query-pack-ci-harness/scripts/test-pack.sh), [hardcoded credential check](../codeql/templates/custom-query-pack-ci-harness/queries/hardcoded-credential-check.ql)
  - _...and 4 more under `codeql/templates/` - browse the folder._
- **manifests** (3): [multi language codeql analysis](../codeql/manifests/multi-language-codeql-analysis.yaml), [codeql multi language scan](../codeql/manifests/codeql-multi-language-scan.yaml), [codeql cicd pipeline](../codeql/manifests/codeql-cicd-pipeline.yaml)
- **dockerfiles** (1): [custom codeql analysis image](../codeql/dockerfiles/custom-codeql-analysis-image.Dockerfile)
- **notebooks** (2): [compare cli vs actions scan modes](../codeql/notebooks/compare-cli-vs-actions-scan-modes.ipynb), [codeql query comparison patterns](../codeql/notebooks/codeql-query-comparison-patterns.ipynb)

## zap  -  31 files
- **primer:** [0000 primer zap](../zap/notes/0000-primer-zap.md)
- **notes** (6): [install zap first baseline scan](../zap/notes/2026-09-05-install-zap-first-baseline-scan.md), [install zap baseline scan](../zap/notes/2026-07-20-install-zap-baseline-scan.md), [spider scan test app](../zap/notes/2026-06-13-spider-scan-test-app.md)
  - _...and 3 more under `zap/notes/` - browse the folder._
- **docs** (5): [zap scan configuration migration guide](../zap/docs/zap-scan-configuration-migration-guide.md), [zap integration reference](../zap/docs/zap-integration-reference.md), [zap integration patterns](../zap/docs/zap-integration-patterns.md)
  - _...and 2 more under `zap/docs/` - browse the folder._
- **scripts** (3): [zap dast sarif code scanning](../zap/scripts/zap-dast-sarif-code-scanning.sh), [zap baseline scan](../zap/scripts/zap-baseline-scan.sh), [dast workflow from scratch](../zap/scripts/dast-workflow-from-scratch.sh)
- **configs** (3): [zap dast github actions workflow](../zap/configs/zap-dast-github-actions-workflow.yaml), [zap authenticated scan context](../zap/configs/zap-authenticated-scan-context.yaml), [ci dast automation framework plan](../zap/configs/ci-dast-automation-framework-plan.yaml)
- **snippets** (4): [zap docker quickstart json export](../zap/snippets/2026-07-16-zap-docker-quickstart-json-export.sh), [my first zap spider scan](../zap/snippets/my-first-zap-spider-scan.sh), [my first zap baseline scan](../zap/snippets/my-first-zap-baseline-scan.sh)
  - _...and 1 more under `zap/snippets/` - browse the folder._
- **templates** (7): [zap automation plan](../zap/templates/zap-dast-integration-scaffold/zap-automation-plan.yaml), [run zap dast](../zap/templates/zap-dast-integration-scaffold/scripts/run-zap-dast.sh), [quick scan](../zap/templates/zap-dast-integration-scaffold/plans/quick-scan.yaml)
  - _...and 4 more under `zap/templates/` - browse the folder._
- **manifests** (1): [zap cicd pipeline](../zap/manifests/zap-cicd-pipeline.yaml)
- **dockerfiles** (1): [custom zap automation](../zap/dockerfiles/custom-zap-automation.Dockerfile)
- **notebooks** (1): [scan strategy comparison patterns](../zap/notebooks/scan-strategy-comparison-patterns.ipynb)

## opa  -  30 files
- **primer:** [0000 primer opa](../opa/notes/0000-primer-opa.md)
- **notes** (5): [opa install first policy](../opa/notes/2026-10-27-opa-install-first-policy.md), [install opa first policy eval](../opa/notes/2026-10-24-install-opa-first-policy-eval.md), [opa getting started trip ups](../opa/notes/2026-06-15-opa-getting-started-trip-ups.md)
  - _...and 2 more under `opa/notes/` - browse the folder._
- **docs** (4): [wired opa admission control](../opa/docs/wired-opa-admission-control.md), [opa policy version migration patterns](../opa/docs/opa-policy-version-migration-patterns.md), [integrating opa with policy as code governance](../opa/docs/integrating-opa-with-policy-as-code-governance.md)
  - _...and 1 more under `opa/docs/` - browse the folder._
- **scripts** (2): [how i test policies locally](../opa/scripts/how-i-test-policies-locally.sh), [export audit results](../opa/scripts/export-audit-results.sh)
- **configs** (2): [tried a gatekeeper constraint](../opa/configs/tried-a-gatekeeper-constraint.yaml), [opa policy configuration template](../opa/configs/opa-policy-configuration-template.yaml)
- **snippets** (4): [first rego policy](../opa/snippets/2026-10-14-first-rego-policy.py), [my first opa policy eval](../opa/snippets/my-first-opa-policy-eval.sh), [enforce image registry constraints](../opa/snippets/enforce-image-registry-constraints.rego)
  - _...and 1 more under `opa/snippets/` - browse the folder._
- **templates** (8): [test policies](../opa/templates/gatekeeper-policy-library-scaffold/tests/test-policies.sh), [require read only root filesystem](../opa/templates/gatekeeper-policy-library-scaffold/policies/require-read-only-root-filesystem.rego), [enforce image registry](../opa/templates/gatekeeper-policy-library-scaffold/policies/enforce-image-registry.rego)
  - _...and 5 more under `opa/templates/` - browse the folder._
- **manifests** (4): [gatekeeper production deployment](../opa/manifests/gatekeeper-production-deployment.yaml), [constraints](../opa/manifests/constraints.yaml), [constraint templates](../opa/manifests/constraint-templates.yaml)
  - _...and 1 more under `opa/manifests/` - browse the folder._
- **notebooks** (1): [rego vs builtin policies](../opa/notebooks/rego-vs-builtin-policies.ipynb)

## snyk  -  29 files
- **primer:** [0000 primer snyk](../snyk/notes/0000-primer-snyk.md)
- **notes** (6): [snyk quickstart tripped](../snyk/notes/2026-10-27-snyk-quickstart-tripped.md), [explore snyk cli commands](../snyk/notes/2026-10-07-explore-snyk-cli-commands.md), [first vulnerability scan](../snyk/notes/2026-06-14-first-vulnerability-scan.md)
  - _...and 3 more under `snyk/notes/` - browse the folder._
- **docs** (4): [vulnerability prioritization reachability fix prs license compliance](../snyk/docs/vulnerability-prioritization-reachability-fix-prs-license-compliance.md), [snyk security policy migration patterns](../snyk/docs/snyk-security-policy-migration-patterns.md), [multi project ci pipeline](../snyk/docs/multi-project-ci-pipeline.md)
  - _...and 1 more under `snyk/docs/` - browse the folder._
- **scripts** (2): [first snyk test](../snyk/scripts/2026-10-20-first-snyk-test.sh), [snyk vuln scan pipeline](../snyk/scripts/snyk-vuln-scan-pipeline.sh)
- **configs** (3): [snyk project configuration template](../snyk/configs/snyk-project-configuration-template.yaml), [snyk dependency patch ignore](../snyk/configs/snyk-dependency-patch-ignore.yaml), [snyk ci github actions](../snyk/configs/snyk-ci-github-actions.yaml)
- **snippets** (1): [my first snyk commands](../snyk/snippets/my-first-snyk-commands.sh)
- **templates** (10): [scan ruby](../snyk/templates/snyk-multilang-scan-scaffold/scripts/scan-ruby.sh), [scan python](../snyk/templates/snyk-multilang-scan-scaffold/scripts/scan-python.sh), [scan node](../snyk/templates/snyk-multilang-scan-scaffold/scripts/scan-node.sh)
  - _...and 7 more under `snyk/templates/` - browse the folder._
- **manifests** (1): [snyk github actions cicd workflow](../snyk/manifests/snyk-github-actions-cicd-workflow.yaml)
- **dockerfiles** (1): [custom snyk cli air gapped](../snyk/dockerfiles/custom-snyk-cli-air-gapped.Dockerfile)
- **notebooks** (1): [cli vs api modes](../snyk/notebooks/cli-vs-api-modes.ipynb)

## terraform  -  29 files
- **primer:** [0000 primer terraform](../terraform/notes/0000-primer-terraform.md)
- **notes** (3): [install terraform first vm](../terraform/notes/2026-08-04-install-terraform-first-vm.md), [explore terraform](../terraform/notes/2026-07-15-explore-terraform.md), [0000 primer terraform](../terraform/notes/0000-primer-terraform.md)
- **docs** (2): [terraform testing patterns](../terraform/docs/terraform-testing-patterns.md), [terraform module composition](../terraform/docs/terraform-module-composition.md)
- **scripts** (4): [deploy](../terraform/scripts/2026-07-18-deploy.sh), [cleanup](../terraform/scripts/2026-07-18-cleanup.sh), [zip build](../terraform/scripts/2026-07-13-zip-build.sh)
  - _...and 1 more under `terraform/scripts/` - browse the folder._
- **configs** (6): [minimal quickstart config](../terraform/configs/2026-10-19-minimal-quickstart-config.hcl), [first configuration](../terraform/configs/2026-08-04-first-configuration.hcl), [first config](../terraform/configs/2026-07-15-first-config.tf)
  - _...and 3 more under `terraform/configs/` - browse the folder._
- **snippets** (1): [practice terraform variables outputs datasources](../terraform/snippets/2026-07-20-practice-terraform-variables-outputs-datasources.hcl)
- **templates** (5): [versions](../terraform/templates/module-registry-publish-consume/versions.tf), [variables](../terraform/templates/module-registry-publish-consume/variables.tf), [outputs](../terraform/templates/module-registry-publish-consume/outputs.tf)
  - _...and 2 more under `terraform/templates/` - browse the folder._
- **manifests** (1): [terraform cloud workspace automation](../terraform/manifests/terraform-cloud-workspace-automation.hcl)

## argocd  -  28 files
- **primer:** [0000 primer argocd](../argocd/notes/0000-primer-argocd.md)
- **notes** (6): [quickstart tripups](../argocd/notes/2026-08-12-quickstart-tripups.md), [verify readme layout](../argocd/notes/2026-08-01-verify-readme-layout.md), [verify readme layout](../argocd/notes/2026-07-31-verify-readme-layout.md)
  - _...and 3 more under `argocd/notes/` - browse the folder._
- **docs** (3): [multi environment gitops delivery](../argocd/docs/multi-environment-gitops-delivery.md), [helm kustomize composition](../argocd/docs/helm-kustomize-composition.md), [gitops workflow wiring](../argocd/docs/gitops-workflow-wiring.md)
- **scripts** (1): [argocd api automation](../argocd/scripts/argocd-api-automation.sh)
- **configs** (2): [values dev](../argocd/configs/2026-09-20-values-dev.yaml), [private repo credentials rbac](../argocd/configs/2026-08-17-private-repo-credentials-rbac.yaml)
- **templates** (11): [staging](../argocd/templates/app-of-apps-multienv/values/environments/staging.yaml), [production](../argocd/templates/app-of-apps-multienv/values/environments/production.yaml), [development](../argocd/templates/app-of-apps-multienv/values/environments/development.yaml)
  - _...and 8 more under `argocd/templates/` - browse the folder._
- **manifests** (5): [install](../argocd/manifests/2026-10-28-install.yaml), [gitops sync sample web app](../argocd/manifests/2026-08-12-gitops-sync-sample-web-app.yaml), [sample app application](../argocd/manifests/2026-07-06-sample-app-application.yaml)
  - _...and 2 more under `argocd/manifests/` - browse the folder._

## gitguardian  -  28 files
- **primer:** [0000 primer gitguardian](../gitguardian/notes/0000-primer-gitguardian.md)
- **notes** (6): [quickstart trip ups](../gitguardian/notes/2026-10-27-quickstart-trip-ups.md), [explore interface](../gitguardian/notes/2026-10-14-explore-interface.md), [first secrets scan repo](../gitguardian/notes/2026-06-14-first-secrets-scan-repo.md)
  - _...and 3 more under `gitguardian/notes/` - browse the folder._
- **docs** (4): [monorepo ci per team exclusions](../gitguardian/docs/monorepo-ci-per-team-exclusions.md), [gitguardian secret scanning migration patterns](../gitguardian/docs/gitguardian-secret-scanning-migration-patterns.md), [gitguardian incident response workflow](../gitguardian/docs/gitguardian-incident-response-workflow.md)
  - _...and 1 more under `gitguardian/docs/` - browse the folder._
- **scripts** (4): [first ggshield scan](../gitguardian/scripts/2026-10-20-first-ggshield-scan.sh), [pre commit hook ggshield](../gitguardian/scripts/pre-commit-hook-ggshield.sh), [gitguardian api integration](../gitguardian/scripts/gitguardian-api-integration.py)
  - _...and 1 more under `gitguardian/scripts/` - browse the folder._
- **configs** (3): [policy configuration](../gitguardian/configs/policy-configuration.yaml), [monorepo allowlists](../gitguardian/configs/monorepo-allowlists.yaml), [.ggshield](../gitguardian/configs/.ggshield.yaml)
- **snippets** (2): [my first ggshield commands](../gitguardian/snippets/my-first-ggshield-commands.sh), [custom policy engine ggshield](../gitguardian/snippets/custom-policy-engine-ggshield.sh)
- **templates** (8): [scan multi repo](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/scripts/scan-multi-repo.sh), [aggregate report](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/scripts/aggregate-report.sh), [repos](../gitguardian/templates/gitguardian-multi-repo-scanning-scaffold/repos.txt)
  - _...and 5 more under `gitguardian/templates/` - browse the folder._
- **notebooks** (1): [choosing between on premise and cloud modes](../gitguardian/notebooks/choosing-between-on-premise-and-cloud-modes.ipynb)

## grype  -  27 files
- **primer:** [0000 primer grype](../grype/notes/0000-primer-grype.md)
- **notes** (5): [explore vulnerability database](../grype/notes/2026-10-14-explore-vulnerability-database.md), [first grype scan](../grype/notes/2026-06-08-first-grype-scan.md), [grype quickstart trip ups](../grype/notes/2026-06-04-grype-quickstart-trip-ups.md)
  - _...and 2 more under `grype/notes/` - browse the folder._
- **docs** (3): [vulnerability management pipeline integration](../grype/docs/vulnerability-management-pipeline-integration.md), [grype vulnerability reporting migration patterns](../grype/docs/grype-vulnerability-reporting-migration-patterns.md), [grype syft integration guide](../grype/docs/grype-syft-integration-guide.md)
- **scripts** (9): [vuln diff two images](../grype/scripts/vuln-diff-two-images.sh), [minimal grype scan](../grype/scripts/minimal-grype-scan.sh), [grype vuln pipeline](../grype/scripts/grype-vuln-pipeline.sh)
  - _...and 6 more under `grype/scripts/` - browse the folder._
- **configs** (2): [grype filtering configuration template](../grype/configs/grype-filtering-configuration-template.yaml), [grype ci github actions](../grype/configs/grype-ci-github-actions.yaml)
- **snippets** (3): [grype filter severity formats](../grype/snippets/2026-10-27-grype-filter-severity-formats.sh), [my first grype commands](../grype/snippets/my-first-grype-commands.sh), [minimal grype scan](../grype/snippets/minimal-grype-scan.go)
- **manifests** (2): [grype sarif reusable workflow](../grype/manifests/grype-sarif-reusable-workflow.yaml), [grype reusable sarif workflow](../grype/manifests/grype-reusable-sarif-workflow.yaml)
- **dockerfiles** (1): [multi stage grype scan](../grype/dockerfiles/multi-stage-grype-scan.Dockerfile)
- **notebooks** (2): [grype sbom output explorer](../grype/notebooks/grype-sbom-output-explorer.ipynb), [grype db vs registry sources](../grype/notebooks/grype-db-vs-registry-sources.ipynb)

## falco  -  25 files
- **primer:** [0000 primer falco](../falco/notes/0000-primer-falco.md)
- **notes** (6): [follow official falco quickstart](../falco/notes/2026-10-27-follow-official-falco-quickstart.md), [install falco first event](../falco/notes/2026-10-15-install-falco-first-event.md), [explore falco cli rules events output](../falco/notes/2026-07-19-explore-falco-cli-rules-events-output.md)
  - _...and 3 more under `falco/notes/` - browse the folder._
- **docs** (4): [tuned falco rules noise reduction](../falco/docs/tuned-falco-rules-noise-reduction.md), [syscall vs tracepoint rules](../falco/docs/syscall-vs-tracepoint-rules.md), [runtime security monitoring integration](../falco/docs/runtime-security-monitoring-integration.md)
  - _...and 1 more under `falco/docs/` - browse the folder._
- **scripts** (3): [tried falco k8s deploy alert forwarding](../falco/scripts/tried-falco-k8s-deploy-alert-forwarding.sh), [tried falco k8s alert forwarding](../falco/scripts/tried-falco-k8s-alert-forwarding.sh), [deploy falco ruleset](../falco/scripts/deploy-falco-ruleset.sh)
- **configs** (4): [minimal runtime config](../falco/configs/2026-10-03-minimal-runtime-config.yaml), [first custom rule detect shell in container](../falco/configs/2026-06-10-first-custom-rule-detect-shell-in-container.yaml), [first custom rule detect shell in container](../falco/configs/first-custom-rule-detect-shell-in-container.yaml)
  - _...and 1 more under `falco/configs/` - browse the folder._
- **snippets** (1): [tried file access detector](../falco/snippets/tried-file-access-detector.go)
- **templates** (4): [test rules](../falco/templates/falco-custom-rules-library/tests/test-rules.sh), [custom rules](../falco/templates/falco-custom-rules-library/rules/custom-rules.yaml), [override example](../falco/templates/falco-custom-rules-library/examples/override-example.yaml)
  - _...and 1 more under `falco/templates/` - browse the folder._
- **manifests** (1): [falco k8s admission control](../falco/manifests/falco-k8s-admission-control.yaml)
- **notebooks** (2): [rule engine vs ebpf probes](../falco/notebooks/rule-engine-vs-ebpf-probes.ipynb), [falco event output formats](../falco/notebooks/falco-event-output-formats.ipynb)

## semgrep  -  25 files
- **primer:** [0000 primer semgrep](../semgrep/notes/0000-primer-semgrep.md)
- **notes** (3): [install semgrep pitfalls](../semgrep/notes/2026-05-26-install-semgrep-pitfalls.md), [install semgrep](../semgrep/notes/2026-05-25-install-semgrep.md), [0000 primer semgrep](../semgrep/notes/0000-primer-semgrep.md)
- **docs** (8): [semgrep rules migration guide](../semgrep/docs/semgrep-rules-migration-guide.md), [semgrep rule writing reference](../semgrep/docs/semgrep-rule-writing-reference.md), [semgrep rule performance optimization](../semgrep/docs/semgrep-rule-performance-optimization.md)
  - _...and 5 more under `semgrep/docs/` - browse the folder._
- **scripts** (3): [scan python codebase](../semgrep/scripts/scan-python-codebase.sh), [detect hardcoded secrets](../semgrep/scripts/detect-hardcoded-secrets.py), [bulk scan helper](../semgrep/scripts/bulk-scan-helper.py)
- **configs** (1): [multi rule pack](../semgrep/configs/multi-rule-pack.yaml)
- **snippets** (2): [first custom rule](../semgrep/snippets/first-custom-rule.yaml), [catch privileged containers](../semgrep/snippets/catch-privileged-containers.yaml)
- **manifests** (3): [semgrep gitlab ci](../semgrep/manifests/semgrep-gitlab-ci.yaml), [semgrep ci cd pipeline](../semgrep/manifests/semgrep-ci-cd-pipeline.yaml), [diff aware semgrep ci](../semgrep/manifests/diff-aware-semgrep-ci.yaml)
- **dockerfiles** (2): [custom scanning image](../semgrep/dockerfiles/custom-scanning-image.Dockerfile), [ci entrypoint](../semgrep/dockerfiles/ci-entrypoint.sh)
- **notebooks** (3): [semgrep scan vs ci comparison](../semgrep/notebooks/semgrep-scan-vs-ci-comparison.ipynb), [rule matching mode comparison](../semgrep/notebooks/rule-matching-mode-comparison.ipynb), [comparing community vs custom rules](../semgrep/notebooks/comparing-community-vs-custom-rules.ipynb)

## environments  -  23 files
- **primer:** [0000 primer environments](../environments/notes/0000-primer-environments.md)
- **notes** (5): [architecture overview claim fix](../environments/notes/2026-10-14-architecture-overview-claim-fix.md), [environments quickstart trip ups](../environments/notes/2026-09-30-environments-quickstart-trip-ups.md), [explore environments directory](../environments/notes/2026-09-29-explore-environments-directory.md)
  - _...and 2 more under `environments/notes/` - browse the folder._
- **docs** (1): [managing environments](../environments/docs/managing-environments.md)
- **scripts** (2): [validate deploy config](../environments/scripts/2026-10-01-validate-deploy-config.sh), [promote environment](../environments/scripts/promote-environment.sh)
- **configs** (2): [minimal environments config](../environments/configs/2026-09-30-minimal-environments-config.yaml), [first variable set](../environments/configs/2026-09-19-first-variable-set.yaml)
- **manifests** (1): [kubernetes namespaces](../environments/manifests/kubernetes-namespaces.yaml)

## snippets  -  23 files
- **primer:** [0000 primer snippets](../snippets/notes/0000-primer-snippets.md)
- **notes** (2): [snippets quickstart trip ups](../snippets/notes/2026-10-19-snippets-quickstart-trip-ups.md), [0000 primer snippets](../snippets/notes/0000-primer-snippets.md)
- **configs** (2): [shared index config](../snippets/configs/2026-10-19-shared-index-config.yaml), [first category](../snippets/configs/2026-09-20-first-category.yaml)
- **snippets** (2): [minimal python snippet](../snippets/snippets/2026-10-19-minimal-python-snippet.py), [first snippet](../snippets/snippets/2026-09-20-first-snippet.sh)

## github-actions  -  22 files
- **primer:** [0000 primer github actions](../github-actions/notes/0000-primer-github-actions.md)
- **notes** (7): [followed quickstart](../github-actions/notes/2026-10-20-followed-quickstart.md), [run first workflow](../github-actions/notes/2026-10-14-run-first-workflow.md), [quickstart tripped me up](../github-actions/notes/2026-09-21-quickstart-tripped-me-up.md)
  - _...and 4 more under `github-actions/notes/` - browse the folder._
- **docs** (1): [how i wired github actions into my ci workflow](../github-actions/docs/how-i-wired-github-actions-into-my-ci-workflow.md)
- **scripts** (1): [triage latest failed run](../github-actions/scripts/triage-latest-failed-run.sh)
- **configs** (8): [minimal ci](../github-actions/configs/2026-10-20-minimal-ci.yaml), [first scheduled workflow](../github-actions/configs/2026-10-14-first-scheduled-workflow.yaml), [minimal starter workflow](../github-actions/configs/2026-09-21-minimal-starter-workflow.yaml)
  - _...and 5 more under `github-actions/configs/` - browse the folder._
- **snippets** (3): [trigger first workflow gh](../github-actions/snippets/2026-10-14-trigger-first-workflow-gh.sh), [first workflow](../github-actions/snippets/2026-08-26-first-workflow.yaml), [composite action input reuse](../github-actions/snippets/2026-08-26-composite-action-input-reuse.yaml)
- **manifests** (2): [what is github actions](../github-actions/manifests/2026-08-04-what-is-github-actions.yaml), [pr validation](../github-actions/manifests/2026-08-04-pr-validation.yml)

## terrascan  -  22 files
- **primer:** [0000 primer terrascan](../terrascan/notes/0000-primer-terrascan.md)
- **notes** (5): [terrascan getting started trip ups](../terrascan/notes/2026-07-10-terrascan-getting-started-trip-ups.md), [terrascan getting started trip ups](../terrascan/notes/2026-06-29-terrascan-getting-started-trip-ups.md), [install terrascan tiny tf](../terrascan/notes/2026-06-19-install-terrascan-tiny-tf.md)
  - _...and 2 more under `terrascan/notes/` - browse the folder._
- **docs** (3): [terrascan vs checkov terraform iac scanning](../terrascan/docs/terrascan-vs-checkov-terraform-iac-scanning.md), [terrascan scan configuration migration patterns](../terrascan/docs/terrascan-scan-configuration-migration-patterns.md), [iac pipeline integration](../terrascan/docs/iac-pipeline-integration.md)
- **scripts** (2): [tried terrascan ci scan](../terrascan/scripts/tried-terrascan-ci-scan.sh), [policy as code workflow](../terrascan/scripts/policy-as-code-workflow.sh)
- **configs** (2): [tried custom s3 rule](../terrascan/configs/tried-custom-s3-rule.yaml), [terrascan config template](../terrascan/configs/terrascan-config-template.yaml)
- **snippets** (2): [tiny tf with findings](../terrascan/snippets/tiny-tf-with-findings.tf), [insecure terraform](../terrascan/snippets/insecure-terraform.tf)
- **templates** (6): [run scan](../terrascan/templates/scanning-pipeline-scaffold/scripts/run-scan.sh), [require encryption](../terrascan/templates/scanning-pipeline-scaffold/policies/require-encryption.rego), [block public s3 buckets](../terrascan/templates/scanning-pipeline-scaffold/policies/block-public-s3-buckets.rego)
  - _...and 3 more under `terrascan/templates/` - browse the folder._
- **manifests** (1): [terrascan gha ci multi iac](../terrascan/manifests/terrascan-gha-ci-multi-iac.yaml)
- **notebooks** (1): [rego vs yaml rule authoring](../terrascan/notebooks/rego-vs-yaml-rule-authoring.ipynb)

## vault  -  21 files
- **primer:** [0000 primer vault](../vault/notes/0000-primer-vault.md)
- **notes** (4): [install vault first command](../vault/notes/2026-08-26-install-vault-first-command.md), [vault getting started trip ups](../vault/notes/2026-06-15-vault-getting-started-trip-ups.md), [install vault and explore cli](../vault/notes/2026-06-05-install-vault-and-explore-cli.md)
  - _...and 1 more under `vault/notes/` - browse the folder._
- **docs** (3): [vault secrets engine selection guide](../vault/docs/vault-secrets-engine-selection-guide.md), [vault agent auto auth kubernetes](../vault/docs/vault-agent-auto-auth-kubernetes.md), [configuring vault dev server](../vault/docs/configuring-vault-dev-server.md)
- **scripts** (4): [vault pki workflow](../vault/scripts/vault-pki-workflow.sh), [vault kv crud](../vault/scripts/vault-kv-crud.sh), [vault db dynamic secrets](../vault/scripts/vault-db-dynamic-secrets.sh)
  - _...and 1 more under `vault/scripts/` - browse the folder._
- **configs** (3): [aws secrets engine policy](../vault/configs/2026-09-04-aws-secrets-engine-policy.hcl), [dev test policies](../vault/configs/2026-06-26-dev-test-policies.hcl), [multi environment access control](../vault/configs/multi-environment-access-control.hcl)
- **snippets** (2): [first vault secret](../vault/snippets/2026-08-30-first-vault-secret.sh), [vault read write](../vault/snippets/vault-read-write.go)
- **manifests** (2): [vault sidecar secrets refresh](../vault/manifests/vault-sidecar-secrets-refresh.yaml), [vault cluster deployment](../vault/manifests/vault-cluster-deployment.yaml)
- **dockerfiles** (1): [custom vault image with plugins tls](../vault/dockerfiles/custom-vault-image-with-plugins-tls.Dockerfile)
- **notebooks** (2): [vault secrets backend comparison patterns](../vault/notebooks/vault-secrets-backend-comparison-patterns.ipynb), [static vs dynamic secrets](../vault/notebooks/static-vs-dynamic-secrets.ipynb)

## cosign  -  20 files
- **primer:** [0000 primer cosign](../cosign/notes/0000-primer-cosign.md)
- **notes** (5): [install cosign first signing command](../cosign/notes/2026-10-14-install-cosign-first-signing-command.md), [cosign getting started trip ups](../cosign/notes/2026-06-22-cosign-getting-started-trip-ups.md), [install cosign generate first keypair](../cosign/notes/2026-06-14-install-cosign-generate-first-keypair.md)
  - _...and 2 more under `cosign/notes/` - browse the folder._
- **docs** (4): [keyless signing patterns](../cosign/docs/keyless-signing-patterns.md), [key rotation and migration patterns](../cosign/docs/key-rotation-and-migration-patterns.md), [cosign verification patterns](../cosign/docs/cosign-verification-patterns.md)
  - _...and 1 more under `cosign/docs/` - browse the folder._
- **scripts** (3): [verify signed image](../cosign/scripts/verify-signed-image.sh), [minimal sign verify](../cosign/scripts/minimal-sign-verify.sh), [cosign key management workflow](../cosign/scripts/cosign-key-management-workflow.sh)
- **configs** (2): [keyless signing github actions](../cosign/configs/keyless-signing-github-actions.yaml), [cosign signature configuration](../cosign/configs/cosign-signature-configuration.yaml)
- **snippets** (1): [first cosign sign verify image](../cosign/snippets/first-cosign-sign-verify-image.sh)
- **manifests** (2): [keyless oidc ci](../cosign/manifests/2026-07-10-keyless-oidc-ci.yaml), [signed container build oidc](../cosign/manifests/signed-container-build-oidc.yaml)
- **dockerfiles** (2): [entrypoint](../cosign/dockerfiles/entrypoint.sh), [custom cosign image](../cosign/dockerfiles/custom-cosign-image.Dockerfile)
- **notebooks** (1): [key based vs keyless signing](../cosign/notebooks/key-based-vs-keyless-signing.ipynb)

## kubernetes  -  20 files
- **primer:** [0000 primer kubernetes](../kubernetes/notes/0000-primer-kubernetes.md)
- **notes** (4): [quickstart followup](../kubernetes/notes/2026-10-20-quickstart-followup.md), [cluster resources](../kubernetes/notes/2026-10-14-cluster-resources.md), [explore kubernetes](../kubernetes/notes/2026-07-15-explore-kubernetes.md)
  - _...and 1 more under `kubernetes/notes/` - browse the folder._
- **docs** (2): [rbac design patterns for multi tenant clusters](../kubernetes/docs/rbac-design-patterns-for-multi-tenant-clusters.md), [cluster workflow wiring](../kubernetes/docs/cluster-workflow-wiring.md)
- **scripts** (2): [quickstart repro](../kubernetes/scripts/2026-10-20-quickstart-repro.sh), [cluster health check and conformance validation](../kubernetes/scripts/cluster-health-check-and-conformance-validation.sh)
- **configs** (3): [minimal deployment](../kubernetes/configs/2026-10-20-minimal-deployment.yaml), [minimal namespace](../kubernetes/configs/2026-10-14-minimal-namespace.yaml), [namespace strategy environment vs team](../kubernetes/configs/namespace-strategy-environment-vs-team.yaml)
- **templates** (5): [ingress class](../kubernetes/templates/cluster-bootstrap/ingress/ingress-class.yaml), [storage class](../kubernetes/templates/cluster-bootstrap/csi/storage-class.yaml), [calico installation](../kubernetes/templates/cluster-bootstrap/cni/calico-installation.yaml)
  - _...and 2 more under `kubernetes/templates/` - browse the folder._
- **manifests** (4): [first pod](../kubernetes/manifests/2026-09-10-first-pod.yaml), [first pod service](../kubernetes/manifests/2026-07-15-first-pod-service.yaml), [small deployment from scratch](../kubernetes/manifests/small-deployment-from-scratch.yaml)
  - _...and 1 more under `kubernetes/manifests/` - browse the folder._

## defectdojo  -  19 files
- **primer:** [0000 primer defectdojo](../defectdojo/notes/0000-primer-defectdojo.md)
- **notes** (4): [followed defectdojo quickstart what tripped me up](../defectdojo/notes/2026-10-19-followed-defectdojo-quickstart-what-tripped-me-up.md), [quickstart tripups](../defectdojo/notes/2026-09-21-quickstart-tripups.md), [explore defectdojo ui](../defectdojo/notes/2026-08-04-explore-defectdojo-ui.md)
  - _...and 1 more under `defectdojo/notes/` - browse the folder._
- **docs** (2): [how i wired defectdojo into my triage workflow](../defectdojo/docs/how-i-wired-defectdojo-into-my-triage-workflow.md), [defectdojo scan tool ingestion end to end](../defectdojo/docs/defectdojo-scan-tool-ingestion-end-to-end.md)
- **scripts** (3): [defectdojo tutorial check](../defectdojo/scripts/2026-09-20-defectdojo-tutorial-check.sh), [product scan import](../defectdojo/scripts/product-scan-import.py), [product engagement setup](../defectdojo/scripts/product-engagement-setup.py)
- **configs** (2): [vulnerability scanner setup](../defectdojo/configs/2026-09-21-vulnerability-scanner-setup.yaml), [api vs ui ingestion](../defectdojo/configs/api-vs-ui-ingestion.yaml)
- **snippets** (2): [minimal product setup api](../defectdojo/snippets/2026-10-19-minimal-product-setup-api.py), [install defectdojo first scan report](../defectdojo/snippets/install-defectdojo-first-scan-report.sh)
- **templates** (6): [setup product engagement](../defectdojo/templates/defectdojo-scan-ingestion-starter/scripts/setup-product-engagement.py), [import scan](../defectdojo/templates/defectdojo-scan-ingestion-starter/scripts/import-scan.py), [docker compose](../defectdojo/templates/defectdojo-scan-ingestion-starter/docker-compose.yaml)
  - _...and 3 more under `defectdojo/templates/` - browse the folder._

## dependabot  -  19 files
- **primer:** [0000 primer dependabot](../dependabot/notes/0000-primer-dependabot.md)
- **notes** (7): [dependabot custom registry tutorial](../dependabot/notes/2026-08-08-dependabot-custom-registry-tutorial.md), [enabling dependabot alerts security updates](../dependabot/notes/2026-07-21-enabling-dependabot-alerts-security-updates.md), [enabling dependabot alerts](../dependabot/notes/2026-07-10-enabling-dependabot-alerts.md)
  - _...and 4 more under `dependabot/notes/` - browse the folder._
- **docs** (4): [wired dependabot version control workflow](../dependabot/docs/wired-dependabot-version-control-workflow.md), [dependabot version control workflow integration](../dependabot/docs/dependabot-version-control-workflow-integration.md), [dependabot security update auto merge](../dependabot/docs/dependabot-security-update-auto-merge.md)
  - _...and 1 more under `dependabot/docs/` - browse the folder._
- **scripts** (2): [dependabot alert triage](../dependabot/scripts/2026-08-04-dependabot-alert-triage.py), [dependabot alert aggregation](../dependabot/scripts/dependabot-alert-aggregation.py)
- **configs** (5): [python project version update](../dependabot/configs/2026-07-18-python-project-version-update.yaml), [npm version strategy](../dependabot/configs/2026-07-10-npm-version-strategy.yaml), [tried npm dependabot](../dependabot/configs/tried-npm-dependabot.yaml)
  - _...and 2 more under `dependabot/configs/` - browse the folder._
- **notebooks** (1): [auto merge vs manual review](../dependabot/notebooks/auto-merge-vs-manual-review.ipynb)

## docker  -  19 files
- **primer:** [0000 primer docker](../docker/notes/0000-primer-docker.md)
- **notes** (2): [explore docker cli](../docker/notes/2026-07-12-explore-docker-cli.md), [0000 primer docker](../docker/notes/0000-primer-docker.md)
- **docs** (2): [dockerfile optimization patterns](../docker/docs/dockerfile-optimization-patterns.md), [cicd end to end](../docker/docs/cicd-end-to-end.md)
- **scripts** (3): [custom network volume mounts](../docker/scripts/2026-07-18-custom-network-volume-mounts.sh), [reusable build](../docker/scripts/reusable-build.sh), [build multi service compose app](../docker/scripts/build-multi-service-compose-app.sh)
- **configs** (1): [docker compose dev environment](../docker/configs/docker-compose-dev-environment.yaml)
- **templates** (7): [index](../docker/templates/multi-service-setup/web/index.html), [Dockerfile](../docker/templates/multi-service-setup/web/Dockerfile), [compose](../docker/templates/multi-service-setup/compose.yaml)
  - _...and 4 more under `docker/templates/` - browse the folder._
- **manifests** (1): [docker compose production](../docker/manifests/docker-compose-production.yaml)
- **dockerfiles** (3): [first custom docker image](../docker/dockerfiles/2026-07-12-first-custom-docker-image.Dockerfile), [first custom image](../docker/dockerfiles/2026-07-10-first-custom-image.Dockerfile), [small app](../docker/dockerfiles/small-app.Dockerfile)

## lab  -  17 files
- **primer:** [0000 primer lab](../lab/notes/0000-primer-lab.md)
- **notes** (3): [lab quickstart trips](../lab/notes/2026-10-25-lab-quickstart-trips.md), [setting up the lab directory](../lab/notes/2026-09-20-setting-up-the-lab-directory.md), [0000 primer lab](../lab/notes/0000-primer-lab.md)
- **configs** (2): [multi node demo](../lab/configs/2026-10-25-multi-node-demo.yaml), [first lab env](../lab/configs/2026-09-19-first-lab-env.yaml)
- **snippets** (2): [minimal lab env](../lab/snippets/2026-10-25-minimal-lab-env.py), [first lab command](../lab/snippets/2026-10-14-first-lab-command.sh)

## assets  -  14 files
- **notes** (5): [embedding architecture diagrams](../assets/notes/2026-10-11-embedding-architecture-diagrams.md), [checking where the diagrams are used](../assets/notes/2026-10-10-checking-where-the-diagrams-are-used.md), [explore assets directory](../assets/notes/2026-09-30-explore-assets-directory.md)
  - _...and 2 more under `assets/notes/` - browse the folder._
- **docs** (1): [how i wired assets into ci cd pipeline](../assets/docs/how-i-wired-assets-into-ci-cd-pipeline.md)
- **scripts** (2): [audit asset references](../assets/scripts/2026-10-01-audit-asset-references.sh), [asset inventory collector](../assets/scripts/asset-inventory-collector.py)
- **configs** (2): [asset index](../assets/configs/2026-09-29-asset-index.yaml), [asset tracking config](../assets/configs/asset-tracking-config.yaml)

## learn  -  13 files

## tetragon  -  11 files
- **primer:** [0000 primer tetragon](../tetragon/notes/0000-primer-tetragon.md)
- **notes** (3): [tetragon observability tutorial](../tetragon/notes/2026-08-06-tetragon-observability-tutorial.md), [install tetragon docker first events](../tetragon/notes/2026-06-23-install-tetragon-docker-first-events.md), [0000 primer tetragon](../tetragon/notes/0000-primer-tetragon.md)
- **docs** (1): [runtime security workflow](../tetragon/docs/runtime-security-workflow.md)
- **scripts** (3): [tetragon event collection pipeline](../tetragon/scripts/2026-08-05-tetragon-event-collection-pipeline.sh), [build tetragon policy](../tetragon/scripts/build-tetragon-policy.sh), [build tetragon file access tracing policy](../tetragon/scripts/build-tetragon-file-access-tracing-policy.sh)
- **configs** (4): [minimal network tracing policy](../tetragon/configs/2026-08-05-minimal-network-tracing-policy.yaml), [tetragon policy config for k8s runtime monitoring](../tetragon/configs/tetragon-policy-config-for-k8s-runtime-monitoring.yaml), [policy approaches comparison](../tetragon/configs/policy-approaches-comparison.yaml)
  - _...and 1 more under `tetragon/configs/` - browse the folder._

## git  -  10 files
- **primer:** [0000 primer git](../git/notes/0000-primer-git.md)
- **notes** (3): [install git identity first commit](../git/notes/2026-07-12-install-git-identity-first-commit.md), [git branching merge confusions](../git/notes/2026-07-04-git-branching-merge-confusions.md), [0000 primer git](../git/notes/0000-primer-git.md)
- **docs** (1): [how i wired git into my version control workflow](../git/docs/how-i-wired-git-into-my-version-control-workflow.md)
- **scripts** (4): [first repo stage log](../git/scripts/2026-08-24-first-repo-stage-log.sh), [bump version](../git/scripts/2026-07-12-bump-version.sh), [local ci simulation](../git/scripts/2026-07-10-local-ci-simulation.sh)
  - _...and 1 more under `git/scripts/` - browse the folder._
- **configs** (1): [config strategy layered vs conditional](../git/configs/config-strategy-layered-vs-conditional.yaml)
- **snippets** (1): [git rebase vs merge conflict patterns](../git/snippets/2026-07-04-git-rebase-vs-merge-conflict-patterns.sh)

## grafana  -  10 files
- **primer:** [0000 primer grafana](../grafana/notes/0000-primer-grafana.md)
- **notes** (4): [grafana quickstart trip ups](../grafana/notes/2026-10-14-grafana-quickstart-trip-ups.md), [explore grafana dashboard ui](../grafana/notes/2026-09-26-explore-grafana-dashboard-ui.md), [first dashboard browser](../grafana/notes/2026-09-19-first-dashboard-browser.md)
  - _...and 1 more under `grafana/notes/` - browse the folder._
- **docs** (1): [grafana alerting routing templates](../grafana/docs/grafana-alerting-routing-templates.md)
- **scripts** (1): [build dashboard provisioning](../grafana/scripts/build-dashboard-provisioning.py)
- **configs** (2): [dashboard provisioning](../grafana/configs/2026-10-14-dashboard-provisioning.yaml), [first datasource](../grafana/configs/2026-09-19-first-datasource.yaml)
- **snippets** (1): [first grafana datasource query](../grafana/snippets/2026-10-14-first-grafana-datasource-query.py)
- **manifests** (1): [grafana datasource dashboard](../grafana/manifests/grafana-datasource-dashboard.yaml)

## kustomize  -  10 files
- **primer:** [0000 primer kustomize](../kustomize/notes/0000-primer-kustomize.md)
- **notes** (3): [kustomize quickstart tripped me up](../kustomize/notes/2026-09-21-kustomize-quickstart-tripped-me-up.md), [install kustomize first overlay](../kustomize/notes/2026-07-08-install-kustomize-first-overlay.md), [0000 primer kustomize](../kustomize/notes/0000-primer-kustomize.md)
- **docs** (1): [how i wired kustomize into my manifest workflow](../kustomize/docs/how-i-wired-kustomize-into-my-manifest-workflow.md)
- **scripts** (2): [kustomize tutorial](../kustomize/scripts/2026-10-20-kustomize-tutorial.sh), [bases vs remote resources](../kustomize/scripts/bases-vs-remote-resources.sh)
- **configs** (3): [minimal kustomization with overlay](../kustomize/configs/2026-09-22-minimal-kustomization-with-overlay.yaml), [minimal kustomization](../kustomize/configs/2026-07-08-minimal-kustomization.yaml), [small overlay](../kustomize/configs/small-overlay.yaml)
- **manifests** (1): [kustomize tutorial](../kustomize/manifests/2026-09-21-kustomize-tutorial.yaml)

## opentofu  -  10 files
- **primer:** [0000 primer opentofu](../opentofu/notes/0000-primer-opentofu.md)
- **notes** (4): [follow opentofu test quickstart](../opentofu/notes/2026-10-20-follow-opentofu-test-quickstart.md), [follow open tofu quickstart](../opentofu/notes/2026-09-21-follow-open-tofu-quickstart.md), [explore open tofu](../opentofu/notes/2026-07-20-explore-open-tofu.md)
  - _...and 1 more under `opentofu/notes/` - browse the folder._
- **docs** (2): [open tofu vs terraform migration decision matrix](../opentofu/docs/open-tofu-vs-terraform-migration-decision-matrix.md), [how i wired opentofu into my iac workflow](../opentofu/docs/how-i-wired-opentofu-into-my-iac-workflow.md)
- **scripts** (1): [module registry publisher](../opentofu/scripts/module-registry-publisher.sh)
- **configs** (3): [minimal opentofu config with vars](../opentofu/configs/2026-09-21-minimal-opentofu-config-with-vars.hcl), [minimal opentofu config](../opentofu/configs/2026-09-10-minimal-opentofu-config.hcl), [first open tofu config](../opentofu/configs/2026-07-20-first-open-tofu-config.hcl)

## gitleaks  -  9 files
- **primer:** [0000 primer gitleaks](../gitleaks/notes/0000-primer-gitleaks.md)
- **notes** (3): [quickstart trip ups](../gitleaks/notes/2026-10-07-quickstart-trip-ups.md), [first secret scan](../gitleaks/notes/2026-09-19-first-secret-scan.md), [0000 primer gitleaks](../gitleaks/notes/0000-primer-gitleaks.md)
- **docs** (1): [integrating gitleaks pre commit ci](../gitleaks/docs/integrating-gitleaks-pre-commit-ci.md)
- **scripts** (3): [auditing git secrets](../gitleaks/scripts/2026-10-13-auditing-git-secrets.sh), [run first gitleaks scan](../gitleaks/scripts/2026-09-26-run-first-gitleaks-scan.sh), [build custom gitleaks ruleset](../gitleaks/scripts/build-custom-gitleaks-ruleset.sh)
- **configs** (2): [detection rules](../gitleaks/configs/2026-10-07-detection-rules.yaml), [gitleaks config](../gitleaks/configs/gitleaks-config.toml)

## helm  -  9 files
- **primer:** [0000 primer helm](../helm/notes/0000-primer-helm.md)
- **notes** (4): [followed quickstart](../helm/notes/2026-10-20-followed-quickstart.md), [quickstart tripped me up](../helm/notes/2026-09-21-quickstart-tripped-me-up.md), [explore helm charts releases values repos](../helm/notes/2026-07-19-explore-helm-charts-releases-values-repos.md)
  - _...and 1 more under `helm/notes/` - browse the folder._
- **docs** (1): [how i wired helm into my release workflow](../helm/docs/how-i-wired-helm-into-my-release-workflow.md)
- **scripts** (1): [build and deploy chart](../helm/scripts/build-and-deploy-chart.sh)
- **configs** (1): [values file vs set flags](../helm/configs/values-file-vs-set-flags.yaml)
- **manifests** (2): [minimal service chart](../helm/manifests/2026-09-21-minimal-service-chart.yaml), [first chart values](../helm/manifests/2026-07-15-first-chart-values.yaml)

## linux  -  7 files
- **notes** (3): [explore linux environment](../linux/notes/2026-10-02-explore-linux-environment.md), [linux shell scripting tutorial confusions](../linux/notes/2026-08-06-linux-shell-scripting-tutorial-confusions.md), [install linux vm terminal first commands](../linux/notes/2026-07-21-install-linux-vm-terminal-first-commands.md)
- **docs** (1): [system administration runbook](../linux/docs/system-administration-runbook.md)
- **scripts** (2): [health check and rollback](../linux/scripts/health-check-and-rollback.sh), [find large logs](../linux/scripts/find-large-logs.sh)
- **configs** (1): [cron job configuration](../linux/configs/2026-08-06-cron-job-configuration.ini)

## prometheus  -  7 files
- **primer:** [0000 primer prometheus](../prometheus/notes/0000-primer-prometheus.md)
- **notes** (5): [followed quickstart](../prometheus/notes/2026-10-25-followed-quickstart.md), [observability primer dedup](../prometheus/notes/2026-10-14-observability-primer-dedup.md), [first query log](../prometheus/notes/2026-10-14-first-query-log.md)
  - _...and 2 more under `prometheus/notes/` - browse the folder._
- **scripts** (1): [query api python](../prometheus/scripts/2026-10-25-query-api-python.py)
- **snippets** (1): [minimal scrape config](../prometheus/snippets/2026-10-25-minimal-scrape-config.yaml)

## sonarqube  -  7 files
- **primer:** [0000 primer sonarqube](../sonarqube/notes/0000-primer-sonarqube.md)
- **notes** (3): [follow sonarqube quickstart](../sonarqube/notes/2026-09-21-follow-sonarqube-quickstart.md), [explore sonarqube quality gates profiles](../sonarqube/notes/2026-07-19-explore-sonarqube-quality-gates-profiles.md), [0000 primer sonarqube](../sonarqube/notes/0000-primer-sonarqube.md)
- **scripts** (1): [sonarqube scan setup](../sonarqube/scripts/2026-09-21-sonarqube-scan-setup.sh)
- **configs** (2): [minimal quality gate](../sonarqube/configs/2026-09-21-minimal-quality-gate.yaml), [minimal project quality gate](../sonarqube/configs/minimal-project-quality-gate.yaml)
- **snippets** (1): [first sonarscanner run](../sonarqube/snippets/2026-07-16-first-sonarscanner-run.sh)

## tfsec  -  6 files
- **primer:** [0000 primer tfsec](../tfsec/notes/0000-primer-tfsec.md)
- **notes** (3): [followed tfsec quickstart what tripped me up](../tfsec/notes/2026-10-19-followed-tfsec-quickstart-what-tripped-me-up.md), [first tfsec scan](../tfsec/notes/2026-09-20-first-tfsec-scan.md), [0000 primer tfsec](../tfsec/notes/0000-primer-tfsec.md)
- **scripts** (1): [ran my first tfsec scan](../tfsec/scripts/2026-10-19-ran-my-first-tfsec-scan.sh)
- **configs** (1): [minimal tfsec scan config](../tfsec/configs/2026-10-19-minimal-tfsec-scan-config.yaml)
- **snippets** (1): [enforce s3 bucket encryption](../tfsec/snippets/enforce-s3-bucket-encryption.rego)

## nuclei  -  5 files
- **primer:** [0000 primer nuclei](../nuclei/notes/0000-primer-nuclei.md)
- **notes** (3): [nuclei quickstart trip ups](../nuclei/notes/2026-10-15-nuclei-quickstart-trip-ups.md), [first template scan attempt](../nuclei/notes/2026-09-20-first-template-scan-attempt.md), [0000 primer nuclei](../nuclei/notes/0000-primer-nuclei.md)
- **scripts** (1): [first nuclei scan](../nuclei/scripts/2026-10-15-first-nuclei-scan.sh)
- **configs** (1): [minimal scan template](../nuclei/configs/2026-10-15-minimal-scan-template.yaml)

## 00_index  -  4 files
