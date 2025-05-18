pipeline {
    agent any

    environment {
        TF_IN_AUTOMATION = "true"
    }

    stages {
        stage('Cloner le dépôt') {
            steps {
                git url: 'https://github.com/dakyh/lastfilrouge.git', branch: 'main'
            }
        }

        stage('Initialiser Terraform') {
            steps {
                dir('terraform') {
                    script {
                        docker.image('hashicorp/terraform:1.6.6').inside {
                            sh 'terraform init'
                        }
                    }
                }
            }
        }

        stage('Plan Terraform') {
            steps {
                dir('terraform') {
                    script {
                        docker.image('hashicorp/terraform:1.6.6').inside {
                            sh 'terraform plan'
                        }
                    }
                }
            }
        }

        stage('Appliquer Terraform') {
            steps {
                dir('terraform') {
                    script {
                        docker.image('hashicorp/terraform:1.6.6').inside {
                            sh 'terraform apply -auto-approve'
                        }
                    }
                }
            }
        }
    }

    post {
        failure {
            echo '❌ Le pipeline Terraform a échoué.'
        }
        success {
            echo '✅ Terraform exécuté avec succès.'
        }
    }
}
