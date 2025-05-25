pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Deploy with Ansible') {
            steps {
                script {
                    // Utiliser WSL pour exécuter Ansible
                    bat '''
                        wsl -d Ubuntu -e bash -c "cd /mnt/c/jenkins/workspace/%JOB_NAME% && ansible-playbook deploy.yml"
                    '''
                }
            }
        }
        
        stage('Deployment Info') {
            steps {
                echo "✅ Application déployée avec Ansible!"
                echo "🌐 Frontend: http://localhost:8083"
                echo "⚙️  Backend: http://localhost:8003"
                echo "🗄️  Database: jdbc:postgresql://localhost:5436/odcdb"
            }
        }
    }
    
    post {
        success {
            echo "🎉 Déploiement Ansible réussi!"
        }
        failure {
            echo "❌ Échec du déploiement Ansible! Vérifiez les logs."
        }
    }
}