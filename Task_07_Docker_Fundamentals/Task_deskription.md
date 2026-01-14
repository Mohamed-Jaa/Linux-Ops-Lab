# Task 007: Modernizing Service Deployment with Docker
**Category:** Containerization & Infrastructure Isolation
**Status:** Completed ✅

## 1. Business Need & Requirement
In modern cloud environments, maintaining a "Clean OS" is a priority. The organization required a way to host a new web monitoring service without installing additional packages or dependencies directly onto the host Ubuntu server. This avoids "Dependency Hell" and prevents system bloat.

## 2. Challenges
* **Resource Isolation:** Running multiple services (Nginx Host vs. Nginx Container) without port conflicts.
* **Security:** Ensuring the `webadmin` user can manage containers without needing full `sudo` (root) privileges for every command.
* **Deployment Method:** Avoiding `snap` packages and relying on the official Docker repository for stability and standard permissions.

## 3. Success Criteria
1. Successful installation of Docker Engine via official repositories.
2. Managing Docker containers as a non-root user (`webadmin`).
3. Running a web service (Nginx) inside a container on a non-standard port (8080).
