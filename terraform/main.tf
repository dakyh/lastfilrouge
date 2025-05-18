provider "kubernetes" {
  config_path = "C:/Users/lenovo/.kube/config"
}

resource "kubernetes_pod" "backend_db_pod" {
  metadata {
    name = "backend-db-pod"
    labels = {
      app = "backend-db"
    }
  }
  spec {
    container {
      name  = "db"
      image = "postgres:15"
      env {
        name  = "POSTGRES_USER"
        value = "odc"
      }
      env {
        name  = "POSTGRES_PASSWORD"
        value = "odc123"
      }
      env {
        name  = "POSTGRES_DB"
        value = "odcdb"
      }
      ports {
        container_port = 5432
      }
      volume_mount {
        name       = "postgres-storage"
        mount_path = "/var/lib/postgresql/data"
      }
    }
    container {
      name  = "backend"
      image = "dakyh/filrouge-backend:latest"
      env {
        name  = "DB_NAME"
        value = "odcdb"
      }
      env {
        name  = "DB_USER"
        value = "odc"
      }
      env {
        name  = "DB_PASSWORD"
        value = "odc123"
      }
      env {
        name  = "DB_HOST"
        value = "localhost"
      }
      env {
        name  = "DB_PORT"
        value = "5432"
      }
      ports {
        container_port = 8000
      }
    }
    volume {
      name = "postgres-storage"
      empty_dir {}
    }
  }
}

resource "kubernetes_service" "backend_service" {
  metadata {
    name = "backend-service"
  }
  spec {
    selector = {
      app = "backend-db"
    }
    port {
      port        = 8000
      target_port = 8000
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_pod" "frontend_pod" {
  metadata {
    name = "frontend-pod"
    labels = {
      app = "frontend"
    }
  }
  spec {
    container {
      name  = "frontend"
      image = "dakyh/filrouge-frontend:latest"
      ports {
        container_port = 80
      }
      env {
        name  = "VITE_API_URL"
        value = "http://backend-service:8000"
      }
    }
  }
}

resource "kubernetes_service" "frontend_service" {
  metadata {
    name = "frontend-service"
  }
  spec {
    selector = {
      app = "frontend"
    }
    port {
      port        = 8081
      target_port = 80
    }
    type = "LoadBalancer"
  }
}
