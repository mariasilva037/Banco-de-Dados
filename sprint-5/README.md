# 🏥 Sistema de Gestão Hospitalar — Banco de Dados Relacional (PostgreSQL)

Este repositório contém o script SQL completo para a criação, povoamento, otimização e controle de acesso de um banco de dados relacional para um **Sistema de Gestão Hospitalar**, desenvolvido em **PostgreSQL**.

---

## 📌 1. Descrição do Domínio

O sistema foi modelado para gerenciar as operações fundamentais de um centro médico / hospitalar. O domínio abrange os seguintes processos centrais:

* **Corpo Clínico e Estrutura:** Organização do hospital em departamentos (ex: Cardiologia, UTI) e cadastro de médicos vinculados às suas respectivas especialidades e setores.
* **Atendimento ao Paciente:** Cadastro de pacientes, agendamento/realização de consultas médicas e registro de diagnósticos (indexados por código CID-10).
* **Internações e Infraestrutura:** Gestão de leitos/quartos e controle de internações de pacientes com rastreamento de datas de entrada, saída e motivo.
* **Prescrição e Farmácia:** Cadastro de medicamentos, controle de estoque e emissão de prescrições associadas aos atendimentos.
* **Módulo Financeiro e Convênios:** Gestão de planos de saúde/convênios e faturamento unificado para atendimentos (consultas ou internações).

---

## 📐 2. Modelo Lógico

O banco de dados é composto por **11 tabelas encadeadas por chaves estrangeiras e restrições de integridade**:

1. **`departamentos`**: Setores do hospital (`departamento_id`, `nome`, `sigla`, `andar`).
2. **`medicos`**: Corpo médico (`medico_id`, `crm`, `nome`, `especialidade`, `departamento_id`, `status`).
3. **`pacientes`**: Cadastro de usuários (`paciente_id`, `cpf`, `nome`, `data_nascimento`, `sexo`, `telefone`, `email`, `data_cadastro`).
4. **`convenios`**: Planos de saúde parceiros (`convenio_id`, `cnpj`, `nome_fantasia`, `tipo_plano`).
5. **`quartos`**: Leitos e alas (`quarto_id`, `numero`, `tipo`, `capacidade`).
6. **`internacoes`**: Registro de leitos ocupados (`internacao_id`, `paciente_id`, `quarto_id`, `data_entrada`, `data_saida`, `motivo`).
7. **`consultas`**: Atendimentos ambulatoriais (`consulta_id`, `paciente_id`, `medico_id`, `convenio_id`, `data_hora`, `valor`, `status`).
8. **`diagnosticos`**: Registro clínico e CID (`diagnostico_id`, `consulta_id`, `codigo_cid`, `descricao`, `data_diagnostico`).
9. **`medicamentos`**: Estoque da farmácia (`medicamento_id`, `nome_comercial`, `principio_ativo`, `estoque_atual`, `preco_unitario`).
10. **`prescricoes`**: Itens receitados (`prescricao_id`, `consulta_id`, `medicamento_id`, `dosagem`, `frequencia`, `quantidade`).
11. **`faturamentos`**: Cobranças de procedimentos (`faturamento_id`, `consulta_id`, `internacao_id`, `valor_total`, `status_pagamento`, `data_emissao`).

---

## ⚖️️ 3. Justificativa das Escolhas de Design

* **Normalização (3FN):** O esquema foi projetado até a Terceira Forma Normal para evitar redundância de dados e anomalias de atualização/inserção.
* **Integridade Referencial e Constraints Exclusivas (`CHECK` e `UNIQUE`):**
  * `chk_origem` em `faturamentos`: Garante que um registro de faturamento pertença a **uma Consulta OR a uma Internação**, jamais a ambos ou a nenhum.
  * `chk_datas` em `internacoes`: Impede inconsistências temporais onde a data de alta é anterior à data de entrada.
  * Tipagem estrita de status (`CHECK (status IN (...))`) para garantir padronização dos estados do sistema.
* **Otimização por Índices:**
  * Índices B-Tree criados em colunas com alta cardinalidade e frequência de busca em cláusulas `WHERE` e `JOIN`, como `consultas(data_hora)`, `pacientes(cpf)` e `medicamentos(principio_ativo)`.
  * Índice composto em `consultas(medico_id, status)` para otimizar relatórios de produtividade médica.
* **Segurança e DCL (Data Control Language):**
  * Implementação do **Princípio do Menor Privilégio** (`medico_user` e `recepcao_user`), com revogação explícita da permissão `DELETE` em todas as tabelas para usuários operacionais, prevenindo exclusão acidental ou maliciosa de registros de prontuário e caixa.

---

## 🔍 4. Lista de Consultas SQL (DML)

O script inclui 10 consultas com complexidade progressiva para suporte à tomada de decisão:

1. **Visão Geral de Consultas (INNER / LEFT JOIN):** Listagem de consultas com nome do paciente, médico e convênio.
2. **Faturamento por Médico (GROUP BY + HAVING):** Médicos com receita gerada superior a R$ 300,00.
3. **Pacientes Recorrentes (Subconsulta com IN):** Filtro de pacientes que realizaram consultas.
4. **Ocupação por Tipo de Quarto (LEFT JOIN + GROUP BY):** Total de internações agregadas por modalidade de quarto (UTI, Enfermaria, Apartamento).
5. **Histórico de Medicamentos Receitados (Multi-Join):** Relatório de medicamentos e dosagens prescritas por paciente.
6. **Prevalência de Diagnósticos (Agrupamento + ORDER BY):** Diagnósticos mais frequentes ordenados por código CID.
7. **Pacientes em Estado Crítico (Filtro por JOIN):** Lista de pacientes atualmente em leitos de UTI.
8. **Controle de Inadimplência (JOIN + WHERE):** Faturamentos com status 'Pendente'.
9. **Médicos Sem Internações Vinculadas (Subconsulta com NOT IN):** Médicos que atenderam apenas consultas ambulatoriais sem gerar internações.
10. **Ticket Médio por Departamento (Agregação + ROUND):** Média do valor das consultas agrupada por setor hospitalar.

---

## 🔄 5. Explicação das Transações ACID

A integridade transacional foi garantida através de blocos `BEGIN ... COMMIT / ROLLBACK`:

1. **Transação 1 — Inserção Encadeada Garantida (Atomicidade + Consistência via CTE / RETURNING):**
   * Ao agendar uma nova consulta, a cobrança pendente correspondente deve ser gerada no mesmo ciclo de instrução.
   * Utilizou-se uma *Common Table Expression* (CTE) com `RETURNING consulta_id` para capturar a chave primária recém-gerada e inseri-la atomicamente na tabela `faturamentos`. Se qualquer uma das partes falhar, ambas são revertidas.
2. **Transação 2 — Simulação de Rollback (Isolamento + Durabilidade):**
   * Demonstra a reversão manual de uma operação de baixa de estoque (`UPDATE medicamentos`) utilizando `ROLLBACK` para simular uma falha na validação de regras de negócio antes da gravação definitiva.

---

## ⏱️ 6. Análise do Plano de Execução (EXPLAIN ANALYZE)

A instrução `EXPLAIN ANALYZE` foi aplicada à consulta temporal sobre a tabela de atendimentos:

```sql
EXPLAIN ANALYZE
SELECT c.consulta_id, p.nome, c.data_hora
FROM consultas c
JOIN pacientes p ON c.paciente_id = p.paciente_id
WHERE c.data_hora BETWEEN '2026-01-01' AND '2026-02-01';