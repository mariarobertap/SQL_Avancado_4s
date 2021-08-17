/*Utilizando o BD LOJA_TRIGGER crie as seguintes triggers:
TRIGGERS

1. Crie um TRIGGER para baixar o estoque de um produto quando ele for vendido.

2. Crie um TRIGGER para criar um log dos CLIENTES modificados.

3. Crie um TRIGGER para criar um log de PRODUTOS atualizados.

4. Crie um TRIGGER para criar um log quando não existe a quantidade do
ITEMPEDIDO em estoque.

5. Crie um TRIGGER para criar uma requisição de REQUISICAO_COMPRA quanto o
estoque atingir 50% da venda mensal.

6. Crie um TRIGGER para criar um log quando um ITEMPEDIDO for removido.

7. Crie um TRIGGER para criar um log quando o valor total do pedido for maior que
R$ 1.000,00.

8. Crie um TRIGGER para NÃO deixar valores negativos serem INSERIDOS em
ITEMPEDIDO, o valor mínimo é “0”.

9. Crie um TRIGGER que NÃO permita que uma PESSOA com data de nascimento
anterior à data atual seja inserida ou atualizada.

10. Crie um TRIGGER para não permitir quantidade negativa na tabela ITEMPEDIDO.
*/

--1. Crie um TRIGGER para baixar o estoque de um produto quando ele for vendido.

SELECT * FROM produto
SELECT * FROM pedido
select * from itempedido

CREATE TRIGGER TGR_LOG_BAIXAR_ESTOQUE
ON itempedido
AFTER INSERT
AS
BEGIN

	DECLARE  @QTD INT;
	DECLARE  @ID INT;

	SELECT 
		@QTD = QUANTIDADE,
		@ID = codproduto
	FROM
		inserted
	
	update produto set quantidade  = quantidade - @QTD WHERE codproduto = @ID;
END

DROP TRIGGER TGR_LOG_TABELA_UPDATE

--Crie um TRIGGER para criar um log dos CLIENTES modificados.

CREATE TRIGGER TGR_LOG_TABELA_UPDATE
ON cliente
AFTER UPDATE
AS
BEGIN
	
	INSERT INTO log
		(codlog, data, descricao)
	SELECT
		codcliente,
		GETDATE(),
		'Update - [Tabela Cliente]'
	FROM
		inserted
END

delete from log
SELECT * FROM cliente
UPDATE CLIENTE SET NOME = 'Maria rOBERTA' where codcliente = 1;
select * from log

--3. Crie um TRIGGER para criar um log de PRODUTOS atualizados.


CREATE TRIGGER TGR_LOG_PRODUTOS_UPDATE
ON produto
AFTER UPDATE
AS
BEGIN
	
	INSERT INTO log
		(codlog, data, descricao)
	SELECT
		codproduto,
		GETDATE(),
		'Update - [Tabela Produto]'
	FROM
		inserted
END

--4. Crie um TRIGGER para criar um log quando não existe a quantidade do
--ITEMPEDIDO em estoque.

--6. Crie um TRIGGER para criar um log quando um ITEMPEDIDO for removido.

CREATE TRIGGER TGR_LOG_TABELA_DELETE
ON itempedido
AFTER DELETE
AS
BEGIN
	
	INSERT INTO log
		(codlog, data, descricao)
	SELECT
		codpedido, getdate(), 'Delete [itempedido table]'
	FROM
		deleted
END
select * from log
select * from itempedido

--8. Crie um TRIGGER para NÃO deixar valores negativos serem INSERIDOS em
--ITEMPEDIDO, o valor mínimo é “0”.

CREATE TRIGGER TGR_LOG_TABELA_INSERT
ON itempedido
AFTER INSERT
AS
BEGIN
	
	DECLARE @VALOR DECIMAL(10,2)

	SELECT 
		@VALOR = valorunitario
	FROM 
		inserted


	IF(@VALOR < 0)
		ROLLBACK TRANSACTION

END

SELECT * FROM itempedido
INSERT INTO itempedido VALUES (7, 7, 1, 2, 2)

--10. Crie um TRIGGER para não permitir quantidade negativa na tabela ITEMPEDIDO.
CREATE TRIGGER TGR_LOG_TABELA_INSERT
ON itempedido
AFTER INSERT
AS
BEGIN
	
	DECLARE @QUANTIDADE INT

	SELECT 
		@QUANTIDADE = quantidade
	FROM 
		inserted


	IF(@QUANTIDADE < 0)
		ROLLBACK TRANSACTION

END

--7. Crie um TRIGGER para criar um log quando o valor total do pedido for maior que
--R$ 1.000,00.