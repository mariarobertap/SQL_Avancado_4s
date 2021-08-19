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
	
	update produto set quantidade  = (quantidade - @QTD) WHERE codproduto = @ID;
END

DROP TRIGGER TGR_LOG_TABELA_UPDATE

--2 Crie um TRIGGER para criar um log dos CLIENTES modificados.

CREATE TRIGGER TGR_LOG_CLIENTES_UPDATE
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

CREATE TRIGGER TGR_LOG_ITEM_EM_FALTA
ON itempedido
AFTER INSERT
AS
BEGIN
	DECLARE @QTD INT

	SELECT 
		@QTD = (ins.quantidade - p.quantidade)
	FROM 
		inserted ins
	JOIN 
		produto p ON p.codproduto = ins.codproduto 

	if(@QTD <= 0)
	begin
		INSERT INTO log
			(codlog, data, descricao)
		SELECT
			codpedido, getdate(), 'Sem estoque [itempedido table]'
		FROM
			inserted
	end
END



--5. Crie um TRIGGER para criar uma requisição de REQUISICAO_COMPRA quanto o
--estoque atingir 50% da venda mensal.

select * from itempedido
select * from produto
select * from requisicao_compra
drop trigger TGR_teste
CREATE TRIGGER TGR_teste
ON itempedido
AFTER INSERT
AS
BEGIN
	DECLARE @IDProduto int
	DECLARE @QuantidadeP int

	SELECT 
		@IDProduto = p.codproduto,
		@QuantidadeP = p.quantidade
	FROM
		pedido pd
		JOIN itempedido itp 
			on itp.codpedido = pd.codpedido
		JOIN produto p
			on p.codproduto = itp.codproduto
	WHERE
		(p.quantidade - itp.quantidade) = P.quantidade/2 
	GROUP BY 
		MONTH(pd.datapedido), p.codproduto, p.quantidade

	IF(@IDProduto > 0)
	INSERT INTO requisicao_compra (codproduto, data, quantidade) values ( @IDProduto, GETDATE(), (@QuantidadeP/2))

END

select * from itempedido
select * from requisicao_compra
--6. Crie um TRIGGER para criar um log quando um ITEMPEDIDO for removido.

CREATE TRIGGER TGR_LOG_ITEM_DELETADO
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
CREATE TRIGGER TGR_IMPEDIR_VALOR_NEGATIVO
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
INSERT INTO itempedido VALUES (7, 11, 1, 2, 2)

--10. Crie um TRIGGER para não permitir quantidade negativa na tabela ITEMPEDIDO.
CREATE TRIGGER TGR_IMPEDIR_QUANTIDADE_NEGATIVA
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


CREATE TRIGGER TGR_LOG_PEDIDO_MAIOR_1000
ON pedido
AFTER INSERT
AS
BEGIN
	
	DECLARE @IDPedido INT
	DECLARE @Valor DECIMAL(10, 2)
	DECLARE @Descricao varchar(50)

	SELECT 
		@Valor = valortotal,
		@IDPedido = codpedido
	FROM 
		inserted


	IF(@Valor > 1000)
	BEGIN
		set @Descricao =  CONCAT('Pedido > 1000 ID:', @IDPedido)
		INSERT INTO log
		(codlog, data, descricao)
		SELECT
			codpedido, getdate(), @Descricao
		FROM
			inserted
	END

END
DROP TRIGGER TGR_LOG_PEDIDO_MAIOR_1000
SELECT * FROM pedido

INSERT INTO pedido  VALUES (10, 7, GETDATE(), 8, 1001)
SELECT * FROM LOG


--9. Crie um TRIGGER que NÃO permita que uma PESSOA com data de nascimento
--anterior à data atual seja inserida ou atualizada.

CREATE TRIGGER TGR_CLIENTE_BDAY_MAIOR_DATA_ATUAL
ON cliente
AFTER INSERT, UPDATE
AS
BEGIN
	
	DECLARE @BDay DATETIME


	SELECT 
		@BDay = datanascimento
	FROM 
		inserted


	IF(@BDay > GETDATE())
		ROLLBACK TRANSACTION 

END

select * from cliente