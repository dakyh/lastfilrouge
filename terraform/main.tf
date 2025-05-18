terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

provider "docker" {
  host = "tcp://host.docker.internal:2375"
}

# Réseau Docker dédié pour les conteneurs déployés par Terraform
resource "docker_network" "app_network" {
  name = "filrouge-terraform-network"  # Nom distinct
}

# Volume pour les données PostgreSQL
resource "docker_volume" "postgres_data" {
  name = "postgres-terraform-data"  # Nom distinct
}

# Conteneur PostgreSQL
resource "docker_container" "db" {
  name  = "backend-db-terraform"  # Nom distinct
  image = "postgres:15"
  
  networks_advanced {
    name = docker_network.app_network.name
  }
  
  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }
  
  env = [
    "POSTGRES_USER=odc",
    "POSTGRES_PASSWORD=odc123",
    "POSTGRES_DB=odcdb"
  ]
  
  ports {
    internal = 5432
    external = 5435  # Port différent
  }
}

# Conteneur Backend
resource "docker_container" "backend" {
  name  = "backend-terraform"  # Nom distinct
  image = "dakyh/filrouge-backend:latest"
  
  networks_advanced {
    name = docker_network.app_network.name
  }
  
  env = [
    "DB_NAME=odcdb",
    "DB_USER=odc",
    "DB_PASSWORD=odc123",
    "DB_HOST=${docker_container.db.name}",
    "DB_PORT=5432"
  ]
  
  ports {
    internal = 8000
    external = 8002  # Port différent
  }
  
  depends_on = [docker_container.db]
}

# Conteneur Frontend
resource "docker_container" "frontend" {
  name  = "frontend-terraform"  # Nom distinct
  image = "dakyh/filrouge-frontend:latest"
  
  networks_advanced {
    name = docker_network.app_network.name
  }
  
  env = [
    "VITE_API_URL=http://${docker_container.backend.name}:8000"
  ]
  
  ports {
    internal = 80
    external = 8082  # Port différent
  }
  
  depends_on = [docker_container.backend]
}

# Outputs pour afficher les URLs d'accès
output "frontend_url" {
  value = "http://localhost:8082"
}

output "backend_url" {
  value = "http://localhost:8002"
}

output "database_connection" {
  value = "jdbc:postgresql://localhost:5435/odcdb"
}