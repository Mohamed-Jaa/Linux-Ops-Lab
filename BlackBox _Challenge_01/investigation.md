# Technical Investigation & Forensic Analysis
**Analyst:** webadmin
**Resolution:** Service Restored ✅

---

## Phase 1: Diagnosis & Data Analysis
Based on the symptoms, the investigation focused on dynamic system changes (Disk/Ports).

### A. Log Analysis (system_monitor)
Execution of `tail -n 10 /var/log/system_alerts.log` revealed the following timeline:
* **08:00:01:** Disk usage at **82%** (Warning).
* **09:00:01:** Disk usage at **100%** (Critical) and Nginx status changed to **inactive**.
* **Conclusion:** The outage was directly caused by 100% disk saturation.

### B. Finding the Resource Drain
Execution of `find / -mmin -120 -type f -size +50M 2>/dev/null` identified:
* **Multiple Backup Files:** Rapid creation of `.tar.gz` files in `/var/backups/web/` between 08:00 and 09:00.

---

## Phase 2: Recovery Actions (Emergency Response)
1. **Manual Cleanup:** Executed `sudo rm /var/backups/web/backup_2026-01-13_*.tar.gz` to reclaim space.
2. **Space Verification:** `df -h /` confirmed usage dropped to **70%**.
3. **Service Restoration:** Executed `sudo systemctl start nginx`. Website accessibility confirmed.

---

## Phase 3: Root Cause Analysis (RCA)
Further investigation was conducted to determine how the backups were triggered.

1. **Crontab Audit:** * **Result:** Found an unauthorized entry: `*/5 * * * * /home/webadmin/scripts/backup_site.sh`.
   * **Action:** Removed the malicious line.

2. **Security Audit (auth.log):**
   * **Discovery:** Unauthorized login to `webadmin` from an external IP (**45.xx.xx.xx**) at **07:45**.
   * **Final Verdict:** An SSH intrusion occurred. The attacker modified the Crontab to cause a Denial of Service (DoS) via disk exhaustion.

---

## Phase 4: Prevention & Hardening
* **Cron Sanitization:** Deleted the unauthorized 5-minute interval entry.
* **Session Termination:** Logged out all unauthorized sessions.
* **Immediate:** Password updated ,Forced an immediate password change for the compromised account.
* **Proposed:** Transition to **SSH Key-based Authentication** to prevent brute-force or password-based intrusions.
