--Exercicio--
--Crie um cursor para listar nome das clientes e da cidade onde mora--

/*
	BANCO DE DADOS AVANÇADO (TADS)
	Exemplo de Cursor
	Prof: Tiago José Marciano
*/

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
		DECLARE @mensagem VARCHAR(100)

		--SELECT @mensagem = '# Filmes de ' + @categoria
		SET @mensagem = CONCAT(@Nome, ' ', @Cidade)
			
		PRINT @mensagem

			FETCH NEXT FROM  cursor_nome INTO @Nome, @Cidade
	END

CLOSE cursor_nome
DEALLOCATE cursor_nome