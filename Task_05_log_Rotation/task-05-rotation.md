# Technical Report: Log Rotation and Data Retention Policy
**Project Reference:** Task_005
**Target System:** Ubuntu 24.04 LTS
**Category:** Log Management & Storage Optimization

---

## 1. Executive Summary
The primary objective of this mission was to implement a robust Log Management strategy to prevent storage exhaustion. By utilizing the Linux `logrotate` utility, a systematic rotation and archival policy was established for the `system_alerts.log` file, ensuring the monitoring system remains sustainable over long-term operations.

## 2. Retention Policy Configuration
A custom configuration was deployed at `/etc/logrotate.d/watchdog_rotate` using the following parameters:

* **Frequency:** `daily` - Executes the rotation process every 24 hours.
* **Retention:** `rotate 7` - Maintains exactly seven historical log files before overwriting the oldest.
* **Compression:** `compress` - Utilizes gzip to minimize disk space consumption for archived logs.
* **Error Handling:** * `missingok`: Prevents system errors if the log file is temporarily unavailable.
    * `notifempty`: Skips rotation if the file contains no data to save resources.
* **File Re-creation:** `create 0644 webadmin webadmin` - Ensures a new, empty log file is generated immediately with correct ownership and permissions.
* **Security Context:** `su webadmin webadmin` - Explicitly defines the user and group context to handle directory permission constraints.

---

## 3. Implementation Process & Verification
The implementation followed a rigorous testing phase to ensure policy integrity:

### A. Syntax Validation (Dry Run)
The configuration was verified using the debug flag:
`sudo logrotate -d /etc/logrotate.d/watchdog_rotate`

### B. Execution Force
The policy was manually triggered to verify the creation of the first compressed archive:
`sudo logrotate -f /etc/logrotate.d/watchdog_rotate`

---

## 4. Technical Challenges & Resolutions

| Identified Issue | Technical Root Cause | Resolution |
| :--- | :--- | :--- |
| **Syntax Error: unknown option 'creat'** | Typographical error in the configuration directive. | Corrected to the standard `create` keyword. |
| **Insecure Parent Directory** | Wide permissions on the parent log directory (Security restriction). | Implemented the `su` directive to define safe execution privileges. |
| **Permission Denied** | Ownership conflicts during new file generation. | Synchronized ownership between the rotation service and the monitoring agent. |

---
