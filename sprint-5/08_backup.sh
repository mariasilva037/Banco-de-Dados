#!/bin/bash
# ==============================================================================
# 08_backup.sh - Rotina de Backup Logico Automatizado para PostgreSQL
# ==============================================================================

DB_NAME="hospital_db"
DB_USER="postgres"
DB_HOST="localhost"
DB_PORT="5432"
BACKUP_DIR="./backups"
RETENTION_DAYS=30

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${DATE}.dump"

mkdir -p "$BACKUP_DIR"

pg_dump -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -F c -b -v -f "$BACKUP_FILE" "$DB_NAME"

if [ $? -eq 0 ]; then
    echo "Backup realizado com sucesso: $BACKUP_FILE"
    find "$BACKUP_DIR" -type f -name "${DB_NAME}_*.dump" -mtime +$RETENTION_DAYS -exec rm -f {} \;
else
    echo "Erro ao realizar o backup."
    exit 1
fi