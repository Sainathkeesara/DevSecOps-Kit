# Tried installing Terrascan and scanning a tiny Terraform file today

I already had Terrascan installed from before, but I wanted to try the pip install this time to see if it works differently:

```bash
pip install terrascan
terrascan version
```

It worked — got v1.18.0. The binary install from GitHub is faster, but pip is more convenient if you're already in a Python venv.

I wrote the smallest Terraform file I could think of with a clear violation:

```hcl
resource "aws_ebs_volume" "unencrypted" {
  availability_zone = "us-east-1a"
  size              = 10
  encrypted         = false
}
```

Ran the scan:

```bash
terrascan scan -d .
```

It flagged it — `AWS.EBSVolume.EncryptionNotEnabled` (MEDIUM). Only one violation this time since it's a single resource.

I tried with `-o json` to see the full output:

```bash
terrascan scan -d . -o json | jq '.results.violations[0].rule_name'
```

Got `"ebsVolumeEncrypted"`. The JSON is way easier to grep through than the table output.

Something I noticed — Terrascan doesn't give you an exit code warning in the default output. `echo $?` gave 0 even with violations. You need `--exit-code 1` to make it useful for CI.

Next I should try writing a multi-resource template that triggers a handful of different rules, and maybe try the `--policy-type` flag to narrow the scan scope.
