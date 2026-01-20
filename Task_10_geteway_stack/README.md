# Task 10: Infrastructure Containerization & Secure Reverse Proxy Implementation

## 1. Objective
The goal of this task is to transition the monitoring infrastructure from a host-based installation to a fully containerized environment using Docker Compose. This migration aims to achieve environment parity, portability, and centralized security management through an SSL-terminated Reverse Proxy.

## 2. Infrastructure Requirements

### A. Containerization (Docker Compose)
- **Service Isolation:** Deploy Nginx, Grafana, and Prometheus as independent, isolated containers.
- **Network Architecture:** Define a dedicated internal Docker network (bridge driver) to facilitate secure inter-container communication without exposing all services to the public interface.
- **Persistence:** Implement volume mounting to ensure that monitoring data and configuration files persist across container restarts.

### B. Security & SSL Termination
- **Single Entry Point:** Configure Nginx as the sole gateway for all incoming traffic (Port 80 and 443).
- **Encryption:** Implement SSL/TLS using self-signed certificates to secure data in transit.
- **Traffic Redirection:** Enforce a global redirect rule from HTTP to HTTPS.

### C. Advanced Routing (Sub-path Proxying)
- **Reverse Proxy Logic:** Route external requests to the appropriate backend service based on the URL path:
  - `https://<SERVER_IP>/grafana/` → Internal Grafana Instance.
  - `https://<SERVER_IP>/prometheus/` → Internal Prometheus Instance.
- **Header Transparency:** Ensure the proxy passes essential headers (Host, X-Real-IP, X-Forwarded-Proto) to maintain session integrity.

## 3. Scope of Work
- **Orchestration:** Writing a `docker-compose.yml` file that defines services, networks, and volumes.
- **Configuration Management:** Designing an `nginx.conf` that supports SSL and complex sub-path routing.
- **Security Hardening:** Managing file permissions for sensitive assets (certificates/keys) within the container environment.
- **Service Integration:** Adjusting internal service parameters to ensure compatibility with reverse proxy sub-paths.

## 4. Expected Outcomes
- A fully functional, containerized monitoring stack accessible via a single secure IP.
- Elimination of port conflicts with the host system.
- Standardized deployment process using a single command (`docker-compose up`).
```
