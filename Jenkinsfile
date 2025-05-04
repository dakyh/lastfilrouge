pipeline {
    agent any

    tools {
        jdk 'jdk17'
    }

    environment {
        // SonarQube
        SONARQUBE_SERVER = 'SonarQube'
        SONARQUBE_TOKEN = credentials('tokenkhady')

        // Docker
        DOCKER_USER = 'dakyh'
        BACKEND_IMAGE = "${DOCKER_USER}/filrouge-backend"
        FRONTEND_IMAGE = "${DOCKER_USER}/filrouge-frontend"
        DB_IMAGE = "${DOCKER_USER}/filrouge-db"
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
                    url: 'https://github.com/dakyh/FilRouge.git'
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
                              -Dsonar.exclusions=venv/**/*,**\\\\venv\\\\** ^
                              -Dsonar.host.url=http://localhost:9000 ^
                              -Dsonar.token=${SONARQUBE_TOKEN}
                        """
                    }
                }
            }
        }

        stage('Vérification de la qualité') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build des images Docker') {
            steps {
                bat 'docker build -t %BACKEND_IMAGE%:latest Backend'
                bat 'docker build -t %FRONTEND_IMAGE%:latest Frontend'
                bat 'docker build -t %DB_IMAGE%:latest DB_filRouge'
            }
        }

        stage('Push vers DockerHub') {
            steps {
                withDockerRegistry([credentialsId: 'dydy', url: '']) {
                    bat 'docker push %BACKEND_IMAGE%:latest'
                    bat 'docker push %FRONTEND_IMAGE%:latest'
                    bat 'docker push %DB_IMAGE%:latest'
                }
            }
        }

        stage('Déploiement local avec Docker Compose') {
            steps {
                bat '''
                    docker-compose down || exit 0
                    docker-compose pull
                    docker-compose up -d
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Déploiement réussi"
        }
        failure {
            echo "❌ Le pipeline a échoué"
        }
        always {
            bat 'docker logout'
        }
    }
}
