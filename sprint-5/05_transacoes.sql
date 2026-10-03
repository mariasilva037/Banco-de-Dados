-- 5. Transações ACID
--Transação 1: Inserção encadeada garantida com CTE / RETURNING (imune a erros de sequence)

begin;

with nova_consulta as (
    insert into consultas (paciente_id, medico_id, convenio_id, data_hora, valor, status)
    values (1, 2, 1, CURRENT_TIMESTAMP, 350.00, 'Agendada')
    returning consulta_id
)
insert into faturamentos (consulta_id, valor_total, status_pagamento)
select consulta_id, 350.00, 'Pendente' from nova_consulta;
commit;

--Transação 2: Simulação de rollback em falha de regra de negócio

begin;
update medicamentos
set estoque_atual = estoque_atual - 10
where medicamento_id = 1;
rollback;