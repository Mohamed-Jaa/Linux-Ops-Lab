# Implementation Guide: Hardening & SSL Proxy Orchestration
**Task ID:** #009
**Status:** Completed ✅
**Standard:** Production-Grade Security


## 1. Phase 1: Network Layer Hardening (Docker & UFW)
The first step in securing the infrastructure was to eliminate direct external access to the backend services. We encountered a critical security bypass where Docker's default NAT rules overrode the system's `ufw` firewall.

### The Fix: Localhost Binding
To solve the UFW bypass, we restricted the container ports to the local loopback interface (`127.0.0.1`). This ensures the services are only reachable by the local Nginx instance.

**Action: Update `docker-compose.yml`**
```yaml
services:
  prometheus:
    ports:
      - "127.0.0.1:9090:9090"
  grafana:
    ports:
      - "127.0.0.1:3000:3000"

```

*After applying this, external access to `http://IP:3000` is effectively blocked at the network level.*

---

## 2. Phase 2: Reverse Proxy & Header Engineering

We configured Nginx to act as the primary gateway. A crucial part of this phase was the use of **Proxy Headers** to ensure backend services could identify the real client.

### Understanding the Headers

Inside the `/etc/nginx/sites-available/default` configuration, we implemented the following:

* `proxy_set_header Host $host`: Passes the original domain/IP requested by the user.
* `proxy_set_header X-Real-IP $remote_addr`: Passes the actual client IP for security logging.
* `proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for`: Maintains a list of all IPs the request passed through.
* `proxy_set_header X-Forwarded-Proto $scheme`: Tells the backend whether the user is using `http` or `https`.

---

## 3. Phase 3: Solving the "404 Not Found" & Path Conflicts

When accessing services via sub-paths (e.g., `/grafana/`), the applications initially failed to load assets because they expected to be at the root `/` path.

### Issue: Path Duplication & Missing Assets

* **Symptom:** URL repeating as `/grafana/grafana/` or 404 errors on CSS/JS files.
* **The Solution:** We synchronized Nginx with the application's internal routing.

**1. Nginx Adjustment:**
We removed the trailing slash from the `proxy_pass` directive to pass the full URI to the container.

```nginx
location /grafana/ {
    proxy_pass http://127.0.0.1:3000; # No trailing slash
}

```

**2. Application Adjustment (Environment Variables):**
We injected the following variables into the containers to inform them of their new public URL:

* **Grafana:** `GF_SERVER_ROOT_URL=%(protocol)s://%(domain)s:%(http_port)s/grafana/`
* **Prometheus:** `--web.external-url=/prometheus/`

---

## 4. Phase 4: SSL/TLS Encryption (HTTPS)

To protect administrative credentials from Man-in-the-Middle (MITM) attacks, we implemented encryption using a self-signed certificate.

### Generating the Certificate

```
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

```

### Issue: Permission Denied for SSL Key

* **Error:** Nginx failed to start because it couldn't read the private key.
* **The Solution:** Adjusted ownership to the Nginx group (`www-data`) and set strict permissions.

```
sudo chown root:www-data /etc/ssl/private/nginx-selfsigned.key
sudo chmod 640 /etc/ssl/private/nginx-selfsigned.key

```

---

## 5. Phase 5: Automatic HTTP to HTTPS Redirection

To enforce security, we implemented a global redirect. Any user attempting to connect via insecure Port 80 is automatically upgraded to Port 443.

```nginx
server {
    listen 80;
    server_name YOUR_IP;
    return 301 https://$host$request_uri;
}

```

---

## 6. Final Troubleshooting Summary (Post-Mortem)

| Problem | Root Cause | Resolution |
| --- | --- | --- |
| **UFW Bypass** | Docker `iptables` priority | Bind ports to `127.0.0.1` |
| **502 Bad Gateway** | Service down or wrong IP | Checked `docker ps` & `localhost` IP |
| **Nginx Syntax Error** | Nested `server` blocks | Corrected closing brackets `}` |
| **404 Assets Not Loading** | Base URL mismatch | Set `ROOT_URL` in container environment |
| **SSL Typo** | Misspelled key filename | Fixed `nginx-selfsigned.key` spelling |

---

**Verification Tool:** Used `Wireshark` to audit Port 443. Traffic analysis confirmed that all application data is now encapsulated within TLS packets, rendering it unreadable to unauthorized interceptors.
