# 🏥 Sistema de Gerenciamento Hospitalar - Banco de Dados PostgreSQL & MongoDB

Este repositório contém o projeto de banco de dados do *Sistema de Gerenciamento Hospitalar*, cobrindo tanto a modelagem relacional na **3ª Forma Normal (3NF)** em *PostgreSQL*, quanto a expansão NoSQL voltada a documentos com **MongoDB**, além de estratégias avançadas de segurança, otimização e **rotinas de backup e restauração**.

---

## 📑 Sumário

1. [Descrição do Domínio]
2. [Modelo Lógico Relacional (PostgreSQL)]
3. [Estratégia de Backup e Restauração (Regra 3-2-1)]
4. [Validação e Teste de Restauração]
5. [Modelagem NoSQL (MongoDB)]
6. [Análise de Performance MongoDB (Indexes & Explain)]
7. [Comparação Técnica: PostgreSQL vs. MongoDB]
8. [Instruções de Execução do Repositório]

---

## 📄 1. Descrição do Domínio

O sistema gerencia de forma integrada os processos operacionais, clínicos e financeiros de uma instituição hospitalar:

* **Operacional e Corpo Clínico:** Departamentos, médicos (CRM) e pacientes.
* **Atendimento e Prontuário:** Agendamento de consultas, emissão de diagnósticos (CID-10) e prescrição de medicamentos.
* **Internações e Leitos:** Alocação de quartos e controle de períodos de internação.
* **Faturamento:** Emissão de cobranças para consultas e internações.

---

## 🧬 2. Modelo Lógico Relacional (PostgreSQL)

O banco relacional é composto por *11 tabelas de domínio em 3NF*:
`departamentos`, `medicos`, `pacientes`, `convenios`, `quartos`, `internacoes`, `consultas`, `diagnosticos`, `medicamentos`, `prescricoes` e `faturamentos`.

---

## 💾 3. Estratégia de Backup e Restauração (Regra 3-2-1)

A continuidade dos negócios e a integridade do hospital são asseguradas por uma rotina automatizada de backup combinada com a *Regra 3-2-1*:

1. **3 Cópias dos Dados:** O banco em produção no PostgreSQL + backup local no servidor + cópia em armazenamento secundário em nuvem (S3/GCS).
2. **2 Meios Diferentes:** Disco local NVMe do servidor e Object Storage externo.
3. **1 Cópia Offsite:** Armazenada em região geográfica distinta da infraestrutura do hospital.

### Detalhes do Script de Backup (`08_backup.sh`):

* **Formato:** Customizado (`-Fc`), que habilita compressão interna, suporte a restauração paralela e flexibilidade com `pg_restore`.
* **Automatização:** Executado via cron diariamente às 02:00 (`0 2 * * * /caminho/08_backup.sh`).
* **Retenção:** Política automatizada via `find` que expurga arquivos de backup com mais de **30 dias**.

---

## 🧪 4. Validação e Teste de Restauração

Conforme as boas práticas de SRE, um backup só é válido se for testado. O procedimento abaixo valida a restauração completa em um banco de testes isolado:

```bash
# 1. Criar Banco de Dados de Teste
createdb -h localhost -U postgres hospital_db_test

# 2. Restaurar o arquivo de backup (.dump)
pg_restore -h localhost -U postgres -d hospital_db_test -v ./backups/backup_hospital_db_20261013.dump

# 3. Validação de Integridade (Contagem de Registros)
psql -h localhost -U postgres -d hospital_db_test -c "SELECT COUNT(*) FROM pacientes;"

```

---

## 🍃 5. Modelagem NoSQL (MongoDB)

O MongoDB foi integrado ao projeto para suportar dados de prontuários dinâmicos e prescrições variáveis (`09_mongodb_hospital.js`).

### Coleções do Domínio

* **`pacientes`:** Armazena os dados cadastrais do paciente e o histórico de consultas/prontuários embutidos (**Embedding**).
* **`medicos`:** Armazena o corpo clínico, especialidades e CRM, referenciados através do `_id` (**Referencing**).

### Justificativas de Modelagem

* **Embedding (Dados Embutidos):** Aplicado no histórico clínico dentro do paciente. Justifica-se pois o prontuário é sempre lido junto com o cadastro do paciente nas consultas, reduzindo operações de leitura no banco.
* **Referencing (Referências por `_id`):** Aplicado à relação entre consultas e médicos. Justifica-se para evitar duplicidade maciça dos dados dos médicos e facilitar atualizações cadastrais centralizadas.

---

## ⚡ 6. Análise de Performance MongoDB (Indexes & Explain)

Para garantir alta performance nas consultas do sistema NoSQL, foram criados índices estratégicos analisados via `.explain()`:

1. **Índice Simples:** Criado no campo `cpf` da coleção `pacientes` (`db.pacientes.createIndex({ cpf: 1 })`) para busca rápida de cadastro.
2. **Índice Composto:** Criado na coleção `pacientes` nos campos `{ "consultas.data": -1, "consultas.status": 1 }` para otimizar a ordenação e filtragem das consultas recentes.

---

## ⚖️ 7. Comparação Técnica: PostgreSQL vs. MongoDB

| Critério | PostgreSQL (Relacional) | MongoDB (NoSQL Documentos) |
| --- | --- | --- |
| **Garantia ACID** | Completa e nativa. Ideal para faturamento, pagamentos e integridade referencial rigorosa. | Suportada em nível de documento/coleções. Focado em consistência eventual e escalabilidade horizontal. |
| **Estrutura de Schema** | Rígida (3NF). Evita anomalias de inserção/atualização. | Flexível (BSON/JSON). Permite inclusão de novos campos dinâmicos no prontuário sem alteração de schema. |
| **Cenário de Destaque** | Controle de leitos, faturamento financeiro e relacionamento N:M complexo. | Prontuário Eletrônico do Paciente (PEP), logs de auditoria e históricos de exames variáveis. |

---

## 🚀 8. Instruções de Execução do Repositório

### Executando o Script de Backup (PostgreSQL):

```bash
chmod +x 08_backup.sh
./08_backup.sh

```

### Executando a Carga e Testes no MongoDB:

```powershell
.\mongosh.exe 09_mongodb_hospital.js

```