

/*(1) Exiba a quantidade total de locações de um determinado filme. (Exibir o id, nome do filme
e quantidade de locações)
*/

GO
CREATE PROCEDURE QuantidadeLocacao 
@idFilme INT 
AS
	SELECT DISTINCT
		fi.id, fi.descricao, COUNT(fit.filmeId) 'Qtd Locações'
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

EXEC QuantidadeLocacao 1003

select * from filme

/*(02) Exiba todas as locações efetuadas por um determinando cliente. (Exibir o id, nome do
cliente e quantidade de locações)
*/
GO
CREATE PROCEDURE LocacaoPCliente 
@idCliente INT 
AS
	
	SELECT DISTINCT 
	c.id, c.nome, COUNT(l.fitaId) as 'Locações'
	FROM
		locacao l
	JOIN
		cliente c ON c.id = l.clienteId
	WHERE 
		c.id = @idCliente
	GROUP BY
		c.id, c.nome

EXEC LocacaoPCliente 1

/*
(03) Calcule o valor total de locações para as categorias de filme com base nas locações do
mês/ano (mês e ano serão parâmetros IN)
*/
GO
CREATE PROCEDURE LocacaoPanoEmes
@mes INT,
@ano INT 
AS

	IF((@mes <= 12 AND @mes >= 1))
	 begin
	 		SELECT DISTINCT 
			cat.descricao, SUM(fi.valor), COUNT(fit.filmeId) 'Locações'
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
	 else
	  select 'Data invalida'

DROP procedure LocacaoPanoEmes
select * from locacao
EXEC LocacaoPanoEmes 13, 2019




/*
(04) Listar quais clientes precisam devolver filmes.
*/
GO
CREATE PROCEDURE ClientesDevolucao
AS
	select distinct
		l.clienteId, c.nome, count(l.fitaId) 'Filmes a devolver'
	from 
		locacao l
	join cliente c on c.id = l.clienteId
	where l.dataDevolucao IS NULL
	group by l.clienteId, c.nome

EXEC ClientesDevolucao 

	
/*
(5) Listar quais filmes nunca foram locados.
*/
GO
CREATE PROCEDURE FilmesNuncaLocados
AS

	SELECT DISTINCT
		fi.id, fi.descricao
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
		 c.nome, MAX(l.dataLocacao)
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
		FI.descricao, COUNT(LO.fitaId) AS 'Locacoes',
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


