--Desafio cursor locadora
GO
CREATE PROCEDURE BonusAnual 
@year DATETIME
AS

		DECLARE cursor_desafio CURSOR FOR
			 SELECT DISTINCT 
			c.id,
			c.nome,
			COUNT(DISTINCT l.fitaId) as 'Locações',
			(
				SELECT DISTINCT 
					COUNT(DISTINCT l2.fitaId)
				FROM
					locacao l2
				WHERE YEAR(l2.dataLocacao) =  YEAR(@year) AND l2.dataDevolucao is null and c.id = l2.clienteId
			)  as 'A devolver',
			AVG(fi.valor) as 'Media'
		FROM
			locacao l 
		JOIN
			cliente c ON c.id = l.clienteId
		join	
			fita f on l.fitaId = f.id
		join
			filme fi on fi.id = f.filmeId
		WHERE YEAR(l.dataLocacao) = YEAR(@year)
			GROUP BY 
			c.nome, c.id, YEAR(l.dataLocacao)



	DECLARE @IdCliente    INT
	DECLARE @nomeCliente  VARCHAR(100)
	DECLARE @Locacoes     INT
	DECLARE @Devolver     INT
	DECLARE @ValorBonus   DECIMAL(10,2)


	
	OPEN cursor_desafio

	FETCH NEXT FROM
		cursor_desafio
	INTO
		@IdCliente,
		@nomeCliente,
		@Locacoes,
		@Devolver,
		@ValorBonus


	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF(@Locacoes > 3)
		BEGIN
			--IF(@Devolver <=1)
				PRINT CONCAT(@IdCliente, ' ', @nomeCliente, ' Valor bonus: ', @ValorBonus)
		END

		FETCH NEXT FROM
			cursor_desafio
		INTO
		@IdCliente,
		@nomeCliente,
		@Locacoes,
		@Devolver,
		@ValorBonus

	END

CLOSE cursor_desafio
DEALLOCATE cursor_desafio



declare @begindate datetime = CAST('2019-30-01 00:00:00.000' AS DATETIME)
EXEC BonusAnual @begindate


--Desafio cursor locadora
GO
CREATE PROCEDURE BonusAnual 
@year DATETIME
AS

		DECLARE cursor_desafio CURSOR FOR
			 SELECT DISTINCT 
			c.id,
			c.nome,
			COUNT(DISTINCT l.fitaId) as 'Locações',
			(
				SELECT DISTINCT 
					COUNT(DISTINCT l2.fitaId)
				FROM
					locacao l2
				WHERE YEAR(l2.dataLocacao) =  YEAR(@year) AND l2.dataDevolucao is null and c.id = l2.clienteId
			)  as 'A devolver',
			AVG(fi.valor) as 'Media'
		FROM
			locacao l 
		JOIN
			cliente c ON c.id = l.clienteId
		join	
			fita f on l.fitaId = f.id
		join
			filme fi on fi.id = f.filmeId
		WHERE YEAR(l.dataLocacao) = YEAR(@year)
			GROUP BY 
			c.nome, c.id, YEAR(l.dataLocacao)



	DECLARE @IdCliente    INT
	DECLARE @nomeCliente  VARCHAR(100)
	DECLARE @Locacoes     INT
	DECLARE @Devolver     INT
	DECLARE @ValorBonus   DECIMAL(10,2)


	
	OPEN cursor_desafio

	FETCH NEXT FROM
		cursor_desafio
	INTO
		@IdCliente,
		@nomeCliente,
		@Locacoes,
		@Devolver,
		@ValorBonus


	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF(@Locacoes > 3)
		BEGIN
			IF(@Devolver <=1)
				PRINT CONCAT(@IdCliente, ' ', @nomeCliente, ' Valor bonus: ', @ValorBonus)
		END

		FETCH NEXT FROM
			cursor_desafio
		INTO
		@IdCliente,
		@nomeCliente,
		@Locacoes,
		@Devolver,
		@ValorBonus

	END

CLOSE cursor_desafio
DEALLOCATE cursor_desafio



declare @begindate datetime = CAST('2019-30-01 00:00:00.000' AS DATETIME)
EXEC BonusAnual @begindate