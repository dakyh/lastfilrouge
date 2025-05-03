pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'Sonarqube'   // Nom de ton serveur Sonar dans Jenkins
        SONARQUBE_TOKEN = credentials('sonar-token')  // ID de ton credential
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }
       
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    script {
                        def scannerHome = tool 'SonarScanner' // <- Ici on charge SonarScanner installé dans Jenkins
                        bat """
                            ${scannerHome}/bin/sonar-scanner \
                              -Dsonar.projectKey=jenkins-sonar \
                              -Dsonar.sources=. \
                              -Dsonar.host.url=http://localhost:9000 \
                              -Dsonar.token=$SONARQUBE_TOKEN
                        """
                    }
                }
            }
        }
    }
}


