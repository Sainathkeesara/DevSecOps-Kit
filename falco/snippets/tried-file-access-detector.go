package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
	"strings"
)

// FalcoEvent mirrors the JSON output from `falco` when run with `-o json_output=true`
// I'm only parsing the fields I need — the full schema has way more
type FalcoEvent struct {
	Time       string            `json:"time"`
	Rule       string            `json:"rule"`
	Priority   string            `json:"priority"`
	Output     string            `json:"output"`
	Source     string            `json:"source"`
	Fields     map[string]string `json:"output_fields"`
}

// suspiciousFiles lists paths that containers shouldn't normally be touching.
// Pulled this from a few Falco rule examples and my own understanding of what's
// sensitive in a container context.
var suspiciousFiles = []string{
	"/etc/shadow",
	"/etc/sudoers",
	"/etc/ssh/",
	"/root/.ssh/",
	"/var/run/secrets/",
	"/var/lib/",
}

// fileAccessRules is a quick mapping of common Falco rules I know about that
// trigger on file events. I found these by running `falco --list` and grepping
// for "open".
var fileAccessRules = map[string]string{
	"Read sensitive file untrusted":          "reading_sensitive_file",
	"Write below binary or trusted directory": "writing_to_binary_dir",
}

func main() {
	// Expecting JSON lines from Falco's stdout, one event per line.
	// Works with: falco -o json_output=true | go run tried-file-access-detector.go
	scanner := bufio.NewScanner(os.Stdin)

	for scanner.Scan() {
		line := scanner.Text()
		if line == "" {
			continue
		}

		var event FalcoEvent
		if err := json.Unmarshal([]byte(line), &event); err != nil {
			// skip lines that aren't valid JSON — Falco prints non-JSON startup
			// messages before it begins emitting events
			continue
		}

		// check if this event matches a known file-access rule
		if _, ok := fileAccessRules[event.Rule]; ok {
			alert := fmt.Sprintf("[%s] %s — %s", event.Priority, event.Rule, event.Output)
			fmt.Fprintln(os.Stderr, alert)
		}

		// also scan the output for mentions of suspicious files — I added this
		// because Falco's default file rules don't catch everything
		output := strings.ToLower(event.Output)
		for _, path := range suspiciousFiles {
			if strings.Contains(output, path) {
				fmt.Fprintf(os.Stderr, "[%s] Suspicious file access detected: %s — %s\n",
					event.Priority, path, event.Output)
			}
		}
	}

	if err := scanner.Err(); err != nil {
		fmt.Fprintf(os.Stderr, "error reading stdin: %v\n", err)
		os.Exit(1)
	}
}
