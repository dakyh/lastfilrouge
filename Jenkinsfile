pipeline {
    agent any

    environment {
        DOCKER_USER = 'dakyh'
        BACKEND_IMAGE = "${DOCKER_USER}/filrouge-backend"
        FRONTEND_IMAGE = "${DOCKER_USER}/filrouge-frontend"
        DB_IMAGE = "${DOCKER_USER}/filrouge-db"
    }
    
    stages {
        stage('Cloner le dépôt') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/dakyh/lastfilrouge.git'
            }
        }
        
        stage('Build des images Docker') {
            steps {
                bat "docker build -t %BACKEND_IMAGE%:latest ./Backend/odc"
                bat "docker build -t %FRONTEND_IMAGE%:latest ./Frontend"
                bat "docker build -t %DB_IMAGE%:latest ./DB_filRouge"
            }
        }
    }
    
    post {
        success {
            echo "✅ Build terminé avec succès."
        }
        failure {
            echo "❌ Le build a échoué. Vérifiez les logs."
        }
    }
}
