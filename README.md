# Cioran

Cioran is an open-source platform for transparent quantitative financial research.

The project is designed with a microservices architecture to ensure modularity and performance.

## Architecture

- **Backend (Go):** API layer orchestrating requests.
- **Engine (Python):** Data processing and quantitative modeling engine.
- **Frontend (Next.js):** Modern, reactive dashboard for data visualization.
- **Nginx:** Reverse proxy for unified routing.

## Prerequisites

- Docker and Docker Compose
- Git

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone git@github.com:chemerysov/cioran.git
   cd cioran