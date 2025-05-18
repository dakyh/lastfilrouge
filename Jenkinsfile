pipeline {
    agent any

    environment {
        TF_IN_AUTOMATION = "true"
    }

    stages {
        stage('Cloner le dépôt') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/dakyh/lastfilrouge.git'
            }
        }

        stage('Initialiser Terraform') {
            steps {
                dir('terraform') {
                    bat 'terraform init'
                }
            }
        }

        stage('Plan Terraform') {
            steps {
                dir('terraform') {
                    bat 'terraform plan -out=plan.tfplan'
                }
            }
        }

        stage('Appliquer Terraform') {
            steps {
                dir('terraform') {
                    bat 'terraform apply -auto-approve plan.tfplan'
                }
            }
        }
    }

    post {
        success {
            echo "✅ Déploiement avec Terraform réussi."
        }
        failure {
            echo "❌ Échec du déploiement Terraform. Vérifie les erreurs."
        }
    }
}
