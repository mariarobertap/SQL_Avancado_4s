/* Maria Roberta
   Banco: Locadora 
  */

/*Criar um cursor para selecionar o nome e valor do filme. Caso o valor do filme seja inferior a
R$ 12,00, mostrar o nome do filme, o valor atual e o valor com 10% de aumento. Se o valor 
do filme for superior a R$ 12,00 mostrar o nome do filme, o valor atual e valor com 15% de 
aumento.*/

SELECT * FROM FILME

SET NOCOUNT ON;

DECLARE cursor_exerc_01 CURSOR FOR

	SELECT 
		descricao as nome,
		valor
	FROM 
		filme

	DECLARE @nome VARCHAR(100)
	DECLARE @valor  DECIMAL(10,2)
	DECLARE @valorAux  DECIMAL(10,2)

	OPEN cursor_exerc_01

	FETCH NEXT FROM
		cursor_exerc_01
	INTO
		@nome,
		@valor



	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		IF(@valor > 12)
		begin
			set @valorAux = @valor + (@valor*10)/100
			SELECT CONCAT('Filme ', @nome, 'Valor: ', @valor, ' Valor + 10%: ', @valorAux)
		end
		ELSE IF(@valor < 12)
		begin
			set @valorAux = @valor + (@valor*15)/100
			SELECT CONCAT('Filme ', @nome, 'Valor: ', @valor, ' Valor + 15%: ', @valorAux)
		end
		--PRINT @mensagem

		FETCH NEXT FROM
			cursor_exerc_01
		INTO
			@nome,
			@valor
	END

CLOSE cursor_exerc_01
DEALLOCATE cursor_exerc_01

/*Criar um cursor para selecionar a data e o valor de locação. Caso o valor da locação seja 
superior a R$ 12,00, mostrar a data, valor da locação e valor com 10% de desconto. Se o 
valor da locação for inferior a R$ 12,00 mostrar todos os dados, mas com o valor de 
desconto de 8%.*/




	SELECT * FROM FILME

SET NOCOUNT ON;

DECLARE cursor_exerc_01 CURSOR FOR

	SELECT
		l.dataLocacao, f.descricao, f.valor
	FROM 
		locacao l
	JOIN
		fita ft on ft.id = l.fitaId
	JOIN 
		filme f on f.id = ft.filmeId

	DECLARE @data DATETIME
	DECLARE @nomeFilme  VARCHAR(100)
	DECLARE @valorFilme  DECIMAL(10,2)


	DECLARE @valorFilmeAux  DECIMAL(10,2)


	OPEN cursor_exerc_01

	FETCH NEXT FROM
		cursor_exerc_01
	INTO
		@data,
		@nomeFilme,
		@valorFilme




	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		IF(@valorFilme > 12)
		begin
			set @valorFilmeAux = @valorFilme - (@valorFilme*10)/100
			SELECT CONCAT('Data  ', @data, 'Valor: ', @valorFilme, ' Valor - 10%: ', @valorFilmeAux)
		end
		ELSE IF(@valorFilme < 12)
		begin
			set @valorFilmeAux = @valorFilme - (@valorFilme*8)/100
			SELECT CONCAT('Data  ', @data, 'Valor: ', @valorFilme, ' Valor - 8%: ', @valorFilmeAux)
		end
		--PRINT @mensagem

		FETCH NEXT FROM
			cursor_exerc_01
		INTO
			@data,
			@nomeFilme,
			@valorFilme
	END

CLOSE cursor_exerc_01
DEALLOCATE cursor_exerc_01


/*Criar um cursor para atualizar os valores dos filmes, se o filme possuir 3 unidades ou menos
de fitas, aumentar em 5% no valor, se o filme tiver entre 4 e 5 unidades de fitas aumentar 
10%, se o filme contiver mais de 5 unidades de fitas aumentar 20% do valor.*/
SELECT 
	fi.id, fi.valor,  fi.descricao, count(ft.id) AS 'Quantidade de fitas'
FROM
	filme fi
JOIN
	fita ft on ft.filmeId = fi.id
GROUP BY
	fi.descricao, fi.id, fi.valor



SET NOCOUNT ON;

DECLARE cursor_exerc_01 CURSOR FOR

	SELECT 
		 fi.descricao, count(ft.id), fi.id, fi.valor
	FROM
		filme fi
	JOIN
		fita ft on ft.filmeId = fi.id
	GROUP BY
		fi.descricao, fi.id, fi.valor


	DECLARE @nomeFilme2  VARCHAR(100)
	DECLARE @Quantidade	 INT 
	DECLARE @id	 INT 
	DECLARE @valorFilme2  DECIMAL(10,2)





	OPEN cursor_exerc_01

	FETCH NEXT FROM
		cursor_exerc_01
	INTO
		@nomeFilme2,
		@Quantidade,
		@id,
		@valorFilme2




	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		IF(@Quantidade <= 3)
		BEGIN
			UPDATE filme SET VALOR = (@valorFilme2 + (@valorFilme2*5)/100) WHERE id = @id
		END
		ELSE IF(@Quantidade >= 4 AND @Quantidade <= 5)
		BEGIN
			UPDATE filme SET VALOR = (@valorFilme2 + (@valorFilme2*10)/100) WHERE id = @id

		END
		ELSE IF(@Quantidade > 5)
		BEGIN
			UPDATE filme SET VALOR = (@valorFilme2 + (@valorFilme2*20)/100) WHERE id = @id

		END
		--PRINT @mensagem

		FETCH NEXT FROM
			cursor_exerc_01
		INTO
		@nomeFilme2,
		@Quantidade,
		@id,
		@valorFilme2

	END

CLOSE cursor_exerc_01
DEALLOCATE cursor_exerc_01

/*Utilizando um cursor, apresente os clientes que precisam devolver filmes, se fazem 7 dias 
corridos da data de locação, acrescentar multa de 10% no valor, se tiver entre 8 e 15 dias 
acrescentar multa de 15% no valor, se fazem mais de 15 dias acrescentar multa de 30% do 
valor*/


/*DESAFIO: A locadora de filmes oferece um bônus a seus clientes com base no número de 
locações realizadas durante o ano no valor da média de locações feitas no mesmo período. 
O bônus é aplicado para clientes que fizeram pelo menos 3 locações no ano. Contudo, o 
bônus não é aplicado para clientes que tenham mais de 1 filme para devolução. Utilizando 
um cursor, crie um procedimento que passado o ano imprima o código do cliente, o seu 
nome e o valor do seu respectivo bônus*/