pipeline {
    agent any
    
    environment {
        TERRAFORM_DIR = "${WORKSPACE}/terraform"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Terraform Init') {
            steps {
                dir(TERRAFORM_DIR) {
                    bat 'docker run --rm -v %CD%:/workspace -w /workspace --add-host=host.docker.internal:host-gateway hashicorp/terraform:1.6.6 init'
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                dir(TERRAFORM_DIR) {
                    bat 'docker run --rm -v %CD%:/workspace -w /workspace --add-host=host.docker.internal:host-gateway hashicorp/terraform:1.6.6 plan -out=tfplan'
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                dir(TERRAFORM_DIR) {
                    bat 'docker run --rm -v %CD%:/workspace -w /workspace --add-host=host.docker.internal:host-gateway hashicorp/terraform:1.6.6 apply -auto-approve tfplan'
                }
            }
        }
        
        stage('Deployment Info') {
            steps {
                echo "Application déployée avec succès!"
                echo "Frontend: http://localhost:8082"
                echo "Backend: http://localhost:8002"
                echo "PostgreSQL: localhost:5435"
            }
        }
    }
    
    post {
        success {
            echo "Déploiement réussi!"
        }
        failure {
            echo "Échec du déploiement! Vérifiez les logs pour plus d'informations."
        }
    }
}