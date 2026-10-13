// ==============================================================================
// 09_mongodb_hospital.js - Modelagem, Carga e Consultas no MongoDB
// ==============================================================================

db = db.getSiblingDB('hospital_nosql');

db.pacientes.drop();
db.consultas_prontuarios.drop();

// 1. Inserção em 'pacientes' (Embedding em contato/convenio)
db.pacientes.insertMany([
  {
    _id: ObjectId("650000000000000000000001"),
    nome: "Ana Souza",
    cpf: "111.222.333-44",
    data_nascimento: ISODate("1990-05-12T00:00:00Z"),
    contato: { telefone: "(98) 98888-1111", email: "ana.souza@email.com" },
    convenio: { nome: "Bradesco Saúde", plano: "Master" },
    alergias: ["Penicilina", "Dipirona"]
  },
  {
    _id: ObjectId("650000000000000000000002"),
    nome: "Bruno Lima",
    cpf: "222.333.444-55",
    data_nascimento: ISODate("1985-08-25T00:00:00Z"),
    contato: { telefone: "(98) 98888-2222" },
    convenio: { nome: "Unimed", plano: "Enfermaria" },
    alergias: []
  },
  {
    _id: ObjectId("650000000000000000000003"),
    nome: "Carla Mendes",
    cpf: "333.444.555-66",
    data_nascimento: ISODate("2000-01-30T00:00:00Z"),
    contato: { telefone: "(98) 98888-3333", email: "carla.mendes@email.com" },
    tipo_sangue: "O+"
  },
  {
    _id: ObjectId("650000000000000000000004"),
    nome: "Diego Rocha",
    cpf: "444.555.666-77",
    data_nascimento: ISODate("1978-11-15T00:00:00Z"),
    contato: { telefone: "(98) 97777-4444" },
    convenio: { nome: "Bradesco Saúde", plano: "Executivo" }
  },
  {
    _id: ObjectId("650000000000000000000005"),
    nome: "Eduarda Alves",
    cpf: "555.666.777-88",
    data_nascimento: ISODate("1995-03-22T00:00:00Z"),
    contato: { telefone: "(98) 97777-5555" }
  }
]);

// 2. Inserção em 'consultas_prontuarios' (Referencing via paciente_id)
db.consultas_prontuarios.insertMany([
  {
    paciente_id: ObjectId("650000000000000000000001"),
    medico: { nome: "Dr. Carlos Silva", crm: "CRM-12345", especialidade: "Cardiologia" },
    data_hora: ISODate("2026-02-10T10:00:00Z"),
    status: "Realizada",
    valor: 250.00,
    diagnostico: { codigo_cid: "I10", descricao: "Hipertensão essencial (primária)" },
    prescricoes: [{ medicamento: "Dipirona 500mg", posologia: "1 comp de 6/6h", quantidade: 1 }]
  },
  {
    paciente_id: ObjectId("650000000000000000000002"),
    medico: { nome: "Dra. Maria Oliveira", crm: "CRM-67890", especialidade: "Pediatria" },
    data_hora: ISODate("2026-02-11T14:30:00Z"),
    status: "Realizada",
    valor: 180.00,
    diagnostico: { codigo_cid: "J00", descricao: "Nasofaringite aguda" },
    prescricoes: [{ medicamento: "Amoxicilina 500mg", posologia: "1 cáps de 8/8h", quantidade: 1 }]
  },
  {
    paciente_id: ObjectId("650000000000000000000003"),
    medico: { nome: "Dr. Roberto Santos", crm: "CRM-11223", especialidade: "Ortopedia" },
    data_hora: ISODate("2026-02-12T09:00:00Z"),
    status: "Agendada",
    valor: 300.00
  },
  {
    paciente_id: ObjectId("650000000000000000000001"),
    medico: { nome: "Dr. Carlos Silva", crm: "CRM-12345", especialidade: "Cardiologia" },
    data_hora: ISODate("2026-03-01T11:00:00Z"),
    status: "Realizada",
    valor: 250.00,
    diagnostico: { codigo_cid: "I10", descricao: "Acompanhamento de Hipertensão" },
    prescricoes: []
  },
  {
    paciente_id: ObjectId("650000000000000000000004"),
    medico: { nome: "Dr. Roberto Santos", crm: "CRM-11223", especialidade: "Ortopedia" },
    data_hora: ISODate("2026-03-05T16:00:00Z"),
    status: "Realizada",
    valor: 350.00,
    diagnostico: { codigo_cid: "M25.5", descricao: "Dor articular" },
    prescricoes: [{ medicamento: "Ibuprofeno 600mg", posologia: "1 comp de 12/12h", quantidade: 1 }]
  }
]);

// 3. Consultas com Filtro, Ordenação e Projeção
db.pacientes.find(
  { "convenio.nome": "Bradesco Saúde" },
  { nome: 1, cpf: 1, "convenio.plano": 1, _id: 0 }
).sort({ nome: 1 });

db.consultas_prontuarios.find(
  { status: "Realizada", valor: { $gt: 200 } },
  { "medico.nome": 1, "medico.especialidade": 1, diagnostico: 1, valor: 1, _id: 0 }
).sort({ valor: -1 });

// 4. Índices e Explain
db.pacientes.createIndex({ cpf: 1 }, { unique: true });
db.pacientes.find({ cpf: "111.222.333-44" }).explain("executionStats");

db.consultas_prontuarios.createIndex({ "medico.crm": 1, data_hora: -1 });
db.consultas_prontuarios.find({ 
  "medico.crm": "CRM-12345", 
  data_hora: { $gte: ISODate("2026-01-01T00:00:00Z") } 
}).explain("executionStats");

printjson(db.pacientes.find().toArray());