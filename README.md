# Cioran

Cioran is an open-source platform for transparent quantitative finance research.

## Current State

The repository is currently in its nascent stage. The fundamental directory structure and the inter-service communication protocols have been established and verified. HTTPS support has been integrated.

## Architecture

The project utilizes Docker Compose to ensure a consistent environment and seamless portability across different development and production systems.

The system is designed with a microservices architecture to ensure modularity and performance:

* **Backend (Go):** Central API layer that orchestrates requests and manages system state.
* **Engine (Python):** Dedicated service for heavy data processing and quantitative modeling.
* **Frontend (Next.js):** UI for data visualization and user interaction.
* **Nginx:** Reverse proxy providing unified routing and SSL termination.

## Prerequisites

* **Docker & Docker Compose**
* **Git**
* **Node.js & npm** (for local frontend development)
* **Go 1.21+** (for local backend development)
* **Python 3.11** (for local engine development)

## Getting Started

Follow these steps to initialize the environment and run the services.

### Core Setup

1. **Clone the repository:**

```bash
git clone git@github.com:chemerysov/cioran.git
cd cioran
```

2. **Build and start the containers:**

```bash
docker compose up --build
```

### Local Development Environment

While the application runs entirely within Docker for production and testing, installing dependencies on your host machine is necessary for a smooth development experience. This allows your Integrated Development Environment (IDE) to provide accurate syntax highlighting, linting, and type-checking, which cannot be easily achieved if the libraries reside solely within the Docker containers.

#### 1. Frontend Setup

Navigate to the frontend directory and install the Node modules:

```bash
cd frontend
npm install
cd ..
```

#### 2. Engine Setup (Python)

Create a virtual environment to isolate the engine's dependencies:

```bash
cd engine
python3 -m venv venv

# macOS/Linux:
source venv/bin/activate
# Windows:
.\venv\Scripts\activate

pip install -r requirements.txt
cd ..
```

#### 3. Backend Setup (Go)

Download and organize the Go modules:

```bash
cd backend
go mod download
go mod tidy
cd ..
```

## Accessing the Application

Once the containers are running, the application is accessible via the Nginx reverse proxy. You do not need to specify individual service ports:

* **Web Interface:** `http://localhost`

## Production Environment

In production, Cioran utilizes a multi-file Docker Compose strategy to enforce HTTPS and handle automated SSL certificate renewals via Let's Encrypt. The system is designed to be self-healing and requires no host-level configuration (like Crontab). Renewal logic is entirely containerized, Certbot Service attempts a renewal every 12 hours, Nginx Service automatically performs a graceful reload every 6 hours to check for updated certificate files on the shared volume.

### 1. SSL Initialization

For new server deployments, use the provided orchestration script to prove domain ownership and generate initial certificates. This script handles the "chicken-and-egg" problem of starting Nginx before certificates physically exist.

```bash
chmod +x nginx/init-https.sh
./nginx/init-https.sh
```

### 2. Deployment

To deploy or update the production stack, always include both the base and production override files. This ensures Nginx uses the hardened `prod.conf` and starts the Certbot renewal service.

```bash
# Start the production stack
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build

# Monitor production logs
docker compose -f docker-compose.yml -f docker-compose.prod.yml logs -f
```