# Bludo Deployment Guide (LAN & WAN)

This guide covers the deployment of **Bludo** (formerly bludo) for the **BÜRGERMEISTER HEARING 2026** at the BULME institute. The platform has been configured to support both local LAN access (e.g., via IP address `192.168.x.x`) and public WAN access (e.g., via a port-forwarded DNS like `https://hearing.bulme.at`) simultaneously.

## 1. Prerequisites

- **Docker** and **Docker Compose** installed on the host machine.
- A static LAN IP assigned to the host machine (recommended).
- If accessing from outside the school, port forwarding rules set up on the router/firewall mapping external port 80/443 to internal port 4000 (or via a reverse proxy like Nginx/Traefik).

## 2. Configuration (`.env`)

Before starting the server, ensure your `.env` file is configured correctly.

- **`BASE_URL`**: Set this to your primary public DNS name if users will access it via the internet (e.g., `BASE_URL=https://hearing.bulme.at`). If you are *only* using it on the LAN, you can leave it as `http://localhost:4000` or set it to your LAN IP.
- **`SECRET_KEY_BASE`**: Keep the generated secure string for sessions.
- **Database Credentials**: The default `docker-compose.yml` automatically sets up a PostgreSQL database named `bludo`. You do not need to change `DATABASE_URL` unless you are connecting to an external database.

> **Cross-Origin Configuration (WebSockets)**:
> We have disabled `check_origin` in the production endpoint configuration (`config/runtime.exs`). This allows the Phoenix LiveView WebSockets to connect successfully regardless of whether the user visits via the internal LAN IP or the external DNS name.

## 3. Starting the Server

To build the custom Bludo image and start the application along with its database, run:

```bash
docker compose up -d --build
```

This will:
1. Pull the PostgreSQL 15 image.
2. Build the customized Bludo Elixir/Phoenix image from the local source code.
3. Start the application on port `4000`.

### Health Check

You can verify the containers are running correctly:

```bash
docker compose ps
```
The `app` container will show `(healthy)` once it is ready to accept connections.

## 4. Reverse Proxy Setup (Optional but Recommended)

If you are port-forwarding into a DNS, it is highly recommended to use a reverse proxy (like Nginx, Caddy, or Traefik) to handle SSL/TLS termination and forward traffic to the Bludo app.

**Example Nginx Configuration:**
```nginx
server {
    listen 80;
    server_name hearing.bulme.at;

    location / {
        proxy_pass http://localhost:4000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Important for Phoenix LiveView WebSockets
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

## 5. Maintenance

- **View Logs**: `docker compose logs -f app`
- **Stop Server**: `docker compose down`
- **Reset Database**: `docker compose down -v` (Warning: This deletes all data!)
