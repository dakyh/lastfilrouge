pipeline {
    agent any

    tools {
        jdk 'jdk17' // Nom du JDK défini dans Jenkins > Global Tool Configuration
    }

    environment {
        SONARQUBE_SERVER = 'SonarQube'           // Nom de l'installation SonarQube dans Jenkins
        SONARQUBE_TOKEN = credentials('tokenkhady') // ID du credential (type secret text)
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
                        def scannerHome = tool 'SonarScanner' // Nom exact du scanner défini dans Jenkins
                        bat """
                            ${scannerHome}/bin/sonar-scanner ^
                              -Dsonar.projectKey=jenkins-sonar ^
                              -Dsonar.sources=. ^
                              -Dsonar.host.url=http://localhost:9000 ^
                              -Dsonar.token=${SONARQUBE_TOKEN}
                        """
                    }
                }
            }
        }
    }
}
