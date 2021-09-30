/*
	BANCO DE DADOS AVANÇADO (TADS)
	Exemplo de Cursor
	Prof: Tiago José Marciano
*/

USE LOCADORA;

SET NOCOUNT ON;

DECLARE cursor_categoria CURSOR FOR 

	SELECT id as categoriaId, descricao as categoria FROM categoria

	DECLARE @categoriaId INT
	DECLARE @categoria VARCHAR(100)

	OPEN cursor_categoria

	FETCH NEXT FROM 
		cursor_categoria
	INTO
		@categoriaId,
		@categoria

	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @mensagem VARCHAR(100)

		SELECT @mensagem = '# Filmes de ' + @categoria

		PRINT @mensagem

		DECLARE cursor_filme CURSOR FOR

			SELECT 
				id as filmeId, 
				descricao as filme
			FROM 
				filme 
			WHERE 
				categoriaId = @categoriaId

			DECLARE @filmeId INT
			DECLARE @filme VARCHAR(100)

			OPEN cursor_filme

			FETCH NEXT FROM 
				cursor_filme
			INTO
				@filmeId,
				@filme
			
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SELECT @mensagem = '- ' + @filme

				PRINT @mensagem

				FETCH NEXT FROM 
					cursor_filme
				INTO
					@filmeId,
					@filme
			END

			CLOSE cursor_filme
			DEALLOCATE cursor_filme

			PRINT ''

		FETCH NEXT FROM 
			cursor_categoria
		INTO
			@categoriaId,
			@categoria
	END

CLOSE cursor_categoria
DEALLOCATE cursor_categoria