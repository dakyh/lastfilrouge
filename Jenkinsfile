pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Deploy with PowerShell') {
            steps {
                powershell '.\\deploy-ansible.ps1'
            }
        }
        
        stage('Deployment Info') {
            steps {
                echo "Application déployée avec succès!"
                echo "Frontend: http://localhost:8083"
                echo "Backend: http://localhost:8003"
                echo "Database: jdbc:postgresql://localhost:5436/odcdb"
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