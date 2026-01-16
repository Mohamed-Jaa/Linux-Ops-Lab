
# Technical Guide: Orchestrating Monitoring Services with Docker Compose
**Reference:** Task #008 | **Platform:** Linux / Ubuntu

### 1. Project Scoping and Directory Organization
In a professional DevOps workflow, every multi-container project must reside in its own isolated workspace. This prevents file clutter and ensures that Docker Compose can correctly scope the network and volume resources. We begin by creating a dedicated directory for our monitoring stack and navigating into it:
`
mkdir ~/monitoring-stack && cd ~/monitoring-stack `
### 2. Engineering the Infrastructure Blueprint (The YAML File)
The core of this task is creating the docker-compose.yml file. This YAML file acts as the "Source of Truth" for our infrastructure. Within this file, we define two services: Prometheus, configured to run on port 9090, and Grafana, configured for port 3000. We also declare "Volumes" to bridge the gap between volatile container storage and persistent host storage. Use the following configuration to build the stack:

`
nano docker-compose.yml `
(Inside the file, we define the services, ports, volumes, and networks following the standard YAML indentation which Docker uses to parse the infrastructure hierarchy.)

### 3. Implementing Data Persistence (Volumes)
Unlike the basic docker run command, Docker Compose allows us to define managed volumes. By adding the volumes key at the bottom of our YAML file and linking it within each service, we create a persistent data link. This ensures that even if a container is deleted or the server is rebooted, the Prometheus databases and Grafana dashboards remain intact on the host's physical disk. This is a critical step for stateful applications like monitoring tools.

### 4. Service Orchestration and Background Execution
With our blueprint finalized, we deploy the entire stack. Instead of launching containers one by one, we use the docker compose up command. By appending the -d (detached) flag, we instruct Docker to orchestrate the creation of the virtual network, the volumes, and the containers in the background. This keeps our terminal free while the services run as system daemons:

`
docker compose up -d `

### 5. Post-Deployment Verification
To ensure our "Infrastructure as Code" has been deployed correctly, we must audit the active stack. We use the ps command within the project directory to view the status of all services defined in our YAML file, checking that both services are in the Up state and their ports are correctly mapped:

`
docker compose ps`
### 6. External Connectivity and NAT Verification
The final test involves accessing the services via the host's IP. This confirms that the internal NAT/PAT rules have been successfully applied by Docker to the host's firewall. You can verify the deployment by navigating to:

Grafana Dashboard: http://SERVER_IP:3000 (Default credentials: admin/admin)

Prometheus API: http://SERVER_IP:9090
