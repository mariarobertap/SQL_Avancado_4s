/*
	lista
	Banco LOCADORA.bak
*/

/*(1) Exiba a quantidade total de locações de um determinado filme. (Exibir o id, nome do filme
e quantidade de locações)
*/

GO
CREATE PROCEDURE QuantidadeLocacao (@idFilme INT)
AS
	SELECT DISTINCT
		fi.id,
		fi.descricao,
		COUNT(l.fitaId) 'Qtd Locações'
	FROM
		locacao l
	JOIn
		fita fit ON fit.id = l.fitaId
	JOIN 
		filme fi ON fi.id = fit.filmeId
	WHERE 
		fi.id = @idFilme
	GROUP BY
		fi.descricao, fi.id

drop procedure QuantidadeLocacao
EXEC QuantidadeLocacao 2

select * from filme

/*(02) Exiba todas as locações efetuadas por um determinando cliente. (Exibir o id, nome do
cliente e quantidade de locações)
*/
GO
CREATE PROCEDURE LocacaoPCliente (@idCliente INT)
AS
	
	SELECT DISTINCT 
		c.id,
		c.nome,
		COUNT(l.fitaId) as 'Locações'
	FROM
		locacao l
	JOIN
		cliente c ON c.id = l.clienteId
	WHERE 
		c.id = @idCliente
	GROUP BY
		c.id, c.nome

EXEC LocacaoPCliente 3

/*
(03) Calcule o valor total de locações para as categorias de filme com base nas locações do
mês/ano (mês e ano serão parâmetros IN)
*/
GO
CREATE PROCEDURE LocacaoPanoEmes (@mes INT, @ano INT)
AS
BEGIN
	IF((@mes <= 12 AND @mes >= 1) AND (@ANO <= 9999 AND @ANO >= 1000))
		 begin
	 			SELECT DISTINCT 
				cat.descricao,
				SUM(fi.valor) AS 'Total',
				COUNT(fit.filmeId) 'Locações'
			FROM
				locacao l
				JOIN 
					fita fit ON fit.id = l.fitaId
				JOIN 
					filme fi ON fi.id = fit.filmeId
				JOIN 
					categoria cat ON cat.id = fi.categoriaId
			where
				month(l.dataLocacao) = @mes and year(l.dataLocacao) = @ano
			GROUP BY
				cat.descricao
		 end
	 ELSE
		 select 'Data invalida'
END;

DROP procedure LocacaoPanoEmes
select * from locacao
EXEC LocacaoPanoEmes 11, 2019




/*
(04) Listar quais clientes precisam devolver filmes.
*/
GO
CREATE PROCEDURE ClientesDevolucao
AS
BEGIN
	SELECT DISTINCT 
		l.clienteId,
		c.nome,
		count(l.fitaId) 'Filmes a devolver'
	from 
		locacao l
		join cliente c on c.id = l.clienteId
	where 
		l.dataDevolucao IS NULL
	group by
		l.clienteId, c.nome
END;
DROP PROCEDURE ClientesDevolucao

EXEC ClientesDevolucao 

	
/*
(5) Listar quais filmes nunca foram locados.
*/
GO
CREATE PROCEDURE FilmesNuncaLocados
AS

	SELECT DISTINCT
		fi.id,
		fi.descricao
	FROM
		filme fi
	where 
		fi.id NOT IN (	SELECT 
							fi.id
						FROM
							fita fit
						JOIN 
							filme fi ON fi.id = fit.filmeId
						JOIN 
							locacao l ON l.fitaId = fit.id
					  )
DROP procedure FilmesNuncaLocados

EXEC FilmesNuncaLocados 
		
/*
(06) Listar quais clientes nunca efetuaram uma locação.
*/
GO
CREATE PROCEDURE NuncaLocou
AS

	select 
		* 
	from 
		cliente c 
	where 
		c.id NOT IN (SELECT clienteId FROM locacao)


EXEC NuncaLocou 


/*
(07) Listar a data da última locação de um determinado cliente.
*/
GO
CREATE PROCEDURE UltimaLocacao
@idCliente INT 
AS
	SELECT
		 c.id,
		 c.nome,
		 MAX(l.dataLocacao)
	FROM 
		cliente c 
	join
		locacao l on l.clienteId = c.id
	WHERE 
		@idCliente = c.id
	group by
		c.nome

EXEC UltimaLocacao 2

/*
(08) Calcule o valor total de locações e o valor total de locações acumulado por mês (ano será 
parâmetro IN)
*/


		SELECT
			ISNULL([Janeiro], 0) AS Janeiro,
			ISNULL([Fevereiro], 0) AS Fevereiro,
			ISNULL([Março], 0) AS MARÇO,
			ISNULL([Abril],0) AS ABRIL,
			ISNULL([Maio], 0) AS MAIO,
			ISNULL([Junho], 0) AS JUNHO,
			ISNULL([Julho], 0) AS JULHO,
			ISNULL([Agosto], 0) AS AGOSTO,
			ISNULL([Setembro],0) AS SETEMBRO,
			ISNULL([Outubro], 0) AS OUTUBRO,
			ISNULL([Novembro], 0) AS NOVEMBRO,
			ISNULL([Dezembro], 0) AS DEZEMBRO
		
	FROM (
		select 
			f.valor, DATENAME(month,lo.dataLocacao) as [Month]
		from
			locacao lo
		join
			fita fi on fi.id = lo.fitaId
		join
			filme f on f.id = fi.filmeId
	) AS SOURCE
	PIVOT(
		sum(valor)
		FOR [Month] in ([Janeiro], [Fevereiro], [Março], [Abril], [Maio], [Junho], [Julho], [Agosto], [Setembro], [Outubro], [Novembro], [Dezembro] )
	) AS PVT


	SELECT
		MONTH(l.dataLocacao) as mes,
		SUM(f.valor) as vlrTotal,
		vlrAcumulado = (
			SELECT 
				sum(fs.valor)
			FROM
				locacao ls
			JOIN 
				fita fts on fts.id = ls.fitaId
			JOIN
				filme fs on fs.id = fts.filmeId

			WHERE MONTH(ls.dataLocacao) <= MONTH(l.dataLocacao)
			)
		FROM 
			locacao l
		JOIN
			fita ft on ft.id = l.fitaId
		JOIN
			filme f on f.id = ft.filmeId
		WHERE
			YEAR(l.dataLocacao) = 2019
		GROUP BY
			MONTH(l.dataLocacao)


/*09) Listar a quantidade de locações por categoria de filme. Exibir cada categoria de filme sendo 
uma coluna. (Conceito Pivot Table)
*/

	SELECT
		[Ação],
		[Terror],
		[Comédia],
		[Drama],
		[Ficção Científica]
		
	FROM (
		SELECT DISTINCT 
			cat.descricao,
			fit.filmeId
		FROM
			locacao l
		JOIN 
			fita fit ON fit.id = l.fitaId
		JOIN 
			filme fi ON fi.id = fit.filmeId
		JOIN 
			categoria cat ON cat.id = fi.categoriaId
	) AS SOURCE
	PIVOT(
		COUNT(filmeId)
		FOR descricao in ([Ação], [Terror], [Comédia], [Drama], [Ficção Científica])
	) AS PVT
	

/*10) DESAFIO: Listar o ranking de filmes mais locados. (Conceito de Rank
*/

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

--https://www.sqlshack.com/overview-of-sql-rank-functions/

-------------------------------------------------------------------




--Utilizando o BD LOCADORA crie as seguintes Functions:
/*
01) Crie uma função que informado um valor retorne uma string informando se o número é
par ou ímpar.
*/
CREATE FUNCTION FN_EXERCICIO_01(@valor INT)
RETURNS VARCHAR(10)
AS
BEGIN
	RETURN IIF(@valor % 2 > 0, 'Impar', 'Par')
END;

SELECT dbo.FN_EXERCICIO_01(1)
SELECT dbo.FN_EXERCICIO_01(2)
/*
02) Crie uma função que retorne o número mais o nome do mês em português (1 - Janeiro) de
acordo com o parâmetro informado que deve ser uma data. Para testar, crie uma consulta que
retorne o cliente e mês de locação (número e nome do mês).
*/
CREATE FUNCTION FN_EXERCICIO_02(@data DATETIME)
RETURNS VARCHAR(20)
AS
BEGIN
	RETURN CONCAT(MONTH(@data), ' - ', UPPER(DATENAME(MONTH, @data)))
END;

SET LANGUAGE Portuguese;
SELECT dbo.FN_EXERCICIO_02(GETDATE())

SELECT
	l.clienteId,
	c.nome as cliente,
	l.dataLocacao,
	dbo.FN_EXERCICIO_02(l.dataLocacao) as mes
FROM
	locacao l
	join cliente c
		on c.id = l.clienteId

/*
03) Crie uma função que retorne o número mais o nome do dia da semana em português (1 -
Domingo), como parâmetro de entrada receba uma data. Para testar, crie uma consulta que
retorne o código do cliente, o nome do cliente e dia da semana da locação utilizando a função
criada.
*/
CREATE FUNCTION FN_EXERCICIO_03(@data DATETIME)
RETURNS VARCHAR(20)
AS
BEGIN
	RETURN CONCAT(DATEPART(WEEKDAY, @data), ' - ', DATENAME(WEEKDAY, @data))
END

SELECT dbo.FN_EXERCICIO_03(GETDATE())

SELECT
	l.clienteId,
	c.nome as cliente,
	l.dataLocacao,
	dbo.FN_EXERCICIO_03(l.dataLocacao) as diaSemana
FROM
	locacao l
	join cliente c
		on c.id = l.clienteId

SELECT
	dbo.FN_EXERCICIO_03(l.dataLocacao) as diaSemana,
	COUNT(*) as qtde
FROM
	locacao l
GROUP BY
	dbo.FN_EXERCICIO_03(l.dataLocacao)
ORDER BY
	1

/*
04) Crie uma função para retornar o gentílico dos clientes de acordo com o estado onde
moram (gaúcho, catarinense ou paranaense), o parâmetro de entrada deve ser a sigla do
estado. Para testar a função crie uma consulta que liste o nome do cliente e gentílico
utilizando a função criada.
*/
CREATE FUNCTION FN_EXERCICIO_04(@uf CHAR(2))
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @gentilico VARCHAR(20)
	
	SET @gentilico = 
	CASE @uf
		WHEN 'PR' THEN 'paranaense'
		WHEN 'SC' THEN 'catarinese'
		WHEN 'RS' THEN 'gaúcho'
		ELSE 'não informado'
	END
		
	RETURN @gentilico
END

SELECT dbo.FN_EXERCICIO_04('RS')

UPDATE cliente SET estado = 'SC' WHERE id not in(1, 2)

SELECT 
	nome as cliente,
	dbo.FN_EXERCICIO_04(estado) as gentilico
FROM 
	cliente

/*
05) Crie uma função que retorne o CPF do cliente no formato ###.###.###-##. Para testar a
função criada exiba os dados do cliente com o CPF formatado corretamente utilizando a
função criada.
*/
CREATE FUNCTION FN_EXERCICIO_05(@cpf VARCHAR(11))
RETURNS VARCHAR(14)
AS
BEGIN
	RETURN CONCAT(
		LEFT(@cpf, 3), 
		'.', 
		SUBSTRING(@cpf, 4, 3), 
		'.', 
		SUBSTRING(@cpf, 7, 3), 
		'-', 
		RIGHT(@cpf, 2)
	)
END;

SELECT dbo.FN_EXERCICIO_05('71026854083')

SELECT 
	nome as cliente,
	dbo.FN_EXERCICIO_05(cpf) as cpf
FROM 
	cliente

/*
06) Crie uma função que faça a comparação entre dois números inteiros. Caso os dois números
sejam iguais a saída deverá ser “x é igual a y”, no qual x é o primeiro parâmetro e y o segundo
parâmetro. Se x for maior, deverá ser exibido “x é maior que y”. Se x for menor, deverá ser
exibido “x é menor que y”.
*/
CREATE FUNCTION FN_EXERCICIO_06(@x INT, @y INT)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @res VARCHAR(20)

	IF (@x = @y)
		SET @res = 'x é igual a y'
	ELSE IF (@x > @y)
			SET @res = 'x é maior que y'
		ELSE
			SET @res = 'x é menor que y'

	RETURN @res
END

SELECT dbo.FN_EXERCICIO_06(15, 10)
SELECT dbo.FN_EXERCICIO_06(10, 10)
SELECT dbo.FN_EXERCICIO_06(5, 10)

/*
07) Crie uma função que calcule a fórmula de Bhaskara. Como parâmetro de entrada devem
ser recebidos 3 valores (a, b e c). Ao final a função deve retornar “Os resultados calculados são
x e y”, no qual x e y são os valores calculados.
*/
CREATE FUNCTION FN_EXERCICIO_07(@a INT, @b INT, @c INT)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @x INT;
	DECLARE @y INT;
	DECLARE @delta FLOAT;

	SET @delta = (@b * @b) - (4 * @a * @c)

	SET @x = (-@b + SQRT(@delta)) / (2 * @a);
	SET @y = (-@b - SQRT(@delta)) / (2 * @a);

	RETURN CONCAT('Os resultados calculados são x e y: ', @x, ', ', @y) 
END;

SELECT dbo.FN_EXERCICIO_07(1, 5, 4)

/*
08) Crie uma função que informado a data de nascimento como parâmetro retorne a idade da
pessoa em anos.
*/
CREATE FUNCTION FN_EXERCICIO_08(@data DATE)
RETURNS INT
AS
BEGIN
	RETURN FLOOR(DATEDIFF(DAY, @data, GETDATE()) / 365.25)
END

SELECT dbo.FN_EXERCICIO_08('1986-05-22')

/*
09) Faça uma função que retorna o código do cliente com a maior quantidade de locações por 
ano/mês. Observe que a função deverá receber como parâmetros um ano e um mês. Deve ser 
exibido a seguinte expressão: “O cliente XXXXXXX (cód) – XXXXXXX (nome) foi o cliente que fez 
a maior quantidade de locações no ano XXXX mês XX com um total de XXX locações”. 
*/
CREATE FUNCTION FN_EXERCICIO_09(@ano INT, @mes INT)
RETURNS VARCHAR(200)
AS
BEGIN
	DECLARE @id INT
	DECLARE @nome VARCHAR(100)
	DECLARE @qtdeLocacoes INT

	SELECT TOP 1
		@id = c.id,
		@nome = c.nome,
		@qtdeLocacoes = COUNT(*)
	FROM
		locacao l
		join cliente c
			on c.id = l.clienteId
	WHERE
		YEAR(dataLocacao) = @ano
		AND MONTH(dataLocacao) = @mes
	GROUP BY
		c.id,
		c.nome
	ORDER BY
		3 DESC

	RETURN CONCAT(
		'O cliente ', @id ,' – ', @nome, 
		' foi o cliente que fez a maior quantidade de locações no ano ', @ano, ' no mês ', @mes, 
		' com um total de ', @qtdeLocacoes, ' locações.')

END

SELECT dbo.FN_EXERCICIO_09(2019, 11)
