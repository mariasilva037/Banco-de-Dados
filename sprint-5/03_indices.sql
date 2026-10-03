--3. Criação de índices

create index if not exists idx_consultas_data_hora on consultas(data_hora);
create index if not exists idx_pacientes_cpf on pacientes(cpf);
create index if not exists idx_consultas_paciente_id on consultas(paciente_id);
create index if not exists idx_consultas_medico_status on consultas(medico_id, status);
create index if not exists idx_medicamentos_principio_ativo on medicamentos(principio_ativo);
