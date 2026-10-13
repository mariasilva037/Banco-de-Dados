#!/bin/bash

# ==============================================================================
# SCRIPT DE BACKUP AUTOMATIZADO - POSTGRESQL (08_backup.sh)
# ==============================================================================

# 1. Configuração de Variáveis
DB_NAME="hospital_db"             # Nome da base de dados PostgreSQL
DB_USER="postgres"                # Utilizador da base de dados
BACKUP_DIR="./backups"            # Diretório onde os backups serão guardados
DATA=$(date +%Y%m%d_%H%M%S)       # Data e hora atual para o nome do ficheiro
ARQUIVO_BACKUP="$BACKUP_DIR/backup_${DB_NAME}_${DATA}.dump"
DIAS_RETENCAO=30                  # Tempo de retenção em dias

# Garantir que a pasta de backup existe
mkdir -p "$BACKUP_DIR"

echo "=========================================="
echo "Iniciando o backup de: $DB_NAME"
echo "Data/Hora: $(date)"
echo "=========================================="

# 2. Execução do pg_dump no formato Customizado (-Fc)
pg_dump -U "$DB_USER" -F c -b -v -f "$ARQUIVO_BACKUP" "$DB_NAME"

# 3. Tratamento de Erros
if [ $? -eq 0 ]; then
    echo "------------------------------------------"
    echo "[SUCESSO] Backup concluído com sucesso!"
    echo "Ficheiro gerado em: $ARQUIVO_BACKUP"
    echo "------------------------------------------"
else
    echo "------------------------------------------"
    echo "[ERRO] Falha ao realizar o backup do banco de dados!" >&2
    echo "------------------------------------------"
    exit 1
fi

# 4. Limpeza de Backups Antigos (Retenção de 30 dias)
echo "Limpando backups com mais de $DIAS_RETENCAO dias..."
find "$BACKUP_DIR" -type f -name "backup_${DB_NAME}_*.dump" -mtime +$DIAS_RETENCAO -exec rm -f {} \;

if [ $? -eq 0 ]; then
    echo "[SUCESSO] Processo de retenção/limpeza concluído."
else
    echo "[AVISO] Não foi possível verificar/remover backups antigos."
fi

echo "=========================================="
echo "Processo finalizado!"
echo "=========================================="