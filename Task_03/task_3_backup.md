# Technical Report: Automated Backup System for Web Servers
**Project Reference:** Task_003  
**Target System:** Ubuntu 24.04 LTS  
**Author:** [Daniel-Wix]

---

## 1. Problem Statement
Manual data backup is prone to human error and inconsistency. In a production environment, failure to back up critical web files can lead to irreversible data loss. The objective was to design a fully automated, time-stamped, and self-cleaning backup system to ensure business continuity.

## 2. Technical Solution
The solution was implemented using a Bash script integrated with the Linux Cron service. The core logic relies on efficient archiving and dynamic file naming to prevent data overwriting.

### A. Archiving & Compression (The `tar` Command)
To optimize storage, the `tar` utility was used with specific flags to consolidate and compress the web directory.
- **Syntax:** `tar -czf [Backup_Path] [Source_Directory]`
- **Flags Breakdown:**
    - `-c`: Create a new archive.
    - `-z`: Compress the archive using Gzip.
    - `-f`: Specify the resulting filename.

### B. Dynamic Naming (The `date` Variable)
To maintain a historical log of backups, the `date` command was utilized to generate unique timestamps.
- **Variable Logic:** `TIME=$(date +%Y-%m-%d_%H%M)`
- **Result:** Each file is uniquely identified (e.g., `backup_2026-01-11_1830.tar.gz`).



## 3. Implementation Steps
1. **Environment Setup:** Created dedicated directories for scripts (`/home/webadmin/scripts`) and archives (`/var/backups/web`).
2. **Script Development:** Authored a Bash script to automate the backup and cleaning process.
3. **Execution Permissions:** Granted executable rights using `chmod +x`.
4. **Task Scheduling:** Configured a Cron Job to execute the script daily at 03:00 AM.
    - **Crontab Entry:** `0 3 * * * /path/to/script.sh`



## 4. Challenges & Troubleshooting
During the development phase, several technical hurdles were encountered and resolved:

| Challenge | Root Cause | Solution |
| :--- | :--- | :--- |
| **Syntax Error: Command not found** | Improper use of white spaces around variables (e.g., `VAR = value`). | Removed spaces to comply with Bash syntax (`VAR="value"`). |
| **Permission Denied** | Insufficient privileges to write in `/var/backups`. | Corrected ownership using `chown webadmin:webadmin`. |
| **Script Failure in Cron** | Use of relative paths within the script. | Switched to absolute paths for all directories and commands. |
| **Broken String Error** | Unclosed quotation marks in the script. | Audited the code for syntax integrity and closed all strings. |

## 5. Storage Optimization (Retention Policy)
To prevent disk space exhaustion, a self-cleaning mechanism was integrated.
- **Command:** `find $DEST -name "*.tar.gz" -type f -mtime +15 -delete`
- **Logic:** Automatically identifies and removes archives older than 15 days, maintaining a rolling 15-day backup history.

---
