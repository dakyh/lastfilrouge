# Variables
$networkName = "filrouge-ansible-network"
$volumeName = "postgres-ansible-data"
$dbName = "backend-db-ansible"
$backendName = "backend-ansible"
$frontendName = "frontend-ansible"
$dbUser = "odc"
$dbPassword = "odc123"
$dbDatabase = "odcdb"
$dbPort = 5436
$backendPort = 8003
$frontendPort = 8083

# Nettoyer les anciens conteneurs (optionnel)
Write-Host "Nettoyage des anciens conteneurs..."
docker rm -f $frontendName $backendName $dbName -ErrorAction SilentlyContinue
if ($LASTEXITCODE -ne 0) { 
    Write-Host "Aucun conteneur à nettoyer ou certains conteneurs sont toujours en cours d'utilisation" 
}

# Créer le réseau Docker
Write-Host "Création du réseau Docker..."
docker network create $networkName -ErrorAction SilentlyContinue
if ($LASTEXITCODE -ne 0) { 
    Write-Host "Le réseau existe déjà" 
}

# Créer le volume Docker
Write-Host "Création du volume Docker..."
docker volume create $volumeName -ErrorAction SilentlyContinue
if ($LASTEXITCODE -ne 0) { 
    Write-Host "Le volume existe déjà" 
} else {
    Write-Host "Volume créé : $volumeName"
}

# Déployer la base de données
Write-Host "Déploiement de la base de données PostgreSQL..."
docker run -d --name $dbName `
  --network $networkName `
  -e POSTGRES_USER=$dbUser `
  -e POSTGRES_PASSWORD=$dbPassword `
  -e POSTGRES_DB=$dbDatabase `
  -p "$($dbPort):5432" `
  -v "$($volumeName):/var/lib/postgresql/data" `
  postgres:15
if ($LASTEXITCODE -ne 0) { 
    Write-Host "La base de données existe déjà ou erreur lors du déploiement" 
} else {
    Write-Host "Base de données déployée avec succès"
}

# Attendre que la base de données soit prête
Write-Host "Attente de l'initialisation de la base de données..."
Start-Sleep -Seconds 10

# Déployer le backend
Write-Host "Déploiement du backend..."
docker run -d --name $backendName `
  --network $networkName `
  -e DB_NAME=$dbDatabase `
  -e DB_USER=$dbUser `
  -e DB_PASSWORD=$dbPassword `
  -e DB_HOST=$dbName `
  -e DB_PORT=5432 `
  -p "$($backendPort):8000" `
  dakyh/filrouge-backend:latest
if ($LASTEXITCODE -ne 0) { 
    Write-Host "Le backend existe déjà ou erreur lors du déploiement" 
} else {
    Write-Host "Backend déployé avec succès"
}

# Déployer le frontend
Write-Host "Déploiement du frontend..."
docker run -d