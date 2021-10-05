USE LOCADORA;

/*
Cursores
Prática: Exercício 01
Crie um Cursor para listar os nomes dos clientes e o nome da cidade onde mora.
*/
SET NOCOUNT ON;

DECLARE cursor_exerc_01 CURSOR FOR

	SELECT 
		nome as cliente,
		cidade
	FROM 
		cliente

	DECLARE @cliente VARCHAR(60)
	DECLARE @cidade  VARCHAR(60)

	OPEN cursor_exerc_01

	FETCH NEXT FROM
		cursor_exerc_01
	INTO
		@cliente,
		@cidade

	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @mensagem VARCHAR(100)

		SELECT @mensagem = CONCAT(@cliente, ' - ', @cidade)

		PRINT @mensagem

		FETCH NEXT FROM
			cursor_exerc_01
		INTO
			@cliente,
			@cidade
	END

CLOSE cursor_exerc_01
DEALLOCATE cursor_exerc_01

/*
Cursores
Prática: Exercício 02
Crie um Cursor para listar os nomes dos filmes e o seu valor de locação.
*/
SET NOCOUNT ON;

DECLARE cursor_exerc_02 CURSOR FOR

	SELECT
		descricao as filme,
		valor
	FROM
		filme

	DECLARE @filme VARCHAR(60)
	DECLARE @valor DECIMAL(10,2)

	OPEN cursor_exerc_02

	FETCH NEXT FROM
		cursor_exerc_02
	INTO
		@filme,
		@valor

	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @mensagem VARCHAR(100)

		SELECT @mensagem = CONCAT(@filme, ' - R$ ', @valor)

		PRINT @mensagem

		FETCH NEXT FROM
			cursor_exerc_02
		INTO
			@filme,
			@valor
	END

CLOSE cursor_exerc_02
DEALLOCATE cursor_exerc_02

/*
Cursores
Prática: Exercício 03
Crie um Cursor para listar a identificação do cliente, o seu nome, 
o número de locações atrasadas. Se o número de locações atrasadas superar 45% 
do número total de locações, apresentar também a mensagem "Atenção, cliente problemático".
DESAFIO: É possível resolver a prática 03 sem o uso de um cursor?
*/
SET NOCOUNT ON;

DECLARE cursor_exerc_03 CURSOR FOR

	SELECT
		id as clienteId,
		nome as cliente,
		locacoesAtrasadas = (
			SELECT	
				COUNT(*)
			FROM
				locacao
			WHERE
				clienteId = c.id
				AND dataDevolucao is null
		),
		totalLocacoes = (
			SELECT	
				COUNT(*)
			FROM
				locacao
			WHERE
				clienteId = c.id
		)
	FROM
		cliente c

	DECLARE @clienteId INT
	DECLARE @cliente VARCHAR(60)
	DECLARE @locacoesAtrasadas INT
	DECLARE @totalLocacoes INT

	OPEN cursor_exerc_03

	FETCH NEXT FROM
		cursor_exerc_03
	INTO
		@clienteId,
		@cliente,
		@locacoesAtrasadas,
		@totalLocacoes

	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @percAtrasados DECIMAL(10,2) = 0
		DECLARE @mensagem VARCHAR(100) = ''
		DECLARE @resultado VARCHAR(100) = ''

		IF (@totalLocacoes > 0 AND @locacoesAtrasadas > 0)
			SELECT @percAtrasados = (CAST(@locacoesAtrasadas AS DECIMAL(10,2)) / CAST(@totalLocacoes AS DECIMAL(10,2))) * 100

		IF (@percAtrasados > 45)
			SELECT @resultado = 'Atenção, cliente problemático'

		SELECT @mensagem = CONCAT(
			@clienteId, 
			' - ', 
			@cliente, 
			' - ',
			@locacoesAtrasadas,
			' - ',
			@totalLocacoes,
			' - ',
			@percAtrasados,
			' - ',
			@resultado)

		PRINT @mensagem

		FETCH NEXT FROM
			cursor_exerc_03
		INTO
			@clienteId,
			@cliente,
			@locacoesAtrasadas,
			@totalLocacoes
	END

CLOSE cursor_exerc_03
DEALLOCATE cursor_exerc_03