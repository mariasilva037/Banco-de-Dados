--1. Criação das 11 tabelas com os Constraints

create table departamentos (
    departamento_id SERIAL primary key,
    nome VARCHAR(100) not null unique,
    sigla VARCHAR(10) not null unique,
    andar INT check (andar >= 0)
);

create table medicos (
    medico_id SERIAL primary key,
    crm VARCHAR(20) not null unique,
    nome VARCHAR(150) not null,
    especialidade VARCHAR(100) not null,
    departamento_id INT not null references departamentos(departamento_id),
    status VARCHAR(20) default 'Ativo' check (status in ('Ativo', 'Inativo', 'Licenca'))
);

create table pacientes (
    paciente_id SERIAL primary key,
    cpf VARCHAR(11) not null unique,
    nome VARCHAR(150) not null,
    data_nascimento DATE not null,
    sexo CHAR(1) check (sexo in ('M', 'F', 'O')),
    telefone VARCHAR(20) not null,
    email VARCHAR(100) unique,
    data_cadastro TIMESTAMP default CURRENT_TIMESTAMP
);

create table convenios (
    convenio_id SERIAL primary key,
    cnpj VARCHAR(14) not null unique,
    nome_fantasia VARCHAR(100) not null,
    tipo_plano VARCHAR(50) default 'Enfermaria' check (tipo_plano in ('Enfermaria', 'Apartamento', 'VIP'))
);

create table quartos (
    quarto_id SERIAL primary key,
    numero VARCHAR(10) not null unique,
    tipo VARCHAR(50) not null check (tipo in ('UTI', 'Enfermaria', 'Apartamento')),
    capacidade INT default 1 check (capacidade > 0)
);

create table internacoes (
    internacao_id SERIAL primary key,
    paciente_id INT not null references pacientes(paciente_id),
    quarto_id INT not null references quartos(quarto_id),
    data_entrada TIMESTAMP not null default CURRENT_TIMESTAMP,
    data_saida TIMESTAMP,
    motivo TEXT not null,
    constraint chk_datas check (data_saida is null or data_saida >= data_entrada)
);

create table consultas (
    consulta_id SERIAL primary key,
    paciente_id INT not null references pacientes(paciente_id),
    medico_id INT not null references medicos(medico_id),
    convenio_id INT references convenios(convenio_id),
    data_hora TIMESTAMP not null,
    valor DECIMAL(10, 2) not null check (valor >= 0),
    status VARCHAR(20) default 'Agendada' check (status in ('Agendada', 'Realizada', 'Cancelada'))
);

create table diagnosticos (
    diagnostico_id SERIAL primary key,
    consulta_id INT not null references consultas(consulta_id) on delete cascade,
    codigo_cid VARCHAR(10) not null,
    descricao TEXT not null,
    data_diagnostico DATE default CURRENT_DATE
);   

create table medicamentos (
    medicamento_id SERIAL primary key,
    nome_comercial VARCHAR(100) not null,
    principio_ativo VARCHAR(100) not null,
    estoque_atual INT default 0 check (estoque_atual >= 0),
    preco_unitario DECIMAL(10, 2) not null check (preco_unitario >= 0)
);

create table prescricoes(
    prescricao_id SERIAL primary key,
    consulta_id INT not null references consultas(consulta_id),
    medicamento_id INT not null references medicamentos(medicamento_id),
    dosagem VARCHAR(100) not null,
    frequencia VARCHAR(100) not null,
    quantidade INT not null check (quantidade >= 0)
);

create table faturamentos (
    faturamento_id SERIAL primary key,
    consulta_id INT unique references consultas(consulta_id),
    internacao_id INT unique references internacoes(internacao_id),
    valor_total DECIMAL(10, 2) not null check (valor_total >=0),
    status_pagamento VARCHAR(20) default 'Pendente', check (status_pagamento in ('Pendente', 'Pago', 'Cancelado')),
    data_emissao TIMESTAMP default CURRENT_TIMESTAMP,
    constraint chk_origem check (
        (consulta_id is not null and internacao_id is null) or 
        (consulta_id is null and internacao_id is not null))
);