# Linux Kernel Live Patching with kpatch

---
SQUIRREL:
  title: "Linux Kernel Live Patching with kpatch for CVE-2026-33001"
  category: "linux"
  tags: ["linux", "kpatch", "kernel", "live-patching", "cve", "security", "cve-2026-33001"]
  last_verified: "2026-05-10"
  version: "kpatch 0.9.9+"
---

## Purpose

This guide provides comprehensive instructions for deploying and managing kpatch live kernel patching on Linux systems to mitigate CVE-2026-33001 and other kernel vulnerabilities. Live patching allows kernel security fixes to be applied without rebooting the system, ensuring continuous uptime while maintaining security compliance.

## When to use

- Immediately when kernel security patches are released for CVE-2026-33001
- For production systems requiring zero-downtime kernel updates
- During maintenance windows where reboots are not feasible
- For critical infrastructure requiring continuous availability
- As part of a defense-in-depth kernel security strategy
- When kernel CVE patches need to be applied urgently without scheduling downtime

## Prerequisites

- Root/sudo access to the Linux system
- RHEL 8+, Rocky Linux 8+, AlmaLinux 8+, or Fedora 35+
- Kernel version 4.0 or later (for full kpatch support)
- bash 4.0 or higher
- `gcc`, `make`, `git` (for building kpatch from source if needed)
- At least 500MB free disk space for kpatch installation
- Internet connectivity for package downloads (or local repository access)

## Affected Systems

- Red Hat Enterprise Linux 8.x / 9.x
- Rocky Linux 8.x / 9.x
- AlmaLinux 8.x / 9.x
- Fedora 35+
- CentOS 8 (with EPEL kpatch packages)

**Note**: Ubuntu and Debian require building kpatch from source as packages are not available in official repos.

## Steps

### Step 1: Verify System Compatibility

```bash
# Check current kernel version
uname -r

# Check OS version
cat /etc/os-release

# Verify kernel supports kpatch
cat /proc/config.gz | grep -i kpatch || echo "Kernel config check"

# Check if running in a container (kpatch may have limitations)
cat /proc/1/cgroup | head -5
```

### Step 2: Install kpatch

```bash
# Using the deployment script (recommended)
sudo ./scripts/bash/linux_toolkit/security/kpatch-deployment.sh --install

# Dry-run mode to preview changes
sudo DRY_RUN=true ./scripts/bash/linux_toolkit/security/kpatch-deployment.sh --install

# Manual installation (RHEL/Rocky/AlmaLinux)
sudo dnf install -y kpatch

# Manual installation (Fedora)
sudo dnf install -y kpatch

# For Ubuntu/Debian - build from source
git clone https://github.com/dynes/kpatch.git
cd kpatch
make
sudo make install
```

### Step 3: Check kpatch Status

```bash
# Using the script
sudo ./scripts/bash/linux_toolkit/security/kpatch-deployment.sh --status

# Manual commands
kpatch --version
kpatch list
lsmod | grep kpatch
```

### Step 4: Verify CVE-2026-33001 Status

```bash
# Check if kernel has CVE-2026-33001 fix
sudo ./scripts/bash/linux_toolkit/security/kpatch-deployment.sh --verify

# Check Red Hat errata
sudo dnf updateinfo list security | grep -i CVE-2026-33001

# Check applied kpatches
kpatch list

# Verify kernel version against known fixed versions
uname -r
```

### Step 5: Apply Kernel Patches

```bash
# Apply a specific patch file
sudo ./scripts/bash/linux_toolkit/security/kpatch-deployment.sh --apply /path/to/patch.patch

# Dry-run to verify patch compatibility
sudo DRY_RUN=true ./scripts/bash/linux_toolkit/security/kpatch-deployment.sh --apply /path/to/patch.patch

# Check patch contents before applying
kpatch info /path/to/patch.patch

# List applied patches after installation
kpatch list
```

### Step 6: Remove Patches

```bash
# Remove a specific patch by name
sudo ./scripts/bash/linux_toolkit/security/kpatch-deployment.sh --remove patch-name

# Remove all patches
sudo ./scripts/bash/linux_toolkit/security/kpatch-deployment.sh --remove

# Manual removal
sudo kpatch uninstall patch-name
sudo kpatch unload --all
```

### Step 7: Configure Automatic Updates

```bash
# The script automatically sets up cron for daily updates
# Verify cron job
cat /etc/cron.d/kpatch-update

# Check systemd service status
systemctl status kpatch.service

# Enable on boot
sudo systemctl enable kpatch.service
```

## Verify

After applying kpatch, verify the installation:

```bash
# 1. Check kpatch is installed
kpatch --version

# 2. Verify module is loaded
lsmod | grep kpatch
# Should show: kpatch

# 3. List applied patches
kpatch list
# Should show applied patches with status

# 4. Check system uptime (confirm no reboot needed)
uptime
# Should show extended uptime if live patching worked

# 5. Verify kernel version
uname -r
# Note: Kernel version doesn't change with kpatch - patches are loaded at runtime

# 6. Check kpatch service status
systemctl status kpatch.service

# 7. Verify no kernel panic or errors
dmesg | grep -i kpatch | tail -20

# 8. For CVE-2026-33001 specifically
sudo ./scripts/bash/linux_toolkit/security/kpatch-deployment.sh --verify
```

## Rollback

If kpatch causes issues or needs to be removed:

```bash
# Remove all patches and configuration
sudo ./scripts/bash/linux_toolkit/security/kpatch-deployment.sh --rollback

# Manual rollback steps
sudo kpatch unload --all
sudo rmmod kpatch
sudo systemctl disable kpatch.service
sudo rm /etc/systemd/system/kpatch.service

# After rollback, if issues persist, consider kernel update with reboot
sudo dnf update -y
sudo reboot
```

## Common errors

**"kpatch: command not found"**
- Install kpatch: `dnf install -y kpatch` or build from source
- Verify installation path is in $PATH

**"modprobe: FATAL: Module kpatch not found"**
- kpatch module not built for current kernel
- Build module: `kpatch build`
- Check kernel version compatibility

**"Permission denied" errors**
- Ensure running with sudo/root privileges
- kpatch requires root access for kernel module operations

**"Patch application failed"**
- Verify patch is compatible with kernel version
- Check patch signature: `kpatch info patch.patch`
- Review dmesg for detailed error: `dmesg | tail -50`

**"No space left on device"**
- Free up disk space (kpatch needs ~500MB)
- Clean old kernels: `dnf autoremove`

**"kpatch not supported in container"**
- kpatch requires host kernel, not available in containers
- Apply patches on host system directly

**"Kernel too old for kpatch"**
- kpatch requires kernel 4.0+
- Consider upgrading kernel: `dnf update kernel`

**"Failed to load module"**
- Check kernel config: `zcat /proc/config.gz | grep KPATCH`
- Rebuild initramfs: `dracut -f`
- Verify kernel supports live patching

## References

- kpatch GitHub: https://github.com/dynes/kpatch
- Red Hat kpatch Documentation: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_monitoring_and_updating_the_kernel/using-kpatch-for-live-patching Managing Kernel Updates with kpatch
- NVD CVE-2026-33001: https://nvd.nist.gov/vuln/detail/CVE-2026-33001
- Red Hat Kernel Live Patching: https://access.redhat.com/products/red-hat-kernel-live-patching
- kpatch Architecture: https://www.kernel.org/doc/Documentation/kpatch.txt
- CentOS kpatch: https://wiki.centos.org/HowTos/CommonKpatchIssues
- Fedora Kernel Updates: https://docs.fedoraproject.org/en-US/kernel-realtime/