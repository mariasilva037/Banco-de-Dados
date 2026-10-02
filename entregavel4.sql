-- SPRINT 4: MODELAGEM FÍSICA, OTIMIZAÇÃO E SEGURANÇA NO POSTGRESQL
--DOMÍNIO: SISTEMA DE ACADEMIA

--1. DDL: ESTRUTURA E RESTRIÇÕES

drop table if exists ficha_treino cascade;
drop table if exists matricula cascade;
drop table if exists modalidade cascade;
drop table if exists aluno cascade;

-- Tabela 1: Aluno
create table aluno (
   id_aluno BIGINT generated always as IDENTITY primary key,
   nome VARCHAR(100) not null,
   cpf VARCHAR(14) not null unique,
   data_nascimento DATE not  null,
   telefone VARCHAR(20),
   email VARCHAR(100) unique,
   criado_em TIMESTAMPTZ not null default CURRENT_TIMESTAMP
   );
--- Tabela: Modalidade
create table modalidade (
   id_modalidade BIGINT generated always as identity primary key,
   nome_modalidade VARCHAR (50) not null,
   descricao TEXT,
   valor_mensal NUMERIC(10,2) not null check (valor_mensal > 0)
);

--Tabela 3: Matrícula (Tabela Associaativa N:N)
create table matricula (
   id_matricula BIGINT generated always as identity primary key,
   id_aluno BIGINT not null,
   id_modalidade BIGINT not null,
   data_matricula DATE not null default CURRENT_DATE,
   status VARCHAR(20) not null default'Ativo'
      check (status in ('Ativo', 'Inativo' , 'Trancado')),
   constraint fk_matricula_aluno FOREIGN key (id_aluno)
      references aluno(id_aluno) on delete cascade,
   constraint fk_matricula_modalidade foreign key (id_modalidade)
      references modalidade(id_modalidade) on delete cascade
   );

--Tabela 4: FichaTreino
create table ficha_treino (
   id_treino BIGINT generated always as identity primary key,
   id_aluno BIGINT not null,
   id_modalidade BIGINT not null,
   objetivo VARCHAR(100) not null,
   data_criacao DATE not null default CURRENT_DATE,
   descricao_exercicios TEXT not null,
   constraint fk_ficha_aluno foreign key (id_aluno)
      references aluno(id_aluno) on delete cascade,
   constraint fk_ficha_modalidade foreign key (id_modalidade)
      references modalidade(id_modalidade) on delete CASCADE
   );

--DADOS INICIAIS (BASE SPRINT 3) PARA SUPORTAR AS TRANSAÇÕES
insert into aluno (nome, cpf, data_nascimento, telefone, email) values 
('Carlos Eduardo', '113.222.333-44', '1995-03-10', '(98) 98111-2233', 'carlos@email.com'),
('Mariana Souza', '222.333.444-55', '2000-07-22', '(98) 98222-3344', 'mariana@email.com'),
('Lucas Silva', '333.444.555-66', '1988-11-05', '(98) 98333-4455', 'lucas@email.com');

insert into modalidade (nome_modalidade, descricao, valor_mensal) values 
('Musculação', 'Acesso completo à área de pesos e máquinas.', 120.00),
('Pilates', 'Aulas guiadas com foco em postura e flexibilidade.', 180.00),
('Crossfit', 'Treinamento funcional de alta intensidade.' , 200.00);

insert into matricula (id_aluno, id_modalidade, data_matricula, status) values 
(1, 1, '2026-01-10', 'Ativo'),
(1, 2, '2026-02-01', 'Ativo'),
(2, 1, '2026-01-15', 'Ativo'),
(3, 3, '2026-03-01', 'Ativo');

insert into ficha_treino (id_aluno, id_modalidade, objetivo, data_criacao, descricao_exercicios) values 
(1, 1, 'Hipertrofia Muscular', '2026-01-11', '4x10 Supino Reto, 4x12 Agachamento, 3x15 Leg Press'),
(2, 1, 'Perda de Peso e Definição', '2026-01-16', '3x15 Passada, 4x20 Abdominal, 30 Escada'),
(3, 3, 'Condicionamento Físico', '2026-03-02', '5 Rounds: 10 Burpees, 15 Kettbell Swings, 200m Corrida');

-- 2. INDEXAÇÃO (ESTRATÉGIA DE PERFORMANCE)

CREATE INDEX IF NOT EXISTS idx_matricula_id_aluno ON matricula(id_aluno);
CREATE INDEX IF NOT EXISTS idx_matricula_id_modalidade ON matricula(id_modalidade);
CREATE INDEX IF NOT EXISTS idx_ficha_treino_id_aluno ON ficha_treino(id_aluno);
CREATE INDEX IF NOT EXISTS idx_ficha_treino_id_modalidade ON ficha_treino(id_modalidade);

-- Índice Parcial
CREATE INDEX IF NOT EXISTS idx_matricula_ativas ON matricula(id_aluno, id_modalidade)
WHERE status = 'Ativo';

-- Índice Composto
CREATE INDEX IF NOT EXISTS idx_ficha_treino_aluno_data ON ficha_treino(id_aluno, data_criacao DESC);

--3. TRANSAÇÕES ATÕMICAS COM RETURNING E SAVEPOINT

-- TRANSAÇÃO 1: Matrícula de Novo Aluno e Geração de Ficha Inicial de Treino
BEGIN;

-- 1. Inserir novo aluno
INSERT INTO aluno (nome, cpf, data_nascimento, telefone, email)
VALUES ('Juliana Mendes', '444.555.666-77', '2001-05-12', '(98) 98444-5566', 'juliana@email.com');

SAVEPOINT aluno_cadastrado;

-- 2. Matricular a aluna usando o ID dinâmico gerado para o CPF dela
INSERT INTO matricula (id_aluno, id_modalidade, data_matricula, status)
VALUES (
    (SELECT id_aluno FROM aluno WHERE cpf = '444.555.666-77'),
    1,
    CURRENT_DATE,
    'Ativo'
);

-- 3. Criar a ficha de treino para a aluna
INSERT INTO ficha_treino (id_aluno, id_modalidade, objetivo, data_criacao, descricao_exercicios)
VALUES (
    (SELECT id_aluno FROM aluno WHERE cpf = '444.555.666-77'),
    1,
    'Adaptação e Resistência',
    CURRENT_DATE,
    '3x12 Leg Press, 3x15 Puxada Frontal, 20 min Escada'
);

COMMIT;

-- Transação 2: Trancamento de Matrícula e Atualização da Ficha de Treino
begin;

savepoint antes_alteracao;

--1. Alterar status da matrícula da aluna para 'Trancado'
update matricula
set status = 'Trancado'
where id_aluno = (select id_aluno from aluno where cpf = '444.555.666-77') and id_modalidade = 1 
returning id_matricula, id_aluno, status;

--2. Registrar histórico na ficha de treino desativando os treinos
update ficha_treino
set descricao_exercicios = '[TREINO SUSPENSO - MATRÍCULA TRANCADA]' || descricao_exercicios
where id_aluno = (select id_aluno from aluno where cpf = '444.555.666-77') and id_modalidade = 1;

commit;

--4. ANÁLISE DE DESEMPENHO (EXPLAIN ANALYZE)
--Consulta 1: Listagem de alunos ativos e suas modalidades
EXPLAIN ANALYZE
select 
    a.nome as Aluno,
    m.nome_modalidade as Modalidade,
    m.valor_mensal as Valor_Mensal,
    mat.status as Status_Matricula
from matricula mat
inner join aluno a on mat.id_aluno = a.id_aluno
inner join modalidade m on mat.id_modalidade = m.id_modalidade
where mat.status = 'Ativo';

--Consulta 2: Busca de fichas de treino recentes de um aluno
explain analyze 
select 
    a.nome as Aluno,
    m.nome_modalidade as Modalidade,
    f.objetivo as Objetivo,
    f.descricao_exercicios as Exercicios 
from ficha_treino f     
inner join aluno a on f.id_aluno = a.id_aluno
inner join modalidade m on f.id_modalidade = m.id_modalidade
where f.id_aluno = 1
order by f.data_criacao desc;

-- 5. CONTROLE DE ACESSO E SEGURANÇA (RBAC)

-- 1. Criar as Roles apenas se não existirem (sem dar DROP)
DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'role_recepcao') THEN
      CREATE ROLE role_recepcao;
   END IF;
   IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'role_instrutor') THEN
      CREATE ROLE role_instrutor;
   END IF;
END $$;

-- 2. Criar ou atualizar os Utilizadores e associar às Roles
DROP USER IF EXISTS usuario_recepcao;
DROP USER IF EXISTS usuario_instrutor;
CREATE USER usuario_recepcao WITH PASSWORD '123456';
CREATE USER usuario_instrutor WITH PASSWORD '123456';

GRANT role_recepcao TO usuario_recepcao;
GRANT role_instrutor TO usuario_instrutor;

-- 3. Permissões da Receção
GRANT USAGE ON SCHEMA public TO role_recepcao;
GRANT SELECT, INSERT, UPDATE ON aluno, matricula TO role_recepcao;
GRANT SELECT ON modalidade, ficha_treino TO role_recepcao;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO role_recepcao;

-- 4. Permissões do Instrutor
GRANT USAGE ON SCHEMA public TO role_instrutor;
GRANT SELECT ON aluno, modalidade, matricula TO role_instrutor;
GRANT SELECT, INSERT, UPDATE ON ficha_treino TO role_instrutor;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO role_instrutor;

-- 5. Aplicação do Princípio do Menor Privilégio
REVOKE DELETE ON ALL TABLES IN SCHEMA public FROM role_recepcao;
REVOKE DELETE ON ALL TABLES IN SCHEMA public FROM role_instrutor;