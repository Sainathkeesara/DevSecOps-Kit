package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/anchore/grype/grype"
	"github.com/anchore/grype/grype/vulnerability"
)

func main() {
	image := "alpine:latest"
	if len(os.Args) > 1 {
		image = os.Args[1]
	}

	// I'm using the default grype db config here — it downloads the DB on first run
	// which can be slow, but it's the simplest way to get started
	grypeCfg := grype.DefaultConfig()

	// Create a new grype application
	app, err := grype.NewApplication(grypeCfg)
	if err != nil {
		log.Fatalf("failed to create grype app: %v", err)
	}

	// Scan the image
	report, err := app.Scan(context.Background(), image)
	if err != nil {
		log.Fatalf("scan failed: %v", err)
	}

	// I'm filtering for high/critical because that's what I care about in practice
	fmt.Printf("Vulnerabilities found in %s:\n", image)
	for _, match := range report.Matches {
		severity := match.Vulnerability.Severity
		if severity == vulnerability.High || severity == vulnerability.Critical {
			fmt.Printf("  - %s (%s): %s\n",
				match.Package.Name,
				severity,
				match.Vulnerability.Description)
		}
	}
}