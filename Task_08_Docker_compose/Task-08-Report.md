# Project Report: Multi-Service Infrastructure via Docker Compose
**Task ID:** #008 | **Engineer:** webadmin | **Status:** Success ✅

## 1. Executive Scenario: Scaling to Multi-Service Architecture
As our infrastructure needs evolved, the manual deployment of individual containers became inefficient. The requirement was to deploy a "Monitoring Stack" consisting of two interdependent services: Prometheus (for data collection) and Grafana (for visualization). The challenge was to ensure these services could communicate securely, share persistent storage, and be managed as a single logical unit.

## 2. Strategic Shift: Why Docker Compose?
Instead of using manual CLI commands, we adopted the **Infrastructure as Code (IaC)** approach using Docker Compose. This shift was motivated by:
* **Orchestration:** Managing the lifecycle (Start/Stop/Restart) of multiple containers with a single command.
* **Network Isolation (CCNA Perspective):** Docker Compose creates a dedicated virtual bridge (similar to a private VLAN) for this project. This ensures that the Monitoring Stack is isolated from other services, providing a layer of L2/L3 network security.
* **Persistence:** Using "Named Volumes" to decouple data from the container's lifecycle, ensuring that logs and dashboards are not lost during updates.

## 3. Post-Mortem & Troubleshooting
The implementation phase revealed key technical insights:
* **Service Dependency:** We implemented the `depends_on` directive. In initial tests, Grafana attempted to connect to Prometheus before the latter was fully initialized. Defining the dependency order solved this synchronization issue.
* **Volume Mapping:** We faced an initial challenge where Grafana settings reset after container restarts. We resolved this by implementing "Named Volumes" which anchor the container's internal data directories to the host's persistent storage.
* **Internal DNS Resolution:** We verified that containers could resolve each other using service names (e.g., `http://prometheus:9090`) without needing hardcoded internal IP addresses.

## 4. Final Conclusion
The Monitoring Stack is now fully operational and isolated within its own virtual network. This deployment marks our transition from simple container management to sophisticated infrastructure orchestration.
