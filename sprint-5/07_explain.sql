--7. Plano de execução

explain analyze
select c.consulta_id, p.nome, c.data_hora
from consultas c
join pacientes p on c.paciente_id = p.paciente_id
where c.data_hora between '2026-01-01' and '2026-02-01';

