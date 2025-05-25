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
                    // Corriger le chemin WSL avec le bon répertoire Jenkins
                    bat '''
                        wsl -d Ubuntu -e bash -c "cd '/mnt/c/ProgramData/Jenkins/.jenkins/workspace/filrougekha' && ansible-playbook deploy.yml"
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
