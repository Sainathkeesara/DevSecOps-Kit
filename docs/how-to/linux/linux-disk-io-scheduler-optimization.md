# Linux: Disk I/O Scheduler Optimization for Database Workloads

## Purpose
This guide provides automated scripts and configuration patterns for optimizing Linux disk I/O schedulers specifically for database workloads (PostgreSQL, MySQL, MariaDB, Oracle). It covers scheduler selection, kernel tuning, and persistence configuration across RHEL/CentOS and Debian-based systems.

## When to Use
- Deploying database servers requiring low-latency I/O
- Tuning SSD/NVMe storage for transactional databases
- Optimizing HDD storage for analytical/warehouse workloads
- Automating scheduler configuration across database fleets
- Ensuring scheduler persistence across reboots

## Prerequisites
- Target Linux systems: RHEL 8+, CentOS 8+, Ubuntu 20.04+, Debian 10+
- Root or sudo access on target systems
- Block devices accessible: `/sys/block/<device>/queue/`
- For NVMe: `/sys/block/nvme*n1/queue/`
- Database installed or planned: PostgreSQL, MySQL, MariaDB, Oracle
- Ansible 2.9+ (if using automation)

## Steps

### 1. Detect Current Scheduler

```bash
#!/usr/bin/env bash
# detect-io-scheduler.sh — Detect current I/O scheduler settings
# Usage: ./detect-io-scheduler.sh [device]

set -euo pipefail

DEVICE="${1:-sda}"
SCHEDULER_PATH="/sys/block/${DEVICE}/queue/scheduler"
READAHEAD_PATH="/sys/block/${DEVICE}/queue/read_ahead_kb"
ROTATIONAL_PATH="/sys/block/${DEVICE}/queue/rotational"

if [[ -f "$SCHEDULER_PATH" ]]; then
    CURRENT_SCHEDULER=$(cat "$SCHEDULER_PATH")
    READAHEAD=$(cat "$READAHEAD_KB")
    ROTATIONAL=$(cat "$ROTATIONAL_PATH")
    
    echo "Device: ${DEVICE}"
    echo "Current Scheduler: ${CURRENT_SCHEDULER}"
    echo "Read Ahead: ${READAHEAD} KB"
    echo "Rotational: ${ROTATIONAL}"
else
    echo "Error: Device ${DEVICE} not found"
    exit 1
fi
```

### 2. Select Optimal Scheduler

| Workload Type | Recommended Scheduler | Rationale |
|--------------|----------------------|----------|
| Database (Transactional) | `none` or `mq-deadline` | Lowest latency, no scheduling overhead |
| Database (Analytical) | `bfq` | Fair queuing, throughput-oriented |
| General Purpose | `mq-deadline` | Balanced performance |
| SSD/NVMe | `none` | No scheduler needed, hardware handles queuing |

**Scheduler modes:**
- **none**: Noop scheduler — lowest latency, best for SSDs
- **mq-deadline**: Deadline scheduler — ensures request completion time bounds
- **bfq**: Budget Fair Queuing — best for mixedread/write workloads
- **kyber**: Latency-oriented — autonomous tuning

### 3. Apply Scheduler Configuration

```bash
#!/usr/bin/env bash
# set-io-scheduler.sh — Set I/O scheduler for block device
# Usage: ./set-io-scheduler.sh <device> <scheduler> [--dry-run]

set -euo pipefail

DRY_RUN="${3:-}"
DEVICE="$1"
SCHEDULER="$2"
SCHEDULER_PATH="/sys/block/${DEVICE}/queue/scheduler"
AVAILABLE_SCHEDULERS="none mq-deadline bfq kyber"

if [[ ! -f "$SCHEDULER_PATH" ]]; then
    echo "Error: Device ${DEVICE} not found"
    exit 1
fi

AVAILABLE=$(cat "$SCHEDULER_PATH" | tr -d '[]')
if [[ ! " $AVAILABLE " =~ " ${SCHEDULER} " ]]; then
    echo "Error: Scheduler ${SCHEDULER} not available"
    echo "Available: ${AVAILABLE}"
    exit 1
fi

if [[ "$DRY_RUN" == "--dry-run" ]]; then
    echo "[DRY-RUN] Would set ${DEVICE} scheduler to ${SCHEDULER}"
else
    echo "${SCHEDULER}" > "$SCHEDULER_PATH"
    echo "Set ${DEVICE} scheduler to ${SCHEDULER}"
fi
```

### 4. Configure Database Workload Optimization

```bash
#!/usr/bin/env bash
# tune-database-io.sh — Tune I/O for database workloads
# Usage: ./tune-database-io.sh <device> <workload-type>

set -euo pipefail

DEVICE="$1"
WORKLOAD_TYPE="$2"

case "$WORKLOAD_TYPE" in
    transactional)
        SCHEDULER="none"
        READAHEAD=8
        NCQ_QUEUE_DEPTH=31
        ;;
    analytical)
        SCHEDULER="bfq"
        READAHEAD=4096
        NCQ_QUEUE_DEPTH=31
        ;;
    mixed)
        SCHEDULER="mq-deadline"
        READAHEAD=256
        NCQ_QUEUE_DEPTH=31
        ;;
    *)
        echo "Error: Unknown workload type: ${WORKLOAD_TYPE}"
        echo "Supported: transactional, analytical, mixed"
        exit 1
        ;;
esac

echo "Configuring ${DEVICE} for ${WORKLOAD_TYPE} workload..."

/set-io-scheduler.sh "$DEVICE" "$SCHEDULER"
echo "$READAHEAD" > "/sys/block/${DEVICE}/queue/read_ahead_kb"
echo "$NCQ_QUEUE_DEPTH" > "/sys/block/${DEVICE}/queue/nr_requests"

echo "Configuration complete"
cat "/sys/block/${DEVICE}/queue/scheduler"
cat "/sys/block/${DEVICE}/queue/read_ahead_kb"
```

### 5. Make Scheduler Persistent (RHEL/CentOS)

```bash
#!/usr/bin/env bash
# configure-scheduler-persistent-rhel.sh — Make scheduler persist across reboots
# Usage: ./configure-scheduler-persistent-rhel.sh <device> <scheduler>

set -euo pipefail

DEVICE="$1"
SCHEDULER="$2"

GRUB_CONF="/etc/default/grub"
GRUB_CFG="/boot/grub2/grub.cfg"

if [[ ! -f "$GRUB_CONF" ]]; then
    echo "Error: GRUB config not found"
    exit 1
fi

CURRENT_LINE=$(grep "^GRUB_CMDLINE_LINUX" "$GRUB_CONF")

if [[ "$CURRENT_LINE" =~ elevator=([^ "]+) ]]; then
    NEW_LINE=$(echo "$CURRENT_LINE" | sed "s/elevator=[^ \" ]*/elevator=${SCHEDULER}/")
else
    NEW_LINE="${CURRENT_LINE} elevator=${SCHEDULER}"
fi

sed -i "s|^GRUB_CMDLINE_LINUX=.*|${NEW_LINE}|" "$GRUB_CONF"

if [[ -f "$GRUB_CFG" ]]; then
    grub2-mkconfig -o "$GRUB_CFG"
fi

echo "Added elevator=${SCHEDULER} to GRUB_CMDLINE_LINUX"
echo "Run 'grub2-mkconfig' or reboot to apply"
```

### 6. Make Scheduler Persistent (Ubuntu/Debian)

```bash
#!/usr/bin/env bash
# configure-scheduler-persistent-ubuntu.sh — Make scheduler persist across reboots
# Usage: ./configure-scheduler-persistent-ubuntu.sh <device> <scheduler>

set -euo pipefail

DEVICE="$1"
SCHEDULER="$2"

UDEV_RULE="/etc/udev/rules.d/60-scheduler.rules"

if [[ -d "/sys/block/${DEVICE}" ]]; then
    cat > "$UDEV_RULE" << EOF
# Set I/O scheduler for $DEVICE
ACTION=="add|change", KERNEL=="${DEVICE}", ATTR{queue/scheduler}="${SCHEDULER}"
EOF

    chmod 644 "$UDEV_RULE"
    echo "Created ${UDEV_RULE}"
else
    echo "Error: Device ${DEVICE} not found"
    exit 1
fi
```

### 7. Ansible Playbook for Fleet Deployment

```yaml
---
- name: Configure I/O scheduler for database workloads
  hosts: databases
  become: yes
  gather_facts: yes

  vars:
    db_scheduler: none
    db_read_ahead: 8
    db_workload_type: transactional

  tasks:
    - name: Get block devices
      shell: lsblk -o NAME -n | grep -E '^(sd|nvme)' | head -10
      register: block_devices

    - name: Set I/O scheduler
      loop: "{{ block_devices.stdout_lines }}"
      loop_control:
        loop_var: device
      sysfs:
        path: "/sys/block/{{ device }}/queue/scheduler"
        value: "{{ db_scheduler }}"
        state: present

    - name: Set read ahead
      loop: "{{ block_devices.stdout_lines }}"
      loop_control:
        loop_var: device
      sysfs:
        path: "/sys/block/{{ device }}/queue/read_ahead_kb"
        value: "{{ db_read_ahead }}"
        state: present

    - name: Verify configuration
      loop: "{{ block_devices.stdout_lines }}"
      loop_control:
        loop_var: device
      debug:
        msg: "Device {{ device }}: {{ lookup('file', '/sys/block/' + device + '/queue/scheduler') }}"
```

### 8. Database-Specific Tuning

**PostgreSQL:**
```bash
# /etc/sysctl.d/99-postgresql.conf
# Postgres I/O optimization
kernel.sched_migration_cost_ns = 5000000
kernel.sched_autogroup_enabled = 0

# File system tuning
fs.aio-max-nr = 1048576
```

**MySQL/MariaDB:**
```bash
# /etc/my.cnf.d/io-tuning.cnf
[mysqld]
innodb_flush_method = O_DIRECT
innodb_flush_neighbors = 0
innodb_io_capacity = 2000
innodb_io_capacity_max = 4000
innodb_read_io_threads = 16
innodb_write_io_threads = 16
```

## Verify

### 1. Check Current Settings
```bash
for dev in sda nvme0n1; do
    echo "=== $dev ==="
    cat "/sys/block/$dev/queue/scheduler"
    cat "/sys/block/$dev/queue/read_ahead_kb"
    cat "/sys/block/$dev/queue/nr_requests"
done
```

### 2. Benchmark with fio
```bash
# Install fio
apt install fio  # Debian/Ubuntu
yum install fio  # RHEL/CentOS

# Random read test (transactional simulation)
fio --name=randread --ioengine=libaio --iodepth=32 --rw=randread \
    --bs=4k --direct=1 --size=1G --numjobs=4 --runtime=30 \
    --time_based --group_reporting

# Sequential read test (analytical simulation)
fio --name=seqread --ioengine=libaio --iodepth=32 --rw=read \
    --bs=128k --direct=1 --size=1G --numjobs=4 --runtime=30 \
    --time_based --group_reporting
```

### 3. Verify Persistence After Reboot
```bash
# Reboot and verify
reboot
sleep 60

# Check settings persist
cat /sys/block/sda/queue/scheduler
```

## Rollback

### 1. Revert to Default Scheduler
```bash
# Reset scheduler to mq-deadline
echo "mq-deadline" | sudo tee /sys/block/sda/queue/scheduler

# Reset read ahead to default
echo "128" | sudo tee /sys/block/sda/queue/read_ahead_kb

# Remove persistence rules
sudo rm /etc/udev/rules.d/60-scheduler.rules
```

### 2. Revert GRUB Configuration
```bash
# Edit GRUB config
sudo vi /etc/default/grub

# Remove elevator= parameter and regenerate
sudo grub2-mkconfig  # RHEL
sudo update-grub      # Ubuntu
```

## Common Errors

### Error: "No such file or directory" for scheduler path
**Cause:** Device does not exist or is not a block device.
```bash
# List available block devices
lsblk
ls /sys/block/
```

### Error: Invalid scheduler selected
**Cause:** Scheduler not available for this device.
```bash
# Check available schedulers
cat /sys/block/sda/queue/scheduler
# Output: [none] mq-deadline bfq kyber
```

### Error: Scheduler reverts after reboot
**Cause:** Persistence not configured.
```bash
# Verify udev rule exists
ls -la /etc/udev/rules.d/60-scheduler.rules

# Or check GRUB config
grep elevator /etc/default/grub
grep GRUB_CMDLINE_LINUX /etc/default/grub
```

### Error: Permission denied when writing to sysfs
**Cause:** Insufficient privileges.
```bash
# Use sudo
sudo echo "none" > /sys/block/sda/queue/scheduler
```

## References
- [Linux I/O Scheduler Documentation](https://www.kernel.org/doc/Documentation/block/iosched.txt)
- [Kernel sysfs documentation](https://www.kernel.org/doc/Documentation/admin-guide/sysfs-block-zram.rst)
- [fio Homepage](https://fio.readthedocs.io/)
- [PostgreSQL Performance Tuning](https://www.postgresql.org/docs/current/runtime-config-resource.html)
- [MySQL InnoDB Tuning](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_flush_method)