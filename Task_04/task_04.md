# Technical Report: System Monitoring
**Project Reference:** Task_004
**Target System:** Ubuntu 24.04 LTS
**Infrastructure Category:** System Monitoring & Observability

---

## 1. Executive Summary
The objective of this mission was to develop a resilient, automated monitoring agent (Watchdog) capable of tracking critical system resources and service availability. This solution implements a continuous logging philosophy, recording system states at regular intervals to provide a historical data baseline for performance analysis.

## 2. Methodology & Metric Extraction
The system utilizes native Linux diagnostic utilities, processed through text-stream editors to convert raw output into actionable data.

### A. Service Availability (Nginx)
* **Tool:** `systemctl is-active`
* **Logic:** The script queries the unit state; if the output deviates from `active`, a critical event is triggered.

### B. Storage Utilization (Root Partition)
* **Tool:** `df -h /`
* **Parsing:** `awk 'NR==2 {print $5}' | sed 's/%//'`
* **Logic:** Targeted the root filesystem usage percentage, stripping the `%` symbol to enable integer-based threshold comparison.

### C. Memory (RAM) Analysis
* **Tool:** `free`
* **Arithmetic:** `awk 'NR==2 {print int($3/$2 * 100)}'`
* **Logic:** Calculated the utilized memory ratio by dividing the used column ($3) by the total capacity ($2), resulting in a precise integer percentage.



## 3. Data Architecture (Standardized Logging)
To ensure machine-readability and ease of auditing, all events are channeled through a unified logging function.

**Log Format Specification:**
`[TIMESTAMP] | [SEVERITY_LEVEL] | [COMPONENT] | [STATUS_MESSAGE]`

* **Severity Definitions:**
    * **INFO:** Standard operational status (Resource usage < 80%).
    * **WARNING:** Resource threshold breach (Resource usage > 80%).
    * **CRITICAL:** Service failure or total unavailability.

## 4. Automation & Privilege Management
* **Privilege Level:** The script requires **Root** privileges to interact with systemd units and write to protected log directories.
* **Scheduling:** Automated via the **Root Crontab** (`sudo crontab -e`).
* **Frequency:** `0 * * * *` (Top of every hour).



## 5. Technical Challenges & Resolutions
| Identified Issue | Technical Root Cause | Resolution |
| **Environment Path Conflicts** | Relative paths in script causing failure when executed by Cron. | Implemented absolute paths for both the script location and the destination log file. |
