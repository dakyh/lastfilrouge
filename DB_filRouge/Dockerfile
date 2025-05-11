# Utiliser l'image officielle PostgreSQL comme base
FROM postgres:15

# Variables d'environnement pour configurer la base de données
ENV POSTGRES_PASSWORD="odc123"
ENV POSTGRES_USER="odc"
ENV POSTGRES_DB="odcdb"

# Exposer le port par défaut de PostgreSQL
EXPOSE 5432

# Le volume pour persister les données
VOLUME ["/var/lib/postgresql/data"]
