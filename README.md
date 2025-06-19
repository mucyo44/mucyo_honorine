# Express.js with NGINX Reverse Proxy and Docker

This project demonstrates a simple **Express.js** web server containerized using **Docker**, with **NGINX** configured as a **reverse proxy**.

The Express.js server responds with `"Hello, DevOps!"` on the root endpoint (`GET /`), while NGINX forwards incoming HTTP requests on port `8080` to the Express server running on port `3000`.

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

### 2. Create the Required Files

Use your preferred text editor (e.g., nano, vim, VS Code) to create:

* `app.js`
* `package.json`
* `Dockerfile`
* `nginx.conf`
* `docker-compose.yml`
* `.dockerignore`

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

## 📥 Cloning and Usage

Follow these steps to clone and run this project:

### 1. Clone the Repository

```bash
git clone https://github.com/mucyo44/mucyo_honorine.git
cd mucyo_honorine/devops_practical_exam
```

> Make sure to replace `devops_practical_exam` with the actual folder if it's named differently in your repo.

### 2. Build and Start the Application

```bash
sudo docker-compose up -d --build
```

### 3. Test in Browser or Terminal

* Visit [http://localhost](http://localhost) in your browser.
* Or run:

```bash
curl http://localhost
```

### 4. Stop the Application

```bash
sudo docker-compose down
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
* `nginx-proxy` on port `8080`

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
