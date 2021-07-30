

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

	select 
		sum(f.valor), month(lo.dataLocacao)
	from
		locacao lo
	join
		fita fi on fi.id = lo.fitaId
	join
		filme f on f.id = fi.filmeId
	group by month(lo.dataLocacao)
	--where month(lo.dataLocacao) = 1
	
	
