/*
DESAFIO: Crie uma função que receba um número de CPF sem separadores xxxxxxxxxxx (11 dígitos)
e verifique se o número é um CPF válido ou não. Caso seja um CPF válido retorne o mesmo formatado corretamente
xxx.xxx.xxx-xx, caso não seja válido, retorne a frase “O CPF digitado é inválido”.

Inserir o DDL da sentença SQL com a criação da Function e chamada de execução.*/

CREATE FUNCTION [dbo].[fncValida_CPF](
    @Nr_Documento VARCHAR(11)
)
RETURNS VARCHAR(50)
BEGIN
 
    DECLARE
        @Contador_1 INT,
        @Contador_2 INT,
        @Digito_1 INT,
        @Digito_2 INT,
        @Nr_Documento_Aux VARCHAR(11),
		@Nr_Documento_Aux2 VARCHAR(20)
 
    -- Remove espaços em branco
    SET @Nr_Documento_Aux = LTRIM(RTRIM(@Nr_Documento))
    SET @Digito_1 = 0
 
 
    -- Remove os números que funcionam como validação para CPF, pois eles "passam" pela regra de validação
   -- IF (@Nr_Documento_Aux IN ('00000000000', '11111111111', '22222222222', '33333333333', '44444444444', '55555555555', '66666666666', '77777777777', '88888888888', '99999999999', '12345678909'))
         --RETURN 'O CPF digitado é inválido'
 
 
    -- Verifica se possui apenas 11 caracteres
    IF (LEN(@Nr_Documento_Aux) <> 11)
        RETURN 'O CPF digitado é inválido'
    ELSE 
    BEGIN
 
        -- Cálculo do segundo dígito
        SET @Nr_Documento_Aux = SUBSTRING(@Nr_Documento_Aux, 1, 9)
 
        SET @Contador_1 = 2
 
        WHILE (@Contador_1 < = 10)
        BEGIN 
            SET @Digito_1 = @Digito_1 + (@Contador_1 * CAST(SUBSTRING(@Nr_Documento_Aux, 11 - @Contador_1, 1) as int))
            SET @Contador_1 = @Contador_1 + 1
        end 
 
        SET @Digito_1 = @Digito_1 - (@Digito_1/11)*11
 
        IF (@Digito_1 <= 1)
            SET @Digito_1 = 0
        ELSE 
            SET @Digito_1 = 11 - @Digito_1
 
        SET @Nr_Documento_Aux = @Nr_Documento_Aux + CAST(@Digito_1 AS VARCHAR(1))
 
        IF (@Nr_Documento_Aux <> SUBSTRING(@Nr_Documento, 1, 10))
             RETURN 'O CPF digitado é inválido'
        ELSE BEGIN 
        
            -- Cálculo do segundo dígito
            SET @Digito_2 = 0
            SET @Contador_2 = 2
 
            WHILE (@Contador_2 < = 11)
            BEGIN 
                SET @Digito_2 = @Digito_2 + (@Contador_2 * CAST(SUBSTRING(@Nr_Documento_Aux, 12 - @Contador_2, 1) AS INT))
                SET @Contador_2 = @Contador_2 + 1
            end 
 
            SET @Digito_2 = @Digito_2 - (@Digito_2/11)*11
 
            IF (@Digito_2 < 2)
                SET @Digito_2 = 0
            ELSE 
                SET @Digito_2 = 11 - @Digito_2
 
            SET @Nr_Documento_Aux = @Nr_Documento_Aux + CAST(@Digito_2 AS VARCHAR(1))
 
            IF (@Nr_Documento_Aux <> @Nr_Documento)
                RETURN 'O CPF digitado é inválido'
                
        END
    END 
	
	
	




    RETURN @Nr_Documento_Aux2
    
END

SELECT CONCAT('123', '.', '123', '.', '-', '123')
DROP FUNCTION dbo.fncValida_CPF

SELECT dbo.fncValida_CPF('11111111111')  

/*10) DESAFIO: Listar o ranking de filmes mais locados. (Conceito de Rank
*/

	SELECT 
		FI.descricao,
		COUNT(LO.fitaId) AS 'Locacoes',

	FROM 
		filme fi 
	JOIN
		fita ft ON ft.filmeId = fi.id
	JOIN 
		locacao lo ON lo.fitaId = ft.id
	GROUP BY
		fi.descricao

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
	tab.year AS 'Year',
	tab.trimestre AS 'Quarter'
	
FROM(
	SELECT 
		count(DISTINCT o.order_id) AS volumn,
		SUM((s.quantity * s.list_price) * (1 - s.discount)) AS amount,

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