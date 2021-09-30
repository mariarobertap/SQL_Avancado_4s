--Exercicio--
--Crie um cursor para listar nome das clientes e da cidade onde mora--


select * from cliente
USE LOCADORA;

SET NOCOUNT ON;

DECLARE cursor_nome CURSOR FOR 

	SELECT nome, cidade  FROM cliente

	DECLARE @Nome VARCHAR(200)
	DECLARE @Cidade VARCHAR(100)

	OPEN cursor_nome

	FETCH NEXT FROM 
		cursor_nome
	INTO
		@Nome,
		@Cidade

	WHILE @@FETCH_STATUS = 0
	BEGIN

		PRINT '_______________________'
		PRINT CONCAT('Nome: ', @Nome)
		PRINT '_______________________'
		PRINT CONCAT('Nome da cidade: ', @Cidade)

			FETCH NEXT FROM  cursor_nome INTO @Nome, @Cidade
	END

CLOSE cursor_nome
DEALLOCATE cursor_nome



------------------------------
select descricao, valor from filme
USE LOCADORA;

USE LOCADORA;

SET NOCOUNT ON;

DECLARE cursor_valor CURSOR FOR 

	select descricao, valor from filme

	DECLARE @NomeFilme VARCHAR(200)
	DECLARE @Valor VARCHAR(100)

	OPEN cursor_valor

	FETCH NEXT FROM 
		cursor_valor
	INTO
		@NomeFilme,
		@Valor

	WHILE @@FETCH_STATUS = 0
	BEGIN

		PRINT '_______________________'
		PRINT CONCAT('Nome filme: ', @NomeFilme)
		PRINT '_______________________'
		PRINT CONCAT('Valor filme: ', @Valor)

			FETCH NEXT FROM  cursor_valor INTO @NomeFilme, @Valor
	END

CLOSE cursor_valor
DEALLOCATE cursor_valor
