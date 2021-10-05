/*
	Desafio indexed view
	Banco LOCADORA.bak
*/

--Funções com retorno de tabela
--Função que retorna a diferença em minutos de duas datas diferentes
CREATE FUNCTION FN_DATA_MINUTOS(@Min INT, @InicialDate DATETIME, @FinalDate DATETIME)
RETURNS @TABLE TABLE(DATA DATETIME)
AS
BEGIN

	WHILE @InicialDate <= @FinalDate
	BEGIN
		INSERT INTO @TABLE VALUES (@InicialDate)
		SET @InicialDate = DATEADD(MINUTE, @Min, @InicialDate)
	END
	RETURN 
END

SELECT * FROM FN_DATA_MINUTOS (60, '28-07-2021 19:00:00.000', GETDATE())


--Criando uma função que retorna as locações a partir de uma data
CREATE FUNCTION locadosEM(@DATA DATETIME)
RETURNS TABLE
AS 
RETURN(
		SELECT * FROM locacao 
		WHERE dataLocacao >= @DATA
		)

SELECT * FROM locadosEM('28-01-2019 19:00:00.000')


