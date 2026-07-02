# Create a cron job
# check oS
cat /etc/*os*

# instal cron package
centos => sudo yum install cronie
ubuntu => sudo apt install cronie

# verify if crond service is running or not
systemctl status crond
# to run the service => 
systemctl start crond

# create cron job
crontab -e 
vim editor will be opened and set the crn job in it 
example: */5 * * * * echo hello > /tmp/cron_text
- Each user has one crontab file, and that file can contain many cron entries.

# Example:
     - # Run every 5 minutes
      */5 * * * * echo "Job 1" >> /tmp/job1.log
      
      # Run every hour
      0 * * * * date >> /tmp/hourly.log
      
      # Run every day at 2:30 AM
      30 2 * * * /usr/local/bin/backup.sh
      
      # Run every Monday at 9 AM
      0 9 * * 1 /usr/local/bin/report.sh

# verify the cron jobs:
crontab -l



# More info:
````markdown
# Linux Cron Jobs - DevOps Quick Notes

## What is Cron?

Cron is a Linux scheduler that automatically executes commands or scripts at specified times.

**Common Use Cases**
- Database backups
- Log cleanup
- Health checks
- Certificate renewal
- File synchronization
- Report generation

---

# How Cron Works

```text
Cron Daemon (crond)
        │
        ▼
Reads Crontab
        │
        ▼
Executes Scheduled Command
```

### Components

| Component | Description |
|-----------|-------------|
| **crond** | Background service that checks every minute for scheduled jobs. |
| **Crontab** | File containing scheduled jobs. Each user has their own crontab. |
| **Command/Script** | The actual command or shell script to execute. |

---

# Check Cron Service

## RHEL / CentOS

```bash
rpm -q cronie
systemctl status crond
```

Start if not running:

```bash
sudo systemctl start crond
sudo systemctl enable crond
```

## Ubuntu

```bash
dpkg -l cron
systemctl status cron
```

---

# Creating a Cron Job

## Step 1 - Open Crontab

```bash
crontab -e
```

---

## Step 2 - Add Cron Entry

```cron
* * * * * command_to_execute
```

---

## Step 3 - Save

- **Nano**
  - Ctrl + O
  - Enter
  - Ctrl + X

- **Vim**

```vim
:wq
```

Cron automatically loads the new schedule.

---

# Cron Syntax

```text
* * * * * command
│ │ │ │ │
│ │ │ │ └── Day of Week (0-7)
│ │ │ └──── Month (1-12)
│ │ └────── Day of Month (1-31)
│ └──────── Hour (0-23)
└────────── Minute (0-59)
```

| Field | Allowed Values |
|--------|----------------|
| Minute | 0-59 |
| Hour | 0-23 |
| Day of Month | 1-31 |
| Month | 1-12 |
| Day of Week | 0-7 (0 & 7 = Sunday) |

---

# Special Characters

| Symbol | Meaning | Example |
|---------|---------|---------|
| `*` | Every value | `* * * * *` |
| `,` | Multiple values | `1,15,30` |
| `-` | Range | `1-5` |
| `/` | Step value | `*/10` |

---

# Common Cron Examples

| Schedule | Expression |
|----------|------------|
| Every minute | `* * * * *` |
| Every 5 minutes | `*/5 * * * *` |
| Every 10 minutes | `*/10 * * * *` |
| Every hour | `0 * * * *` |
| Every day at midnight | `0 0 * * *` |
| Every day at 2:30 AM | `30 2 * * *` |
| Every Monday at 9 AM | `0 9 * * 1` |
| Every Sunday at 3 AM | `0 3 * * 0` |
| First day of every month | `0 0 1 * *` |

---

# Practical Example

### Create Script

```bash
mkdir ~/cron-demo
cd ~/cron-demo
nano hello.sh
```

```bash
#!/bin/bash

echo "Cron executed at $(date)" >> ~/cron-demo/output.log
```

Make executable

```bash
chmod +x hello.sh
```

Test manually

```bash
./hello.sh
```

Schedule every 2 minutes

```bash
crontab -e
```

```cron
*/2 * * * * /home/username/cron-demo/hello.sh
```

Verify

```bash
cat ~/cron-demo/output.log
```

---

# Managing Cron Jobs

## List Jobs

```bash
crontab -l
```

## Edit Jobs

```bash
crontab -e
```

## Delete All Jobs

```bash
crontab -r
```

---

# Where Cron Files Are Stored

### User Cron

```text
/var/spool/cron/
```

### System-wide Cron

```text
/etc/crontab
/etc/cron.d/
/etc/cron.daily/
/etc/cron.hourly/
/etc/cron.weekly/
/etc/cron.monthly/
```

---

# User Crontab vs `/etc/crontab`

| User Crontab (`crontab -e`) | `/etc/crontab` |
|------------------------------|----------------|
| Per-user cron jobs | System-wide cron jobs |
| No username field | Includes username field |
| Managed by individual users | Managed by root |
| Edited using `crontab -e` | Edited with text editor (`vi`, `nano`) |

### Example (User Crontab)

```cron
0 2 * * * /home/user/backup.sh
```

### Example (`/etc/crontab`)

```cron
0 2 * * * root /usr/local/bin/backup.sh
```

Notice the extra **username** (`root`) field.

---

# Cron vs systemd Timers

| Cron | systemd Timer |
|------|---------------|
| Older scheduler | Modern Linux scheduler |
| Time-based scheduling | Time + dependency-based scheduling |
| Simple syntax | More configuration |
| Limited logging | Better logging (`journalctl`) |
| Doesn't track missed jobs | Can run missed jobs after boot (`Persistent=true`) |
| Available on almost every Linux distro | Requires systemd |

### Use Cron When

- Simple periodic tasks
- Legacy systems
- Lightweight automation

### Use systemd Timers When

- Production services
- Better logging
- Dependency management
- Missed-job recovery
- Modern Linux environments

---

# Environment Variables in Cron

Cron runs with a **minimal environment**, unlike your interactive shell.

### Common Problem

This may work in a terminal:

```bash
python app.py
```

But fail in cron because `PATH` is different.

### Best Practice

Use absolute paths.

Instead of:

```cron
python app.py
```

Use:

```cron
/usr/bin/python3 /home/user/app.py
```

You can define environment variables at the top of your crontab:

```cron
SHELL=/bin/bash
PATH=/usr/local/bin:/usr/bin:/bin
MAILTO=admin@example.com

*/5 * * * * /home/user/script.sh
```

Useful variables:

| Variable | Purpose |
|-----------|----------|
| `PATH` | Command search path |
| `SHELL` | Shell to execute commands |
| `MAILTO` | Email cron output |
| `HOME` | User's home directory |

---

# Why Cron Jobs Sometimes Fail

## 1. Wrong PATH

❌

```cron
python app.py
```

✅

```cron
/usr/bin/python3 /home/user/app.py
```

---

## 2. Relative Paths

❌

```cron
./backup.sh
```

✅

```cron
/home/user/scripts/backup.sh
```

---

## 3. Missing Execute Permission

```bash
chmod +x script.sh
```

---

## 4. Cron Service Not Running

```bash
systemctl status crond
```

---

## 5. Incorrect Time Expression

Example:

```cron
60 * * * *
```

Invalid because minutes are `0-59`.

---

## 6. Missing Environment Variables

Cron doesn't load `.bashrc` or `.profile`.

---

## 7. Output Not Logged

Always redirect output.

```cron
*/5 * * * * /home/user/script.sh >> /var/log/script.log 2>&1
```

---

## 8. File Permissions

Ensure the cron user has permission to:

- Execute the script
- Read input files
- Write output files

---

# Cron Best Practices

- ✅ Always use absolute paths.
- ✅ Test scripts manually before scheduling.
- ✅ Redirect output to log files.
- ✅ Use executable permissions (`chmod +x`).
- ✅ Keep cron jobs idempotent (safe to run multiple times).
- ✅ Monitor logs for failures.
- ✅ Document your cron jobs.

---

# Useful Commands

| Command | Description |
|----------|-------------|
| `crontab -e` | Edit cron jobs |
| `crontab -l` | List cron jobs |
| `crontab -r` | Remove all cron jobs |
| `systemctl status crond` | Check cron service (RHEL/CentOS) |
| `systemctl start crond` | Start cron service |
| `systemctl enable crond` | Enable cron at boot |
| `chmod +x script.sh` | Make script executable |

---

# Interview Tips

Be comfortable explaining:

- ✅ How cron works internally
- ✅ Cron syntax (`* * * * *`)
- ✅ User crontab vs `/etc/crontab`
- ✅ Cron vs systemd timers
- ✅ Environment variables in cron
- ✅ Common reasons cron jobs fail
- ✅ How to debug a failed cron job
- ✅ Best practices for production cron jobs
````
