provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

# Déploiement des fichiers YAML existants avec kubectl
resource "null_resource" "deploy_k8s" {
  provisioner "local-exec" {
    command = <<-EOT
      kubectl apply -f ../k8s/backend-db-pod.yaml
      kubectl apply -f ../k8s/frontend-pod.yaml
    EOT
  }
}

# Output pour accéder aux services
output "minikube_access_commands" {
  value = <<-EOT
    # Pour afficher tous les services:
    minikube service list
    
    # Pour accéder au frontend:
    minikube service frontend-service
    
    # Pour vérifier les pods:
    kubectl get pods
  EOT
}