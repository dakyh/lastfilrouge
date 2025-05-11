pipeline {
    agent any

    tools {
        jdk 'jdk17'
    }

    environment {
        DOCKER_USER = 'dakyh'
        BACKEND_IMAGE = "${DOCKER_USER}/filrouge-backend"
        FRONTEND_IMAGE = "${DOCKER_USER}/filrouge-frontend"
        DB_IMAGE = "${DOCKER_USER}/filrouge-db"

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
                bat "docker build -t %BACKEND_IMAGE%:latest ./Backend/odc"
                bat "docker build -t %FRONTEND_IMAGE%:latest ./Frontend"
                bat "docker build -t %DB_IMAGE%:latest ./DB_filRouge"
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline terminé avec succès. Application buildée et analysée."
        }
        failure {
            echo "❌ Échec du pipeline, voir les logs Jenkins."
        }
    }
}
