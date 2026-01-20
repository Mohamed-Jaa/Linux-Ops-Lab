# Task 10: Infrastructure Containerization & SSL Reverse Proxy Implementation - Completion Report

## 1. Executive Summary
This report documents the successful completion of Task 10, which involved migrating a service stack to a fully containerized architecture on an Ubuntu Server. The primary objective was to deploy Nginx as a secure (SSL/TLS) Reverse Proxy gateway for backend services (Grafana and Prometheus), ensuring strict network isolation and environment parity. The process required extensive troubleshooting to resolve architectural conflicts between the host system and the containerized environment.

## 2. Execution Roadmap
The implementation process followed a strict chronological sequence to ensure system integrity:

### Phase 1: Environment Preparation
- **Service Deconfliction:** Initiated the process by stopping and disabling the host-based Nginx service (`systemctl stop nginx`) to liberate ports 80 and 443.
- **Directory Structuring:** Established a dedicated workspace with specific sub-directories for certificates and configuration files to facilitate volume mounting.
- **Security Asset Generation:** Generated self-signed SSL certificates (`nginx-selfsigned.crt` and key) to enable encrypted HTTPS transport.

### Phase 2: Orchestration & Configuration
- **Docker Compose Definition:** Drafted the `docker-compose.yml` file, defining three isolated services (nginx, grafana, prometheus) and a custom bridge network (`monitor-net`).
- **Reverse Proxy Logic:** Created the `nginx.conf` file to handle SSL termination, HTTP-to-HTTPS redirection, and sub-path routing (`/grafana/`, `/prometheus/`).

### Phase 3: Iterative Deployment & Troubleshooting
- Deployed the stack using `docker compose up`.
- Conducted real-time debugging using container logs and network analysis tools (`netstat`, `curl`).
- Refined configuration parameters based on error feedback until stability was achieved.

## 3. Technical Challenges & Error Resolution Log
This project encountered several critical technical hurdles. Below is a detailed record of the errors faced and the solutions applied:

### A. Storage & Volume Mounting Errors
- **Issue:** The Docker daemon rejected the initial composition with the error `invalid mount config: mount path must be absolute`. This was caused by using relative paths (e.g., `./nginx.conf`) which are often incompatible with certain Docker host configurations.
- **Resolution:** Transitioned all volume mappings to **Absolute Paths** (e.g., `/home/webadmin/task10/...`) to ensure the container runtime could correctly locate host files.

### B. Configuration Syntax Failures
- **Issue:** The Nginx container failed to start, exiting immediately. Logs revealed a syntax error: `[emerg] unexpected "}"` in the configuration file.
- **Resolution:** Performed a code review of `nginx.conf`, removed the extraneous closing bracket, and validated the block structure.

### C. Network Visibility & Port Mapping
- **Issue:** While containers were listed as `Up`, services were unreachable from the host. Execution of `netstat -tulpn` revealed that ports 3000 and 9090 were not listening on the host interface.
- **Resolution:** Modified `docker-compose.yml` to explicitly publish ports for backend services, bridging the internal container network to the host's network stack.

### D. Routing Anomalies (The "Redirect Loop" & 404s)
- **Issue 1 (404 Not Found):** Backend services failed to render when accessed via sub-paths because they were unaware of the routing prefix.
- **Issue 2 (Redirect Loop):** A conflict occurred between Nginx's `proxy_pass` trailing slash and the application's internal routing, causing infinite redirection.
- **Issue 3 (Localhost Redirection):** Grafana redirected remote browser requests to `localhost:3000`, breaking access for external clients.
- **Resolution:**
    - **Nginx:** Removed the trailing slash from `proxy_pass` directives.
    - **Grafana:** Injected `GF_SERVER_ROOT_URL` and `GF_SERVER_SERVE_FROM_SUB_PATH` environment variables.
    - **Prometheus:** Added `--web.external-url` and `--web.route-prefix` flags to the startup command.

## 4. Final System Status
- **Status:** Operational.
- **Access:** All services are accessible via the single secure entry point (`https://<HOST_IP>/`).
- **Security:** SSL termination is active; direct access to backend services is managed via Docker networking rules.
- **Stability:** No configuration, network, or routing errors persist.
