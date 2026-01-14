# Incident Report: Service Outage - BlackBox Challenge #01
**Date:** 2026-01-13  
**Initial Alert Time:** 11:30 UTC  
**Severity:** Critical (S1)  
**Status:** Resolved ✅

## 1. Initial Situation
At 11:30 UTC, I was notified that the production website was unreachable. Preliminary checks confirmed that the server was up (SSH accessible), but the web service was completely down.

## 2. Observed Symptoms
* **External:** Browsers returned `ERR_CONNECTION_REFUSED`.
* **Internal:** Running `systemctl status nginx` showed the service as `inactive (dead)`.
* **System Error:** Attempts to restart the service manually failed with:  
  > `Job for nginx.service failed because the control process exited with error code.`

## 3. Investigation Goal
The initial cause was unknown. The primary objective was to diagnose why Nginx failed to start and restore service as quickly as possible.
