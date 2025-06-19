# Express.js with NGINX Reverse Proxy and Docker

This project demonstrates a simple **Express.js** web server containerized using **Docker**, with **NGINX** configured as a **reverse proxy**.

The Express.js server responds with `"Hello, DevOps!"` on the root endpoint (`GET /`), while NGINX forwards incoming HTTP requests on port `80` to the Express server running on port `3000`.

---

## 📁 Project Structure

```
devops_practical_exam/
├── app.js                # Express.js application code
├── package.json          # Node.js dependencies and scripts
├── Dockerfile            # Docker configuration for Express app
├── nginx.conf            # NGINX reverse proxy configuration
├── docker-compose.yml    # Multi-container setup
├── .dockerignore         # Files excluded from Docker build context
```

---

## ⚙️ Prerequisites

* **Docker**

  ```bash
  sudo apt update
  sudo apt install docker.io
  sudo systemctl start docker
  sudo systemctl enable docker
  ```

* *(Optional)* Add user to Docker group:

  ```bash
  sudo usermod -aG docker $USER
  ```

  Then log out and back in.

* **Docker Compose**

  ```bash
  sudo apt install docker-compose
  ```

* **curl** (optional for testing):

  ```bash
  curl --version
  ```

---

## 🛠 Setup Instructions

### 1. Create Project Directory

```bash
mkdir -p ~/Documents/devops_practical_exam
cd ~/Documents/devops_practical_exam
```

### 2. Create Required Files

Use a text editor (e.g., `nano`) to create and save the following files:

#### `app.js`

```js
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Hello, DevOps!');
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
```

#### `package.json`

```json
{
  "name": "express-devops",
  "version": "1.0.0",
  "description": "Simple Express.js server for DevOps demo",
  "main": "app.js",
  "scripts": {
    "start": "node app.js"
  },
  "dependencies": {
    "express": "^4.21.1"
  }
}
```

#### `Dockerfile`

```Dockerfile
FROM node:22

WORKDIR /usr/src/app

COPY package.json ./
RUN npm install

COPY app.js ./

EXPOSE 3000

CMD ["npm", "start"]
```

#### `nginx.conf`

```nginx
events {
  worker_connections 1024;
}

http {
  server {
    listen 80;
    server_name localhost;

    location / {
      proxy_pass http://express-app:3000;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
    }
  }
}
```

#### `docker-compose.yml`

```yaml
version: '3.8'
services:
  express-app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    container_name: express-app

  nginx:
    image: nginx:latest
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    ports:
      - "80:80"
    depends_on:
      - express-app
    container_name: nginx-proxy
```

#### `.dockerignore`

```
node_modules
npm-debug.log
```

### 3. Verify File Permissions

```bash
chmod 644 *.js *.json *.conf *.yml Dockerfile
```

---

## 🚀 Running the Application

### Build and Start Containers

```bash
sudo docker-compose up -d --build
```

### Check Running Containers

```bash
sudo docker ps
```

Expected output:

* `express-app` on port `3000`
* `nginx-proxy` on port `80`

---

## 🧪 Testing the Application

### Test via NGINX (reverse proxy)

```bash
curl http://localhost
```

**Expected:** `Hello, DevOps!`

### Test Direct Express Access

```bash
curl http://localhost:3000
```

### Test from NGINX to Express

```bash
sudo docker exec -it nginx-proxy curl http://express-app:3000
```

---

## 🛒 Troubleshooting

* **Check Logs**:

  ```bash
  sudo docker logs express-app
  sudo docker logs nginx-proxy
  ```

* **Check Port Conflicts**:

  ```bash
  sudo netstat -tuln | grep -E '80|3000'
  ```

* **Firewall**:

  ```bash
  sudo ufw allow 80
  sudo ufw allow 3000
  ```

* **Missing Files**:

  ```bash
  ls -l
  ```

---

## 🛂 Cleanup

Stop and remove containers:

```bash
sudo docker-compose down
```

---

## 📝 Notes

* Express.js listens internally on port **3000**.
* NGINX proxies traffic from port **80** to Express.
* Docker Compose sets up a shared network between services automatically.
* Ideal for DevOps practice in container orchestration and reverse proxy setup.

