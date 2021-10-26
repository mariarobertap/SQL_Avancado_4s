CREATE FUNCTION udfContacts()
    RETURNS @data TABLE (
        SEQUENCIAL_ID int,
        DATE_ID VARCHAR(8),
        PERIODO_ID VARCHAR(255),
		CURSO_ID varchar(3),
        CURSO VARCHAR(25),
        QUANTIDADE int
    )
AS
BEGIN
	DECLARE @beginDate DATETIME,
			@endDate DATETIME,
			@maxDate DATETIME,
			@COUNT int	
	
	
	SET @maxDate = (SELECT MAX(DATA_ID) FROM desafio_cursor)
	SET @COUNT = 1
	SET @beginDate = (SELECT MIN(DATA_ID) FROM desafio_cursor)
	SET @endDate = DATEADD(YEAR, 1, @beginDate)
	SET @endDate = DATEADD(DAY, 2, @endDate)

	WHILE ( @beginDatE != @maxDate)
	BEGIN
		
		DECLARE curteste CURSOR FOR
			SELECT 
				DATA_ID,
				PERIODO_ID, 
				CURSO_ID,
				CURSO,
				COUNT(CURSO_ID)
			FROM 
				desafio_cursor
			WHERE 
				CONVERT(DATETIME, DATA_ID) IN(@beginDate, @endDate)
			GROUP BY
				DATA_ID,
				PERIODO_ID, 
				CURSO_ID,
				CURSO


			DECLARE
				@DATA_ID VARCHAR(8),
			    @PERIODO_ID VARCHAR(6),
			    @CURSO_ID VARCHAR(3),
				@CURSO VARCHAR(20),
				@QUANTIDADE INT

			OPEN curteste

			FETCH NEXT FROM
				curteste
			INTO
				@DATA_ID,
				@PERIODO_ID,
				@CURSO_ID,
				@CURSO,
				@QUANTIDADE


			WHILE @@FETCH_STATUS = 0
			BEGIN

			    INSERT INTO @data values (@COUNT, @DATA_ID, @PERIODO_ID, @CURSO_ID, @CURSO, @QUANTIDADE) 

				FETCH NEXT FROM
					curteste
				INTO
					@DATA_ID,
					@PERIODO_ID,
					@CURSO_ID,
					@CURSO,
					@QUANTIDADE			 

			END

		CLOSE curteste
		DEALLOCATE curteste
		SET @beginDate = DATEADD(DAY, 1, @beginDate)
		SET @endDate = DATEADD(YEAR, 1, @beginDate)
		SET @endDate = DATEADD(DAY, 2, @endDate)
		SET @COUNT = @COUNT + 1
		

	END;
    RETURN;
END;

DROP FUNCTION udfContacts 

SELECT 
	*
FROM 
	udfContacts() 
WHERE 
	SEQUENCIAL_ID <= 10 
ORDER BY
	1, 2 




