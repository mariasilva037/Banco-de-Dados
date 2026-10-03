--2. Populando as Tabelas

INSERT INTO departamentos (nome, sigla, andar) VALUES
('Cardiologia', 'CARD', 2), ('Neurologia', 'NEURO', 3), ('Pediatria', 'PED', 1), ('Ortopedia', 'ORTO', 2),
('Oncologia', 'ONCO', 4), ('Ginecologia', 'GINE', 1), ('Dermatologia', 'DERM', 2), ('Urologia', 'URO', 3),
('Psiquiatria', 'PSIQ', 5), ('Gastroenterologia', 'GASTRO', 3), ('Oftalmologia', 'OFTA', 1), ('Otorrinolaringologia', 'OTORRO', 2),
('Endocrinologia', 'ENDO', 4), ('Nefrologia', 'NEFRO', 3), ('Pneumologia', 'PNEUMO', 4);

INSERT INTO medicos (crm, nome, especialidade, departamento_id, status) VALUES
('CRM1001', 'Dr. Carlos Silva', 'Cardiologia', 1, 'Ativo'),
('CRM1002', 'Dra. Ana Costa', 'Neurologia', 2, 'Ativo'),
('CRM1003', 'Dr. Joao Pereira', 'Pediatria', 3, 'Ativo'),
('CRM1004', 'Dra. Maria Santos', 'Ortopedia', 4, 'Ativo'),
('CRM1005', 'Dr. Pedro Alves', 'Oncologia', 5, 'Ativo'),
('CRM1006', 'Dra. Fernanda Lima', 'Ginecologia', 6, 'Ativo'),
('CRM1007', 'Dr. Lucas Rocha', 'Dermatologia', 7, 'Ativo'),
('CRM1008', 'Dra. Juliana Mendes', 'Urologia', 8, 'Ativo'),
('CRM1009', 'Dr. Gabriel Ramos', 'Psiquiatria', 9, 'Ativo'),
('CRM1010', 'Dra. Patricia Melo', 'Gastroenterologia', 10, 'Ativo'),
('CRM1011', 'Dr. Roberto Nunes', 'Oftalmologia', 11, 'Ativo'),
('CRM1012', 'Dra. Camila Souza', 'Otorrinolaringologia', 12, 'Ativo'),
('CRM1013', 'Dr. Marcelo Ribeiro', 'Endocrinologia', 13, 'Ativo'),
('CRM1014', 'Dra. Vanessa Martins', 'Nefrologia', 14, 'Ativo'),
('CRM1015', 'Dr. Thiago Oliveira', 'Pneumologia', 15, 'Ativo');

INSERT INTO pacientes (cpf, nome, data_nascimento, sexo, telefone, email) VALUES
('11111111101', 'Marcos Paulo', '1985-03-12', 'M', '11988880001', 'marcos@email.com'),
('11111111102', 'Beatriz Souza', '1992-07-25', 'F', '11988880002', 'beatriz@email.com'),
('11111111103', 'Carla Dias', '1978-11-05', 'F', '11988880003', 'carla@email.com'),
('11111111104', 'Daniel Farias', '2001-01-18', 'M', '11988880004', 'daniel@email.com'),
('11111111105', 'Eduardo Lima', '1965-09-30', 'M', '11988880005', 'eduardo@email.com'),
('11111111106', 'Fernanda Torres', '1995-04-14', 'F', '11988880006', 'fernanda@email.com'),
('11111111107', 'Gustavo Borges', '1989-12-22', 'M', '11988880007', 'gustavo@email.com'),
('11111111108', 'Helena Roitman', '1954-06-08', 'F', '11988880008', 'helena@email.com'),
('11111111109', 'Igor Guimaraes', '1998-08-19', 'M', '11988880009', 'igor@email.com'),
('11111111110', 'Jessica Andrade', '1990-02-28', 'F', '11988880010', 'jessica@email.com'),
('11111111111', 'Kleverton Silva', '1982-10-10', 'M', '11988880011', 'kleverton@email.com'),
('11111111112', 'Luana Piovani', '1976-05-15', 'F', '11988880012', 'luana@email.com'),
('11111111113', 'Murilo Benicio', '1971-07-13', 'M', '11988880013', 'murilo@email.com'),
('11111111114', 'Nivea Maria', '1950-03-07', 'F', '11988880014', 'nivea@email.com'),
('11111111115', 'Otavio Muller', '1968-11-11', 'M', '11988880015', 'otavio@email.com');

INSERT INTO convenios (cnpj, nome_fantasia, tipo_plano) VALUES
('00000000000101', 'Unimed', 'Apartamento'), ('00000000000102', 'Amil', 'Enfermaria'),
('00000000000103', 'Bradesco Saude', 'VIP'), ('00000000000104', 'SulAmerica', 'Apartamento'),
('00000000000105', 'Notredame Intermedica', 'Enfermaria'), ('00000000000106', 'Porto Seguro Saude', 'VIP'),
('00000000000107', 'Golden Cross', 'Enfermaria'), ('00000000000108', 'Hapvida', 'Enfermaria'),
('00000000000109', 'Cassi', 'Apartamento'), ('00000000000110', 'Petrobras Distribuidora', 'VIP'),
('00000000000111', 'Allianz Saude', 'Apartamento'), ('00000000000112', 'Care Plus', 'VIP'),
('00000000000113', 'Omint', 'VIP'), ('00000000000114', 'Prevent Senior', 'Enfermaria'),
('00000000000115', 'Assim Saude', 'Enfermaria');

INSERT INTO quartos (numero, tipo, capacidade) VALUES
('101', 'Enfermaria', 4), ('102', 'Enfermaria', 4), ('103', 'Apartamento', 1), ('104', 'Apartamento', 1),
('201', 'UTI', 1), ('202', 'UTI', 1), ('203', 'UTI', 1), ('204', 'UTI', 1),
('301', 'Enfermaria', 2), ('302', 'Enfermaria', 2), ('303', 'Apartamento', 1), ('304', 'Apartamento', 1),
('401', 'UTI', 2), ('402', 'Enfermaria', 4), ('403', 'Apartamento', 1);

INSERT INTO internacoes (paciente_id, quarto_id, data_entrada, data_saida, motivo) VALUES
(1, 5, '2026-01-10 10:00:00', '2026-01-15 12:00:00', 'Infarto agudo do miocardio'),
(2, 1, '2026-01-12 14:30:00', '2026-01-14 09:00:00', 'Observacao por fratura'),
(3, 3, '2026-01-20 08:00:00', '2026-01-22 16:00:00', 'Cirurgia na vesicula'),
(4, 6, '2026-02-01 11:00:00', '2026-02-10 10:00:00', 'Pneumonia grave'),
(5, 7, '2026-02-05 18:20:00', NULL, 'Tratamento intensivo neurologico'),
(6, 2, '2026-02-10 09:15:00', '2026-02-12 11:00:00', 'Parto cirurgico'),
(7, 4, '2026-02-15 07:00:00', '2026-02-16 18:00:00', 'Procedimento ortopedico'),
(8, 8, '2026-02-20 22:00:00', NULL, 'Insuficiencia respiratoria'),
(9, 9, '2026-03-01 13:00:00', '2026-03-03 14:00:00', 'Apendicite'),
(10, 10, '2026-03-02 15:30:00', '2026-03-05 10:00:00', 'Infeccao urinaria grave'),
(11, 11, '2026-03-05 08:00:00', '2026-03-08 12:00:00', 'Procedimento Dermatologico complexo'),
(12, 12, '2026-03-10 10:00:00', NULL, 'Complicacoes renais'),
(13, 13, '2026-03-12 16:45:00', '2026-03-15 09:00:00', 'Avaliacao psiquiatrica intensiva'),
(14, 14, '2026-03-18 19:00:00', '2026-03-25 10:00:00', 'Cirurgia cardiaca'),
(15, 15, '2026-03-20 11:15:00', NULL, 'Tratamento de Gastroenterite severa');

INSERT INTO consultas (paciente_id, medico_id, convenio_id, data_hora, valor, status) VALUES
(1, 1, 1, '2026-01-05 14:00:00', 300.00, 'Realizada'),
(2, 4, 2, '2026-01-06 10:00:00', 250.00, 'Realizada'),
(3, 10, 3, '2026-01-10 11:30:00', 400.00, 'Realizada'),
(4, 15, 4, '2026-01-28 09:00:00', 350.00, 'Realizada'),
(5, 2, 5, '2026-02-02 16:00:00', 300.00, 'Realizada'),
(6, 6, 6, '2026-02-08 08:30:00', 500.00, 'Realizada'),
(7, 4, 7, '2026-02-12 15:00:00', 250.00, 'Realizada'),
(8, 15, 8, '2026-02-18 10:30:00', 200.00, 'Realizada'),
(9, 10, 9, '2026-02-25 14:00:00', 350.00, 'Realizada'),
(10, 8, 10, '2026-03-01 11:00:00', 450.00, 'Realizada'),
(11, 7, 11, '2026-03-03 13:30:00', 280.00, 'Realizada'),
(12, 14, 12, '2026-03-08 17:00:00', 500.00, 'Realizada'),
(13, 9, 13, '2026-03-10 09:30:00', 400.00, 'Realizada'),
(14, 1, 14, '2026-03-15 15:00:00', 220.00, 'Realizada'),
(15, 10, 15, '2026-03-19 10:00:00', 200.00, 'Realizada');

INSERT INTO diagnosticos (consulta_id, codigo_cid, descricao) VALUES
(1, 'I21', 'Infarto agudo do miocardio com supra de ST'),
(2, 'S82', 'Fratura da perna, incluindo tornozelo'),
(3, 'K80', 'Colelitiase (calculos na vesicula biliar)'),
(4, 'J18', 'Pneumonia por organismo nao especificado'),
(5, 'G40', 'Epilepsia e crises convulsivas recorrentes'),
(6, 'O80', 'Parto unico espontaneo'),
(7, 'M54', 'Dorsalgia e dores na coluna vertebral'),
(8, 'J44', 'Doenca pulmonar obstrutiva cronica (DPOC)'),
(9, 'K35', 'Apendicite aguda'),
(10, 'N39', 'Transtorno do aparelho urinario / Infeccao'),
(11, 'L20', 'Dermatite atopica severa'),
(12, 'N18', 'Doenca renal cronica'),
(13, 'F32', 'Episodio depressivo grave'),
(14, 'I05', 'Doencas reumaticas da valvula mitral'),
(15, 'A09', 'Gastroenterite e colite de origem infecciosa');

INSERT INTO medicamentos (nome_comercial, principio_ativo, estoque_atual, preco_unitario) VALUES
('Dipirona 500mg', 'Metamizol', 500, 5.00), ('Amoxicilina 500mg', 'Amoxicilina', 200, 18.50),
('Omeprazol 20mg', 'Omeprazol', 350, 12.00), ('Losartana 50mg', 'Losartana Potassica', 400, 8.00),
('Aspirina 100mg', 'Acido Acetilsalicilico', 600, 4.50), ('Ibuprofeno 600mg', 'Ibuprofeno', 300, 15.00),
('Paracetamol 750mg', 'Paracetamol', 450, 6.00), ('Azitromicina 500mg', 'Azitromicina', 150, 32.00),
('Sertralina 50mg', 'Cloridrato de Sertralina', 180, 45.00), ('Cipronat 500mg', 'Ciprofloxacino', 220, 28.00),
('Rivotril 2mg', 'Clonazepam', 90, 22.00), ('Morfina 10mg', 'Sulfato de Morfina', 50, 85.00),
('Insulina Regular', 'Insulina Humana', 80, 95.00), ('Clexane 40mg', 'Enoxaparina Sodica', 110, 120.00),
('Aerolin Spray', 'Salbutamol', 130, 35.00);

INSERT INTO prescricoes (consulta_id, medicamento_id, dosagem, frequencia, quantidade) VALUES
(1, 5, '100mg', '1x ao dia', 30), (1, 14, '40mg', '1x ao dia Subcutaneo', 10),
(2, 6, '600mg', '8/8h por 5 dias', 15), (3, 3, '20mg', '1x ao dia em jejum', 30),
(4, 2, '500mg', '8/8h por 7 dias', 21), (4, 15, '100mcg', '6/6h de resgate', 2),
(5, 11, '2mg', '1x a noite', 30), (6, 1, '500mg', '6/6h se dor', 20),
(7, 6, '600mg', '12/12h por 7 dias', 14), (8, 15, '100mcg', '8/8h uso continuo', 3),
(9, 12, '10mg', '4/4h se dor intensa', 5), (10, 10, '500mg', '12/12h por 10 dias', 20),
(11, 1, '500mg', '6/6h se febre ou dor', 15), (12, 4, '50mg', '1x ao dia', 30),
(13, 9, '50mg', '1x pela manha', 30), (14, 5, '100mg', '1x ao dia', 30),
(15, 3, '20mg', '1x ao dia', 14);

INSERT INTO faturamentos (consulta_id, internacao_id, valor_total, status_pagamento) VALUES
(1, NULL, 300.00, 'Pago'), (2, NULL, 250.00, 'Pago'), (3, NULL, 400.00, 'Pago'),
(4, NULL, 350.00, 'Pago'), (5, NULL, 300.00, 'Pago'), (6, NULL, 500.00, 'Pago'),
(7, NULL, 250.00, 'Pendente'), (8, NULL, 200.00, 'Pago'), (9, NULL, 350.00, 'Pendente'),
(10, NULL, 450.00, 'Pago'), (11, NULL, 280.00, 'Pago'), (12, NULL, 500.00, 'Pendente'),
(13, NULL, 400.00, 'Pago'), (14, NULL, 220.00, 'Pago'), (15, NULL, 200.00, 'Pendente');
