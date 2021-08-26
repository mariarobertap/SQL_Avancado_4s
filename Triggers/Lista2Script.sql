Considere uma tabela de salários em um banco de dados, toda vez que o campo salário for alterado na tabela de salários,
é preciso manter um log de auditoria em uma tabela que armazena os dados do salário antes e depois da alteração,
além de manter os dados do usuário (SYSTEM_USER) e a data da alteração. 

a) Teste o trigger atualizando o salário da matrícula 1 para R$ 2.000,00.
b) Teste o trigger atualizando o salário da matrícula 2 para R$ 1.500,00.
c) Teste o trigger atualizando o salário da matrícula 3 para R$ 2.000,00.
d) Teste o trigger atualizando o salário da matrícula 4 para R$ 2.500,00.
e) Teste o trigger atualizando todos salários com um aumento de 10%.

# DDL com os artefatos necessários para o lab

USE GATILHO;

CREATE TABLE salario(
	matricula INT NOT NULL,
	salario DECIMAL(10, 2) NOT NULL
)

INSERT INTO salario VALUES (1, 1000)
INSERT INTO salario VALUES (2, 1500)
INSERT INTO salario VALUES (3, 2000)
INSERT INTO salario VALUES (4, 2500)

update  salario set salario = 2000 where matricula = 1
update  salario set salario = 1500 where matricula = 2
update  salario set salario = 2000 where matricula = 3
update  salario set salario = 2500 where matricula = 4
update  salario set salario = 2500 

delete from auditoria_salario


SELECT * FROM salario

CREATE TABLE auditoria_salario(
	matricula INT NOT NULL,
	sal_antes DECIMAL(10, 2) NOT NULL,
	sal_depois DECIMAL(10, 2) NOT NULL,
	usuario VARCHAR(50) NOT NULL,
	data_atualizacao DATETIME NOT NULL
)

SELECT * FROM auditoria_salario

CREATE OR ALTER TRIGGER TRIGGER_SALARIO
ON salario
AFTER INSERT, UPDATE
AS
BEGIN
	declare @count INT
	declare @count2 DECIMAL(10,2)
	declare CURSOR_TESTE cursor
	for SELECT matricula, salario FROM inserted

	open CURSOR_TESTE  
	
    fetch next from CURSOR_TESTE into @count, @count2  
      
		while @@fetch_status = 0  
		begin 

		INSERT INTO
			auditoria_salario	
			SELECT 
				    i.matricula,
					d.salario,
					i.salario,
					SYSTEM_USER,
					GETDATE()
				FROM 
				deleted d 
					join inserted i 
					on d.matricula = @count
			   
			fetch next from CURSOR_TESTE into @count  
		end 
 
    close CURSOR_TESTE  
    deallocate CURSOR_TESTE  

END;
GO

SELECT * FROM 
DROP TRIGGER  TRIGGER_SALARIO
DECLARE @sys_usr CHAR(30);  
SET @sys_usr = SYSTEM_USER;  
SELECT 'The current system user is: '+ @sys_usr;  
GO  