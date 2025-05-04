pipeline {
    agent any

    tools {
        jdk 'jdk17'
    }

    environment {
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

        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('SonarQube Analysis') {
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
    }
}
