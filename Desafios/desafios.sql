/*
DESAFIO: Crie uma função que receba um número de CPF sem separadores xxxxxxxxxxx (11 dígitos)
e verifique se o número é um CPF válido ou não. Caso seja um CPF válido retorne o mesmo formatado corretamente
xxx.xxx.xxx-xx, caso não seja válido, retorne a frase “O CPF digitado é inválido”.

Inserir o DDL da sentença SQL com a criação da Function e chamada de execução.*/

CREATE FUNCTION verificaCPF(
    @Nr_Documento VARCHAR(11)
)
RETURNS VARCHAR(50)
BEGIN
 
    DECLARE
        @count1 INT,
        @count2 INT,
        @digito1 INT,
        @digito2 INT,
        @bufferAux VARCHAR(11),
		@bufferAux2 VARCHAR(20)
 
    SET @bufferAux = LTRIM(RTRIM(@Nr_Documento))
    SET @digito1 = 0
 
 
    IF (@bufferAux IN ('00000000000', '11111111111', '22222222222', '33333333333', '44444444444', '55555555555', '66666666666', '77777777777', '88888888888', '99999999999', '12345678909'))
         RETURN 'O CPF digitado é inválido'
 
 
    IF (LEN(@bufferAux) <> 11)
        RETURN 'O CPF digitado é inválido'
    ELSE 
    BEGIN
 
        SET @bufferAux = SUBSTRING(@bufferAux, 1, 9)
 
        SET @count1 = 2
 
        WHILE (@count1 < = 10)
        BEGIN 
            SET @digito1 = @digito1 + (@count1 * CAST(SUBSTRING(@bufferAux, 11 - @count1, 1) as int))
            SET @count1 = @count1 + 1
        end 
 
        SET @digito1 = @digito1 - (@digito1/11)*11
 
        IF (@digito1 <= 1)
            SET @digito1 = 0
        ELSE 
            SET @digito1 = 11 - @digito1
 
        SET @bufferAux = @bufferAux + CAST(@digito1 AS VARCHAR(1))
 
        IF (@bufferAux <> SUBSTRING(@Nr_Documento, 1, 10))
             RETURN 'O CPF digitado é inválido'
        ELSE BEGIN 
        
            SET @digito2 = 0
            SET @count2 = 2
 
            WHILE (@count2 < = 11)
            BEGIN 
                SET @digito2 = @digito2 + (@count2 * CAST(SUBSTRING(@bufferAux, 12 - @count2, 1) AS INT))
                SET @count2 = @count2 + 1
            end 
 
            SET @digito2 = @digito2 - (@digito2/11)*11
 
            IF (@digito2 < 2)
                SET @digito2 = 0
            ELSE 
                SET @digito2 = 11 - @digito2
 
            SET @bufferAux = @bufferAux + CAST(@digito2 AS VARCHAR(1))
 
            IF (@bufferAux <> @Nr_Documento)
                RETURN 'O CPF digitado é inválido'
                
        END
    END 
	
	
	
	SET @bufferAux2 = CONCAT(SUBSTRING(@Nr_Documento, 1, 3),
									'.',SUBSTRING(@Nr_Documento, 4, 3),
									'.', SUBSTRING(@Nr_Documento, 7, 3),
									'-' , SUBSTRING(@Nr_Documento, 10, 2))




    RETURN @bufferAux2
    
END

SELECT dbo.verificaCPF('11111111111')  

/*10) DESAFIO: Listar o ranking de filmes mais locados. (Conceito de Rank
*/




CREATE PROCEDURE FilmeRank
AS
	SELECT 
		FI.descricao,
		COUNT(LO.fitaId) AS 'Locacoes',
		ROW_NUMBER() OVER(ORDER BY COUNT(LO.fitaId)desc ) AS Rank
	FROM 
		filme fi 
	JOIN
		fita ft ON ft.filmeId = fi.id
	JOIN 
		locacao lo ON lo.fitaId = ft.id
	GROUP BY
		fi.descricao

EXEC FilmeRank 

/*
9) Crie uma indexed view para exibir o volume orders completed (volume de pedidos concluídos),
a revenue (receita), o discounts (total de descontos) e a percentage discounts 
(percentual de descontos) por ano e trimestre.
*/

CREATE VIEW sales.ivw_getPercentageOFFByquarter
WITH SCHEMABINDING
AS
SELECT 
	tab.volumn as 'Volume' ,
	FORMAT(tab.amount,  'C', 'PT-BR') 'Total amount (revenue)',
	FORMAT(tab.disc,   'C', 'PT-BR') 'Total discounts',
	CONVERT(VARCHAR(6),CAST(ROUND((tab.disc / tab.amount *100), 2) AS DECIMAL(18,2))) + '%' 'Percent OFF',
	tab.year AS 'Year',
	tab.trimestre AS 'Quarter'
	
FROM(
	SELECT 
		count(DISTINCT o.order_id) AS volumn,
		SUM((s.quantity * s.list_price) * (1 - s.discount)) AS amount,
		SUM(((s.list_price * s.quantity)  * s.discount)) AS disc,
		YEAR(o.order_date) AS year,
		DATEPART(QUARTER, o.order_date) as trimestre
	FROM 
		sales.orders o
	JOIN
		sales.order_items s ON o.order_id = s.order_id
	JOIN
		production.products p ON s.product_id = p.product_id
	WHERE
		o.order_status = 4 
	GROUP BY
		YEAR(o.order_date),
		DATEPART(QUARTER, o.order_date)

)  AS tab
ORDER BY 
	tab.year,
	tab.trimestre