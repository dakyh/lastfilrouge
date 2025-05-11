pipeline {
    agent any

    tools {
        jdk 'jdk17'
    }

    environment {
        DOCKER_USER = 'dakyh'
        BACKEND_IMAGE = "${DOCKER_USER}/filrouge-backend"
        FRONTEND_IMAGE = "${DOCKER_USER}/filrouge-frontend"
        MIGRATE_IMAGE = "${DOCKER_USER}/filrouge-migrate"

        SONARQUBE_SERVER = 'SonarQube'
        SONARQUBE_TOKEN = credentials('tokenkhady')
    }

    stages {
        stage('Vérifier JAVA') {
            steps {
                bat 'echo JAVA_HOME=%JAVA_HOME%'
                bat 'java -version'
            }
        }

        stage('Cloner le dépôt') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/dakyh/lastfilrouge.git'
            }
        }

        stage('Analyse SonarQube') {
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    script {
                        def scannerHome = tool 'SonarScanner'
                        bat """
                            ${scannerHome}/bin/sonar-scanner ^
                              -Dsonar.projectKey=filbykhadylast ^
                              -Dsonar.sources=. ^
                              -Dsonar.host.url=http://localhost:9000 ^
                              -Dsonar.token=${SONARQUBE_TOKEN}
                        """
                    }
                }
            }
        }

        stage('Build des images Docker') {
            steps {
                bat "docker build -t %BACKEND_IMAGE%:latest Backend/odc"
                bat "docker build -t %FRONTEND_IMAGE%:latest Frontend"
                bat "docker build -t %MIGRATE_IMAGE%:latest Backend/odc"
            }
        }

        stage('Push des images Docker') {
            steps {
                withDockerRegistry([credentialsId: 'newdy', url: '']) {
                    bat "docker push %BACKEND_IMAGE%:latest"
                    bat "docker push %FRONTEND_IMAGE%:latest"
                    bat "docker push %MIGRATE_IMAGE%:latest"
                }
            }
        }

        stage('Déploiement local') {
            steps {
                bat '''
                    docker-compose down || true
                    docker-compose pull
                    docker-compose up -d --build
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline terminé avec succès. Application déployée et analysée."
        }
        failure {
            echo "❌ Échec du pipeline, voir les logs Jenkins."
        }
    }
}
