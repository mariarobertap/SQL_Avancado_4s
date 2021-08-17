USE master;

CREATE DATABASE GATILHO;

USE GATILHO;

CREATE TABLE tabela(
	id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	valor NVARCHAR(100)
)

SELECT * FROM tabela

CREATE TABLE tabela_log(
	id INT,
	valor NVARCHAR(100),
	comando_dml CHAR(1), -- I, U, D
	data DATETIME DEFAULT GETDATE()
)

SELECT * FROM tabela_log

insert into tabela (valor) values ( 'Maria')

-- Sintaxe Trigger (gatilho) (INSERT)
CREATE TRIGGER TGR_LOG_TABELA_INSERT
ON tabela
AFTER INSERT
AS
BEGIN
	
	INSERT INTO tabela_log
		(id, valor, comando_dml)
	SELECT
		id, valor, 'I'
	FROM
		inserted
END

DROP TRIGGER TGR_LOG_TABELA_INSERT
-- Testando o Trigger (gatilho)
INSERT INTO tabela (valor) VALUES ('Valor 1')
INSERT INTO tabela (valor) VALUES ('Valor 2')
INSERT INTO tabela (valor) VALUES ('Valor 3')

SELECT * FROM tabela
SELECT * FROM tabela_log

-- Sintaxe Trigger (gatilho) (UPDATE)
CREATE TRIGGER TGR_LOG_TABELA_UPDATE
ON tabela
AFTER UPDATE
AS
BEGIN
	
	INSERT INTO tabela_log
		(id, valor, comando_dml)
	SELECT
		id, valor, 'U'
	FROM
		inserted
END

-- Testando o Trigger (gatilho)
INSERT INTO tabela (valor) VALUES ('Valor 4')

UPDATE tabela SET valor = 'Valor 4 (alterado)' WHERE id = 4

SELECT * FROM tabela
SELECT * FROM tabela_log

-- Sintaxe Trigger (gatilho) (DELETE)
CREATE OR ALTER TRIGGER TGR_LOG_TABELA_DELETE
ON tabela
AFTER DELETE
AS
BEGIN
	
	INSERT INTO tabela_log
		(id, valor, comando_dml)
	SELECT
		id, valor, 'D'
	FROM
		deleted
END

SELECT * FROM tabela
SELECT * FROM tabela_log

DELETE tabela WHERE id = 4

--TRUNCATE TABLE tabela
--TRUNCATE TABLE tabela_log