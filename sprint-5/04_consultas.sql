--4. Consultas SQL

-- 1. INNER JOIN
SELECT c.consulta_id, p.nome AS paciente, m.nome AS medico, conv.nome_fantasia AS convenio, c.data_hora
FROM consultas c
JOIN pacientes p ON c.paciente_id = p.paciente_id
JOIN medicos m ON c.medico_id = m.medico_id
LEFT JOIN convenios conv ON c.convenio_id = conv.convenio_id;

-- 2. GROUP BY + HAVING
SELECT m.nome AS medico, COUNT(c.consulta_id) AS total_atendimentos, SUM(c.valor) AS receita_total
FROM medicos m
JOIN consultas c ON m.medico_id = c.medico_id
GROUP BY m.nome
HAVING SUM(c.valor) > 300.00;

-- 3. Subconsulta com IN
SELECT nome, cpf FROM pacientes 
WHERE paciente_id IN (
    SELECT paciente_id FROM consultas GROUP BY paciente_id HAVING COUNT(consulta_id) >= 1
);

-- 4. LEFT JOIN e GROUP BY
SELECT q.tipo AS tipo_quarto, COUNT(i.internacao_id) AS total_internacoes
FROM quartos q
LEFT JOIN internacoes i ON q.quarto_id = i.quarto_id
GROUP BY q.tipo;

-- 5. Juncao de multiplas tabelas
SELECT p.nome AS paciente, m.nome_comercial AS medicamento, pr.dosagem, pr.frequencia
FROM prescricoes pr
JOIN consultas c ON pr.consulta_id = c.consulta_id
JOIN pacientes p ON c.paciente_id = p.paciente_id
JOIN medicamentos m ON pr.medicamento_id = m.medicamento_id;

-- 6. Agrupamento por diagnostico
SELECT codigo_cid, COUNT(diagnostico_id) AS recorrencia
FROM diagnosticos
GROUP BY codigo_cid
ORDER BY recorrencia DESC;

-- 7. Pacientes em UTI
SELECT p.nome, i.motivo, q.numero AS numero_quarto
FROM internacoes i
JOIN pacientes p ON i.paciente_id = p.paciente_id
JOIN quartos q ON i.quarto_id = q.quarto_id
WHERE q.tipo = 'UTI';

-- 8. Faturamentos Pendentes
SELECT f.faturamento_id, p.nome AS paciente, f.valor_total, f.status_pagamento
FROM faturamentos f
JOIN consultas c ON f.consulta_id = c.consulta_id
JOIN pacientes p ON c.paciente_id = p.paciente_id
WHERE f.status_pagamento = 'Pendente';

-- 9. Subconsulta com NOT IN
SELECT nome, especialidade FROM medicos
WHERE medico_id NOT IN (
    SELECT DISTINCT m.medico_id FROM medicos m 
    JOIN consultas c ON m.medico_id = c.medico_id
    JOIN internacoes i ON c.paciente_id = i.paciente_id
);

-- 10. Agregacao por departamento
SELECT d.nome AS departamento, ROUND(AVG(c.valor), 2) AS valor_medio
FROM departamentos d
JOIN medicos m ON d.departamento_id = m.departamento_id
JOIN consultas c ON m.medico_id = c.medico_id
GROUP BY d.nome;