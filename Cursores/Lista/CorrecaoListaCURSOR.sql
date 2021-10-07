/*
Excercio 01 - Cursores
Criar um cursor para selecionar o nome e valor do filme. Caso o valor do filme seja inferior ou igual a
R$ 12,00, mostrar o nome do filme, o valor atual e o valor com 10% de aumento. Se o valor
do filme for superior a R$ 12,00 mostrar o nome do filme, o valor atual e valor com 15% de
aumento.
*/
DECLARE cursor_exerc_01 CURSOR FOR

	SELECT 
		id as filmeId,
		descricao as filme,
		valor
	FROM 
		filme

	DECLARE @filmeId INT,
			@filme VARCHAR(100),
			@valor DECIMAL(10, 2)

	OPEN cursor_exerc_01

	FETCH NEXT FROM
		cursor_exerc_01
	INTO
		@filmeId,
		@filme,
		@valor

	WHILE @@FETCH_STATUS = 0
	BEGIN
		/* --FORMA 01 
		DECLARE @vl_aumento DECIMAL(10, 2) = 0
		DECLARE @mensagem VARCHAR(200) = ''
		SET @vl_aumento = IIF(@valor <= 12, @valor * 1.10, @valor * 1.15)
		SET @mensagem = CONCAT(@filmeId, '-', @filme, ' R$ ', @valor, ' R$ ', @vl_aumento)
		PRINT @mensagem
		*/

		/* --FORMA 02
		IF (@valor <= 12)
			PRINT CONCAT(@filmeId, '-', @filme, ' R$ ', @valor, ' R$ ', @valor * 1.10)
		ELSE
			PRINT CONCAT(@filmeId, '-', @filme, ' R$ ', @valor, ' R$ ', @valor * 1.15)
		*/
		
		PRINT CONCAT(@filmeId, '-', @filme, ' R$ ', @valor, ' R$ ', IIF(@valor <= 12, @valor * 1.10, @valor * 1.15))

		FETCH NEXT FROM
			cursor_exerc_01
		INTO
			@filmeId,
			@filme,
			@valor
	END

CLOSE cursor_exerc_01
DEALLOCATE cursor_exerc_01

/*
Excercio 02 - Cursores
Criar um cursor para selecionar a data e o valor de locação. Caso o valor da locação seja
superior a R$ 12,00, mostrar a data, valor da locação e valor com 10% de desconto. Se o
valor da locação for inferior ou igual a R$ 12,00 mostrar todos os dados, mas com o valor de
desconto de 8%.
*/
SET NOCOUNT OFF

DECLARE cursor_exerc_02 CURSOR FOR
	
	SELECT 
		FORMAT(l.dataLocacao, 'dd/MM/yyyy') AS data,
		f.valor
	FROM 
		locacao l
		join fita ft
			on ft.id = l.fitaId
		join filme f
			on f.id = ft.filmeId

	DECLARE @data VARCHAR(10),
			@valor DECIMAL(10,2)

	DECLARE @table TABLE(
		data VARCHAR(10),
		valor DECIMAL(10,2),
		vl_desconto DECIMAL(10,2)
	)

	OPEN cursor_exerc_02

	FETCH NEXT FROM 
		cursor_exerc_02 
	INTO 
		@data, 
		@valor

	WHILE @@FETCH_STATUS = 0
	BEGIN
		/* --FORMA 01
		--PRINT CONCAT(@data, ' ', @valor, ' ', IIF(@valor > 12, @valor * 0.9, @valor * 0.8))
		*/

		--FORMA 02
		INSERT INTO 
			@table
		SELECT
			@data,
			@valor,
			IIF(@valor > 12, @valor * 0.9, @valor * 0.8)

		FETCH NEXT FROM 
			cursor_exerc_02 
		INTO 
			@data, 
			@valor
	END

CLOSE cursor_exerc_02
DEALLOCATE cursor_exerc_02

--FORMA 02
SELECT * FROM @table