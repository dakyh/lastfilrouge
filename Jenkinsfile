pipeline {
    agent any
    
    environment {
        TERRAFORM_DIR = "${WORKSPACE}/terraform"
        K8S_DIR = "${WORKSPACE}/k8s"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Docker Deployment') {
            steps {
                dir(TERRAFORM_DIR) {
                    bat 'docker run --rm -v %CD%:/workspace -w /workspace --add-host=host.docker.internal:host-gateway hashicorp/terraform:1.6.6 init'
                    bat 'docker run --rm -v %CD%:/workspace -w /workspace --add-host=host.docker.internal:host-gateway hashicorp/terraform:1.6.6 plan -out=tfplan'
                    bat 'docker run --rm -v %CD%:/workspace -w /workspace --add-host=host.docker.internal:host-gateway hashicorp/terraform:1.6.6 apply -auto-approve tfplan'
                }
                echo "Application Docker déployée avec succès!"
                echo "Frontend: http://localhost:8082"
                echo "Backend: http://localhost:8002"
            }
        }
        
        stage('Start Minikube') {
            steps {
                bat 'minikube status || minikube start'
            }
        }
        
        stage('Kubernetes Deployment') {
            steps {
                dir(K8S_DIR) {
                    // Déployer directement avec kubectl en utilisant les fichiers existants
                    bat 'kubectl apply -f backend-db-pod.yaml'
                    bat 'kubectl apply -f frontend-pod.yaml'
                }
            }
        }
        
        stage('Kubernetes Deployment Info') {
            steps {
                bat 'kubectl get pods'
                bat 'kubectl get services'
                bat 'minikube service list'
                echo "Pour accéder au frontend: minikube service frontend-service"
            }
        }
    }
    
    post {
        success {
            echo "Déploiement réussi sur Docker et Kubernetes!"
        }
        failure {
            echo "Échec du déploiement!"
        }
    }
}