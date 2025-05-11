pipeline {
    agent any

    tools {
        jdk 'jdk17' // Assure-toi que JDK 17 est bien configuré dans Jenkins
    }

    environment {
        DOCKER_USER = 'dakyh'
        BACKEND_IMAGE = "${DOCKER_USER}/filrouge-backend"
        FRONTEND_IMAGE = "${DOCKER_USER}/filrouge-frontend"
        DB_IMAGE = "${DOCKER_USER}/filrouge-db"

        SONARQUBE_SERVER = 'SonarQube' // Nom défini dans "Manage Jenkins > Configure System"
        SONARQUBE_TOKEN = credentials('tokenkhady') // Ton token Sonar
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
                bat "docker build -t %BACKEND_IMAGE%:latest ./Backend"
                bat "docker build -t %FRONTEND_IMAGE%:latest ./Frontend"
                bat "docker build -t %DB_IMAGE%:latest ./DB_filRouge"
            }
        }

        stage('Push des images Docker') {
            steps {
                withDockerRegistry([credentialsId: 'newdy', url: '']) {
                    bat "docker push %BACKEND_IMAGE%:latest"
                    bat "docker push %FRONTEND_IMAGE%:latest"
                    bat "docker push %DB_IMAGE%:latest"
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
            echo "✅ Pipeline réussi : analyse + build + déploiement."
        }
        failure {
            echo "❌ Échec du pipeline, voir les logs Jenkins."
        }
    }
}
