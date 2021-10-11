
/*
	lista
	Banco LOCADORA.bak
*/

/*liste os filmes e a quantidade
de vezes que cada filme foi locado.*/

GO
CREATE PROCEDURE BuscaPorCategoria 
@Categoria VARCHAR (30) 
AS
SELECT 
	 l.fitaId, count(f.id) as 'Qtd locação', fi.descricao, c.descricao
FROM 
	locacao l 
		join fita f on f.id = l.fitaId
		join filme fi on fi.id = f.filmeId
		join categoria c on c.id = fi.categoriaId
		--where c.descricao = @Categoria
group by l.fitaId, fi.descricao,  c.descricao

EXEC BuscaPorCategoria 'Comédia'

/*Crie uma SP que altere o status do cliente*/ 

GO
CREATE PROCEDURE UpdateStatusCliente 
@status int,
@id_cliente int 
AS
	IF @status <= 1 AND @id_cliente <= (select count(id) from cliente)
		begin
		UPDATE cliente SET ativo = @status where id = @id_cliente
		select id, ativo, nome, 'Sucesso' from cliente where id = @id_cliente
		end;
	ELSE
		SELECT 'Opa! algo esta errado'

	
drop procedure UpdateStatusCliente

select * from cliente
EXEC UpdateStatusCliente 1, 2

GO 


/*exiba a quantidade de
filmes locados, agrupadas por ano, mês e
dia.*/

GO
CREATE PROCEDURE buscarPordata 
@beginDate datetime,
@endDate datetime 
AS
	select distinct
		YEAR(l.dataLocacao) as ano, MONTH(l.dataLocacao) as mes , DAY(l.dataLocacao) as dia, count(distinct f.id) as 'Qtd locação'
	from 
		locacao l 
			join fita f on f.id = l.fitaId
			join filme fi on fi.id = f.filmeId
		--where l.dataLocacao between @beginDate and @endDate
	group by YEAR(l.dataLocacao), MONTH(l.dataLocacao), DAY(l.dataLocacao)

	
drop procedure buscarPordata
go
declare @begindate datetime = CAST('2019-30-01 00:00:00.000' AS DATETIME)
declare @enddate datetime =  CAST('2021-21-07 00:00:00.000' AS DATETIME)
EXEC buscarPordata @begindate, @enddate

/*Criar uma SP, que atualize o valor de
todos os filmes de uma categoria
específica.*/

GO
CREATE PROCEDURE AlteraValorPcateg
@idCategoria int,
@novoValor numeric(10,2)
AS
	IF  @idCategoria <= (select count(id) from categoria)
		update filme set valor = (valor + ((valor/100) * @novoValor)) where categoriaId = @idCategoria 
	ELSE 
		SELECT 'OPA'
drop procedure AlteraValorPcateg

exec AlteraValorPcateg  5, 10
select * from filme

/*Criar uma SP para gerar um relatório de
locações de categoria de filmes,
agrupando a quantidade de locações por
ano e mês.*/
go
CREATE PROCEDURE locacaopcategoria
@idcategoria int
as
	select distinct
			YEAR(l.dataLocacao) as ano, MONTH(l.dataLocacao) as mes ,  count(distinct f.id) as 'Qtd locação', c.descricao
		from 
			locacao l 
				join fita f on f.id = l.fitaId
				join filme fi on fi.id = f.filmeId
				join categoria c on c.id = fi.categoriaId
		where c.id = @idcategoria
	group by YEAR(l.dataLocacao), MONTH(l.dataLocacao),  c.descricao
	
EXEC locacaopcategoria 1