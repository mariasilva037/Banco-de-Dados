# 🏋️‍♂️️ Sprint 4 — Relatório Técnico e Documentação da Base de Dados (`academia_db`)

Este documento detalha as decisões técnicas de arquitetura, otimização e segurança adotadas no desenvolvimento da base de dados PostgreSQL para o **Sistema de Gestão de Academia**.

---

## 1. 📐 Justificativa das Escolhas dos Tipos de Dados

A definição do esquema relacional priorizou a integridade referencial, precisão numérica e eficiência de armazenamento:

* **`BIGINT GENERATED ALWAYS AS IDENTITY` (Chaves Primárias):**
  * **Motivo:** Garante chaves numéricas auto-incrementais padronizadas pelo padrão SQL ANSI, com suporte a uma grande escala de registos sem risco de esgotamento de IDs.
* **`VARCHAR(n)` vs `CHAR(n)`:**
  * **`CHAR(11)` para CPF:** O CPF possui sempre uma extensão fixa de 11 dígitos numéricos, evitando *overhead* de variação de tamanho.
  * **`VARCHAR(100)` para Nomes e Emails:** Permite flexibilidade de tamanho com alocação dinâmica de espaço, economizando armazenamento.
* **`NUMERIC(10, 2)` para Valores Monetários (`mensalidade`):**
  * **Motivo:** Evita erros de arredondamento inerentes a tipos de ponto flutuante (`FLOAT` ou `DOUBLE PRECISION`), garantindo precisão exata para transações financeiras.
* **`DATE` e `TIMESTAMP`:**
  * **`DATE`** utilizado para `data_nascimento` e `data_inicio`, pois a precisão de horas/minutos não é necessária.
  * **`TIMESTAMP`** aplicado em registos de auditoria e fichas de treino para precisão temporal de criação.
* **`VARCHAR(20)` com Restrição `CHECK` para Status:**
  * **Motivo:** Garante que o estado da matrícula seja estritamente restrito a valores válidos (`Ativo`, `Inativo`, `Trancado`), impedindo incoerências no sistema.

---

## 2. ⚡ Estratégia de Indexação Adotada

A criação de índices foi focada nos cenários reais de busca e consultas mais frequentes do sistema:

* **Índices de Chave Estrangeira (B-Tree padrão):**
  * Aplicados nas colunas de junção (`aluno_id`, `modalidade_id`), acelerando as operações de `JOIN` entre as tabelas.
* **Índice Parcial (`idx_matricula_ativas`):**
  * **Estrutura:** `CREATE INDEX idx_matricula_ativas ON matricula (aluno_id) WHERE status = 'Ativo';`
  * **Justificativa:** A maior parte das operações diárias da receção consulta apenas alunos ativos. O índice parcial reduz significativamente o tamanho da estrutura em memória e acelera a busca.
* **Índice Composto (`idx_ficha_treino_aluno_data`):**
  * **Estrutura:** `CREATE INDEX idx_ficha_treino_aluno_data ON ficha_treino (aluno_id, data_criacao DESC);`
  * **Justificativa:** Otimiza a consulta das fichas de treino mais recentes de um determinado aluno, evitando ordenações custosas em memória (*Sort/Seq Scan*).

---

## 3. 🔄 Descrição das Transações Criadas

Para garantir a **Atomicidade e Consistência (propriedades ACID)** durante a inserção e atualização de dados operacionais, foram aplicados blocos de transação explícitos:

* **Busca Dinâmica por CPF:**
  * Para evitar a utilização de IDs numéricos fixos (*hardcoded*), as inserções em `matricula` e `ficha_treino` utilizam subconsultas atómicas baseadas no CPF do aluno.
* **Garantia de Atomicidade (`BEGIN ... COMMIT / ROLLBACK`):**
  * **Cenário de Matrícula:** O registo do aluno e a criação da sua matrícula inicial ocorrem dentro do mesmo bloco transacional. Se a criação da matrícula falhar, o registo do aluno sofre *rollback* automático.
* **Pontos de Salvamento (`SAVEPOINT`):**
  * Utilizados para permitir a recuperação parcial em procedimentos complexos (ex: falha ao vincular uma modalidade secundária sem anular a matrícula principal).

---

## 4. 🛡️ Controlo de Acesso Implementado (RBAC)

A segurança da base de dados foi estruturada com base no **Princípio do Menor Privilégio**, isolando os papéis administrativos e operacionais:

* **Gerenciamento de Propriedade (`REASSIGN / DROP OWNED`):**
  * Executado previamente na criação dos scripts para evitar erros de dependência de objetos ao redefinir papéis no PostgreSQL.
* **Papel `role_recepcao` (Atendimento):**
  * **Permissões:** `SELECT`, `INSERT`, `UPDATE` nas tabelas `aluno` e `matricula`.
  * **Restrição:** `REVOKE DELETE` aplicado para impedir que utilizadores da receção eliminem registos do histórico financeiro ou de alunos.
* **Papel `role_instrutor` (Corpo Técnico):**
  * **Permissões:** `SELECT` na tabela `aluno` e permissão total (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) na tabela `ficha_treino`.
  * **Restrição:** Sem acesso a dados financeiros ou de pagamento de modalidades.

---

## 🚀 Como Aplicar no PostgreSQL

1. Conecte-se à base de dados `academia_db`.
2. Execute o ficheiro de script correspondente:
   ```bash
   psql -U postgres -d academia_db -f script_sprint4.sql
