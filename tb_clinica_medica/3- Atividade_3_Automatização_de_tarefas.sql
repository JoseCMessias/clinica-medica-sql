-- store procedure: agenda médicos
create procedure Agenda_Medicos
as
begin
	select m.nome_medico, m.especialidade, m.crm, c.numero_consulta, c.data_consulta, 
		c.horario_consulta, p.nome_paciente, p.cpf,  
		p.nome_plano, p.tipo_plano 	from medico as m inner join consulta as c 
		on m.crm = c.fk_medico_crm inner join paciente as p on c.fk_paciente_cpf = p.cpf 
		order by m.nome_medico, c.data_consulta;
end

execute Agenda_Medicos;

-- drop procedure Agenda_Medicos;

-----------------------------------------------------------------------

-- store procedure: exames solicitados em ordem de médico
create procedure Exames_Solicitados
as
begin
select m.nome_medico, m.especialidade, m.crm, c.numero_consulta, 
	p.numero_pedido, p.data_exame, e.codigo, e.especificacao
	from medico as m inner join consulta as c 
	on m.crm = c.fk_medico_crm inner join pedido_exame as p 
	on c.numero_consulta = p.fk_consulta_numero_consulta
	inner join exame as e on p.fk_exame_codigo = e.codigo 
	order by m.nome_medico, p.data_exame;
end

execute Exames_Solicitados;

-- drop procedure Exames_Solicitados;

-----------------------------------------------------------------------

-- store procedure: histórico pagamentos dos pacientes
create procedure Historico_Pagamentos
as
begin
select pa.nome_paciente, pa.cpf, c.numero_consulta, c.data_consulta,  
		pe.data_exame, pe.valor_pagar, 
		e.codigo, e.especificacao from paciente as pa inner join consulta as c 
		on pa.cpf = c.fk_paciente_cpf inner join pedido_exame as pe 
		on c.numero_consulta = pe.fk_consulta_numero_consulta inner join exame as e 
		on pe.fk_exame_codigo = e.codigo 
		order by pa.nome_paciente, pe.data_exame;
end

 execute Historico_Pagamentos;

-- drop procedure Historico_Pagamentos;

-----------------------------------------------------------------------

-- store procedure: resumo pagamentos por paciente
create procedure Resumo_Pagamentos @nome_pac varchar(40)
as
begin
select pa.nome_paciente, sum(pe.valor_pagar) as total_pagar
		from paciente as pa inner join consulta as c 
		on pa.cpf = c.fk_paciente_cpf inner join pedido_exame as pe 
		on c.numero_consulta = pe.fk_consulta_numero_consulta 
		where pa.nome_paciente = @nome_pac
		group by pa.nome_paciente;
end

execute Resumo_Pagamentos 'Leonardo Ribeiro';
execute Resumo_Pagamentos 'Maria Pereira';
execute Resumo_Pagamentos 'Bruna Alvez';

-- drop procedure Resumo_Pagamentos;

