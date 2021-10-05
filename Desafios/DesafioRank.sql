/*
	Desafio indexed view
	Banco LOCADORA.bak
*/

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