--6. Controle de permissões
drop user if exists medico_user;
drop user if exists recepcao_user;

create user medico_user with password 'medico123';
create user recepcao_user with password 'recepcao123';

--Permissões do médico
grant select on pacientes, consultas, medicamentos to medico_user;
grant insert, update on diagnosticos, prescricoes to medico_user;

--Permissões da Recepção
grant select, insert, update on pacientes, consultas, faturamentos to recepcao_user;

--Revogações de segurança
revoke delete on all tables in schema public from recepcao_user;
revoke delete on all tables in schema public from medico_user;
