/*Lista de Exercícios utilizando a base de dados COMERCIO: Procedimentos e Funções.

# Procedimentos

1) Crie um procedimento que apresente o volume e o montante total de vendas por região e trimestre. */

GO
CREATE PROCEDURE Montante 
AS
BEGIN
	SELECT
		e.REGIAO, 
		FORMAT(SUM(nf.total), 'C', 'PT-BR') AS 'Montante Total',
		COUNT(distinct NF.IDNOTA) AS 'Volume de vendas',
		CASE DATEPART(QUARTER, nf.DATA) 
			 WHEN 1 THEN '1 Trimestre'   
			 WHEN 2 THEN '2 Trimestre' 
			 WHEN 3 THEN '3 Trimestre' 
			 WHEN 4 THEN '4 Trimestre' 
		END as 'Trimestre'
	FROM
		nota_fiscal nf
		JOIN
			cliente c on c.IDCLIENTE = nf.ID_CLIENTE
		JOIN
			endereco e on e.ID_CLIENTE = c.IDCLIENTE
	GROUP BY
		e.REGIAO,
		DATEPART(QUARTER, nf.DATA)
	ORDER BY 
		 1, 4
END;

DROP PROCEDURE Montante
EXEC Montante

/*

2) Crie um procedimento que apresente os top 10 clientes em volume de compras.
*/
GO
CREATE PROCEDURE Top10EmVolume 
AS
BEGIN
	SELECT TOP 10
		ROW_NUMBER() OVER(ORDER BY COUNT(NF.IDNOTA)desc ) AS Rank,
		C.IDCLIENTE,
		CONCAT(C.NOME, ' ', C.SOBRENOME),
		COUNT(NF.IDNOTA) AS 'Volume de compras'

	FROM
		NOTA_FISCAL NF
		JOIN
			CLIENTE C on  C.IDCLIENTE = NF.ID_CLIENTE
	GROUP BY
		C.NOME,
		C.IDCLIENTE,
		C.SOBRENOME
	ORDER BY
		COUNT(NF.IDNOTA) DESC

end;
exec Top10EmVolume
drop procedure Top10EmVolume
/*
3) Crie um procedimento que mostre os clientes que não realizaram nenhuma compra.
*/
GO
CREATE PROCEDURE ClientesSemCompras 
AS
BEGIN

	SELECT 
		CONCAT(NOME, ' ', SOBRENOME) AS 'Nome completo'
	FROM
		CLIENTE
	WHERE
		IDCLIENTE NOT IN(
			SELECT 
				NF.ID_CLIENTE
			FROM
				NOTA_FISCAL NF
			JOIN
				CLIENTE C ON C.IDCLIENTE = NF.ID_CLIENTE
		)
END;

EXEC ClientesSemCompras
drop procedure ClientesSemCompras

/*
4) Crie um procedimento que apresente o faturamento e o faturamento acumulado por ano.
*/
GO
CREATE PROCEDURE FaturamentoPAno 
AS
BEGIN
	SELECT
		YEAR(n.DATA) as 'Mes',
		FORMAT(SUM(n.total), 'C', 'PT-BR') AS 'Faturamento',
		'Faturamento Acumulado' = (
				SELECT 
					FORMAT(SUM(ns.total), 'C', 'PT-BR') AS 'Montante Total'
				FROM
					NOTA_FISCAL ns
				WHERE YEAR(ns.DATA) <= YEAR(N.DATA)
			   )
		FROM 
			NOTA_FISCAL N
		GROUP BY
			YEAR(N.DATA)
END;

DROP PROCEDURE FaturamentoPAno
EXEC FaturamentoPAno


/*
5) Crie um procedimento que apresente os cinco produtos mais caros por categoria (parâmetro de entrada) de produto.
*/

GO
CREATE PROCEDURE Top5ProdutosPCategoria (@NomeCategoria VARCHAR(50))
AS
BEGIN
	SELECT TOP 5
		ROW_NUMBER() OVER(ORDER BY max(P.VALOR) desc ) AS Rank,
		P.PRODUTO,
		C.NOME,
		FORMAT(max(P.VALOR), 'C', 'PT-BR') AS 'Valor'

	FROM
		PRODUTO P
		JOIN
			 CATEGORIA C ON C.IDCATEGORIA = P.ID_CATEGORIA
	WHERE 
		C.NOME = @NomeCategoria
	GROUP BY
		P.PRODUTO, 
		C.NOME
		
END;

DROP PROCEDURE Top5ProdutosPCategoria
EXEC Top5ProdutosPCategoria 'LIVROS'


/*


# Funções

1) Crie uma função que informado o sexo (M, F) como parâmetro retorne a sua descrição (Masculino, Feminino).
*/


CREATE FUNCTION FN_EXERCICIO_01(@sexo CHAR)
RETURNS VARCHAR(10)
AS
BEGIN
	RETURN IIF(@sexo  = 'F', 'Feminino', 'Masculino')
END;

SELECT dbo.FN_EXERCICIO_01('F')



/*
2) Crie uma função (multi-statement table-valued function) que apresente o volume e o montante total de compras com as informações do cliente (parâmetro de entrada, código do cliente), sendo:

- código;
- nome completo;
- data de nascimento (no formato PT_BR (DD/MM/YYYY);
- sexo (categorização -> M=Masculino; F=Feminino) utilize a função criada no exercício 01;
- cidade;
- estado; e
- região.

SELE
*/
		
CREATE FUNCTION udfContacts(@IDCliente int)
    RETURNS TABLE   
AS
RETURN(

		SELECT 
		ROW_NUMBER() OVER(ORDER BY COUNT(NF.IDNOTA)desc ) AS Rank,
		C.IDCLIENTE AS 'Id cliente',
		CONCAT(c.NOME, ' ', C.SOBRENOME) AS 'Nome completo',
		CONVERT(VARCHAR, c.NASCIMENTO, 103) AS 'Nascimento',
		(SELECT dbo.FN_EXERCICIO_01(C.SEXO)) AS 'Sexo',
		e.CIDADE,
		e.ESTADO,
		e.REGIAO,
		COUNT(NF.IDNOTA) AS 'Volume de compras',
		FORMAT(SUM(nf.total), 'C', 'PT-BR') AS 'Montante Total'
	FROM
		nota_fiscal nf
		JOIN
			cliente c on  c.IDCLIENTE = nf.ID_CLIENTE
		JOIN
			ENDERECO e on e.ID_CLIENTE = c.IDCLIENTE
	WHERE
		C.IDCLIENTE = @IDCliente
	GROUP BY
		CONCAT(c.NOME, ' ', C.SOBRENOME),
		C.IDCLIENTE,
		C.SEXO,
		C.IDCLIENTE,
		c.NASCIMENTO,
		e.CIDADE,
		e.ESTADO,
		e.REGIAO
)

SELECT * FROM udfContacts(2)

DROP FUNCTION udfContacts

/*
3) Crie uma função que informado uma data como parâmetro retorne o seu trimestre (1º TRI, 2º TRI, 3º TRI e 4º TRI).

*/

CREATE FUNCTION FN_EXERCICIO_03 (@DATA DATETIME)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @res VARCHAR(50)
	IF (DATEPART(QUARTER, @DATA) = 1)	
		SET @res ='Primeiro trimestre';
	ELSE IF DATEPART(QUARTER, @DATA) = 2	
		SET @res ='Segundo trimestre';
	ELSE IF DATEPART(QUARTER, @DATA) = 3	
		SET @res ='Terceiro trimestre';
	ELSE IF DATEPART(QUARTER, @DATA) = 4	
		SET @res ='Quarto trimestre';

	RETURN @res
END;

SELECT dbo.FN_EXERCICIO_03(getdate())
DROP FUNCTION FN_EXERCICIO_03



/*
4) Crie uma função (multi-statement table-valued function) que gere um relatório que apresente o ano e o trimestre, seguido das seguintes métricas:
- receita total;
- custo total;
- lucro total; e
- margem de lucro (bruta).

Fórmula = (Lucro / Receita total) * 100
	
Exemplo: 
(LUCRO = RECEITA_TOTAL - CUSTOS)
Fórmula = (Lucro / Receita total) * 100

- Receita total  : R$ 20.000
- Custos         : R$ 13.000
- Lucro          : R$ 20.000 - R$ 13.000 = R$ 7.000
- Margem de Lucro: R$ 7.000 / R$ 20.000  = 0.35 x 100 = 35%

A função deverá receber como parâmetro de entrada o ano e a percentual
da margem de lucro e deverá retornar somente os anos
e trimestres (utilize a função criada no exercício 03) 
cuja a lucratividade tenha alcançado um resultado superior ou igual a margem de lucro informada

*/

SELECT * FROM NOTA_FISCAL

CREATE FUNCTION Relatorio(@Ano int, @Margem int)
RETURNS TABLE
AS
RETURN(
		SELECT
			dbo.FN_EXERCICIO_03(nf.DATA) as 'Trimestre',
			FORMAT(SUM((ITN.TOTAL)), 'C', 'PT-BR') AS 'Receita total',
			FORMAT(sum((P.CUSTO_MEDIO * ITN.QUANTIDADE)), 'C', 'PT-BR') AS CUSTO,
			FORMAT(SUM((itN.TOTAL)) - sum((P.CUSTO_MEDIO * ITN.QUANTIDADE)), 'C', 'PT-BR') AS LUCRO,
			(((SUM((ITN.TOTAL)) - sum((P.CUSTO_MEDIO * ITN.QUANTIDADE))) / SUM((ITN.TOTAL))) * 100) AS MARGEM
		FROM 
			NOTA_FISCAL nF
		JOIN
			ITEM_NOTA ITN ON ITN.ID_NOTA_FISCAL = NF.IDNOTA
		JOIN
			PRODUTO P ON P.IDPRODUTO = ITN.ID_PRODUTO
		WHERE 
			year(nf.DATA) = 2015 
		GROUP BY
			dbo.FN_EXERCICIO_03(nf.DATA)
		HAVING 
			(((SUM((ITN.TOTAL)) - sum((P.CUSTO_MEDIO * ITN.QUANTIDADE))) / SUM((ITN.TOTAL))) * 100)  >= @Margem
	
			)
DROP FUNCTION Relatorio
SELECT * FROM Relatorio(2015, 20)
/*
A função deverá receber como parâmetro de entrada o ano e a percentual da margem de lucro e deverá retornar somente os anos e trimestres (utilize a função criada no exercício 03) cuja a lucratividade tenha alcançado um resultado superior ou igual a margem de lucro informada.

5) Crie uma função que informado duas datas (data inicial, data final) como parâmetro retorne a diferença em dias.
*/
CREATE FUNCTION TESTE( @InicialDate DATETIME, @FinalDate DATETIME)
RETURNS int
AS
BEGIN
	RETURN DATEDIFF(DAY,  @InicialDate, @FinalDate)
END

DROP FUNCTION TESTE

SELECT dbo.TESTE ( '28-07-2021 19:00:00.000', GETDATE())


/*
6) Crie uma função (multi-statement table-valued function) que informado o código do cliente apresente a matriz RFM (Recência, Frequência e Valor Monetário) do mesmo.

Tempo para retorno (R) - dias desde a última compra (utilize a função criada no exercício 05)
Frequência (F) - Número total de compras
Valor monetário (M) - quanto dinheiro total o cliente gastou.
*/

CREATE FUNCTION RFMPcliente(@IDCliente INT)
RETURNS TABLE
AS
RETURN(
	SELECT 
		 C.IDCLIENTE,
		 CONCAT(c.NOME, ' ', C.SOBRENOME) AS 'Nome completo',
		 dbo.TESTE(MAX(NF.DATA), GETDATE()) AS 'Tempo para retorno',
		 COUNT(NF.IDNOTA) 'Frequencia',
		 FORMAT(SUM((nf.TOTAL)), 'C', 'PT-BR') AS 'Total gasto'
	FROM 
		NOTA_FISCAL NF 
	JOIN 
		CLIENTE C ON C.IDCLIENTE = NF.ID_CLIENTE
	WHERE 
		C.IDCLIENTE = @IDCliente
	GROUP BY
		CONCAT(c.NOME, ' ', C.SOBRENOME), C.IDCLIENTE
)



DROP FUNCTION dbo.RFMPcliente
select  * from dbo.RFMPcliente(1)

