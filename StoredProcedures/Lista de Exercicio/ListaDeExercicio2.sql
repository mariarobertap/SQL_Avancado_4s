/*Lista de Exercícios utilizando a base de dados COMERCIO: Procedimentos e Funções.

# Procedimentos

1) Crie um procedimento que apresente o volume e o montante total de vendas por região e trimestre. */


SELECT
	e.REGIAO, 
	FORMAT(SUM(nf.total), 'C', 'PT-BR') AS 'Montante Total',
	COUNT(distinct NF.IDNOTA) AS 'Volume de vendas',
	CASE DATEPART(QUARTER, nf.DATA) 
		 WHEN 1 THEN '1 Trimestre'   
		 WHEN 2 THEN '2 Trimestre' 
		 WHEN 3 THEN '3 Trimestre' 
	END 
FROM
	nota_fiscal nf
	JOIN
		cliente c on nf.ID_CLIENTE = c.IDCLIENTE
	JOIN
		endereco e on e.ID_CLIENTE = c.IDCLIENTE
WHERE 
	DATEPART(QUARTER, nf.DATA) != 4
GROUP BY
	e.REGIAO,
	DATEPART(QUARTER, nf.DATA)
ORDER BY 
	 4


/*

2) Crie um procedimento que apresente os top 10 clientes em volume de compras.
*/

	SELECT TOP 10
		ROW_NUMBER() OVER(ORDER BY COUNT(NF.IDNOTA)desc ) AS Rank,
		COUNT(NF.IDNOTA) AS 'Volume de compras',
		c.NOME
	FROM
		nota_fiscal nf
		JOIN
			cliente c on nf.ID_CLIENTE = c.IDCLIENTE
	GROUP BY
		c.NOME


/*
3) Crie um procedimento que mostre os clientes que não realizaram nenhuma compra.
*/

SELECT 
	NOME
FROM
	CLIENTE
WHERE IDCLIENTE NOT IN(
	SELECT 
		NF.ID_CLIENTE
	FROM
		NOTA_FISCAL NF
	JOIN
		CLIENTE C ON C.IDCLIENTE = NF.ID_CLIENTE)


/*
4) Crie um procedimento que apresente o faturamento e o faturamento acumulado por ano.
*/

	select * from NOTA_FISCAL




	
	select
		SUM(total)
	from 
		NOTA_FISCAL
	GROUP BY
		YEAR(DATA)


	SELECT
		YEAR(n.DATA) as mes,
		FORMAT(SUM(n.total), 'C', 'PT-BR') AS 'Montante Total',
		vlrAcumulado = (
			SELECT 
				FORMAT(SUM(ns.total), 'C', 'PT-BR') AS 'Montante Total'
			FROM
				NOTA_FISCAL ns

			WHERE YEAR(ns.DATA) <= YEAR(N.DATA)
			)
		FROM 
			NOTA_FISCAL n
		GROUP BY
			YEAR(n.DATA)



/*
5) Crie um procedimento que apresente os cinco produtos mais caros por categoria (parâmetro de entrada) de produto.
*/


	SELECT top 5
		ROW_NUMBER() OVER(ORDER BY max(valor) desc ) AS Rank,
		P.PRODUTO, C.NOME, max(valor)
	FROM
		PRODUTO P
	JOIN
	 CATEGORIA C ON C.IDCATEGORIA = P.ID_CATEGORIA
	 group by P.PRODUTO, C.NOME

/*
# Funções

1) Crie uma função que informado o sexo (M, F) como parâmetro retorne a sua descrição (Masculino, Feminino).



2) Crie uma função (multi-statement table-valued function) que apresente o volume e o montante total de compras com as informações do cliente (parâmetro de entrada, código do cliente), sendo:

- código;
- nome completo;
- data de nascimento (no formato PT_BR (DD/MM/YYYY);
- sexo (categorização -> M=Masculino; F=Feminino) utilize a função criada no exercício 01;
- cidade;
- estado; e
- região.

3) Crie uma função que informado uma data como parâmetro retorne o seu trimestre (1º TRI, 2º TRI, 3º TRI e 4º TRI).

4) Crie uma função (multi-statement table-valued function) que gere um relatório que apresente o ano e o trimestre, seguido das seguintes métricas:

- receita total;
- custo total;
- lucro total; e
- margem de lucro (bruta).

Fórmula = (Lucro / Receita total) * 100
	
Exemplo: 
	
- Receita total  : R$ 20.000
- Custos         : R$ 13.000
- Lucro          : R$ 20.000 - R$ 13.000 = R$ 7.000
- Margem de Lucro: R$ 7.000 / R$ 20.000  = 0.35 x 100 = 35%

A função deverá receber como parâmetro de entrada o ano e a percentual da margem de lucro e deverá retornar somente os anos e trimestres (utilize a função criada no exercício 03) cuja a lucratividade tenha alcançado um resultado superior ou igual a margem de lucro informada.

5) Crie uma função que informado duas datas (data inicial, data final) como parâmetro retorne a diferença em dias.

6) Crie uma função (multi-statement table-valued function) que informado o código do cliente apresente a matriz RFM (Recência, Frequência e Valor Monetário) do mesmo.

Tempo para retorno (R) - dias desde a última compra (utilize a função criada no exercício 05)
Frequência (F) - Número total de compras
Valor monetário (M) - quanto dinheiro total o cliente gastou.
*/