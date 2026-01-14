# Project Report: Docker Infrastructure Implementation
**Task ID:** #007
**Status:** Completed ✅
**Subject:** Transitioning from Bare-Metal to Containerized Services

---

## 1. Project Context & Objectives
The goal was to host a new Nginx web service without installing any packages directly onto the host system (Ubuntu). This ensures a "Clean OS" environment and prevents dependency conflicts.

## 2. Technical Challenges & Risk Assessment
During the planning phase, we identified several potential issues that we successfully avoided:
* **Port Conflict:** Since a web server was already running on Port 80, we used **Port 8080** for the container to ensure both services remain accessible.
* **Installation Method:** We avoided using `snap` for Docker installation. `snap` often introduces strict confinement issues that can cause permission errors when accessing system resources or custom configurations.
* **Security:** We aimed to eliminate the need for `sudo` for routine Docker tasks to minimize the risk of accidental root-level system changes.

---

## 3. Incident Logs & Troubleshooting (Actual Issues Encountered)
During the implementation, the following issues were documented and resolved:

### Issue A: Permission Denied (Socket Access)
* **Symptom:** `permission denied while trying to connect to the docker API`.
* **Root Cause:** The `webadmin` user was added to the `docker` group, but the current terminal session had not refreshed its group membership permissions.
* **Resolution:** Re-authenticated the session or used `exec sg docker` to apply changes immediately.

### Issue B: Group Password Prompt (`newgrp` Failure)
* **Symptom:** The command `newgrp docker` prompted for a password and returned `Invalid password`.
* **Root Cause:** In certain Ubuntu environments, `newgrp` expects a group password that is not set.
* **Resolution:** Refreshed the user session by logging out and back in, which is a more reliable method for group propagation.

### Issue C: Deployment Typo (Image Not Found)
* **Symptom:** `Error response from daemon: pull access denied for helo-world`.
* **Root Cause:** A typo in the image name (`helo-world` instead of `hello-world`).
* **Resolution:** Corrected the spelling in the `docker run` command.

---

## 4. Final Result Summary
* **Host Nginx:** Active on Port 80.
* **Container Nginx:** Active on Port 8080.
* **User Permissions:** `webadmin` can manage all containers without root access.
