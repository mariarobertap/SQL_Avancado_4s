/* Exercício 01 */
CREATE TABLE produto(
	cod varchar(5),
	nome varchar(20)
)

SELECT * FROM produto
--TRUNCATE TABLE produto

BULK INSERT produto
FROM 'C:\db_bcp_2021\produto.txt'
WITH(
	CODEPAGE = 'ACP',
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)

/* Exerício 02 */
CREATE TABLE usuario(
	login VARCHAR(50) NOT NULL,
	matricula INT NOT NULL,
	senha varchar(32) NOT NULL,
	situacao char(1) NOT NULL
)

SELECT * FROM usuario
--TRUNCATE TABLE usuario

BULK INSERT usuario
FROM 'C:\db_bcp_2021\usuarios.csv'
WITH(
	CODEPAGE = 'ACP',
	FIELDTERMINATOR = ';',
	ROWTERMINATOR = '\n'
)

/* Exerício 03 */
CREATE TABLE sales(
	Region varchar(50) ,
	Country varchar(50) ,
	ItemType varchar(50) NULL,
	SalesChannel varchar(50) NULL,
	OrderPriority varchar(50) NULL,
	OrderDate datetime,
	OrderID bigint NULL,
	ShipDate datetime,
	UnitsSold float,
	UnitPrice float,
	UnitCost float,
	TotalRevenue float,
	TotalCost float,
	TotalProfit float,
	Created date DEFAULT CAST(GETDATE() AS DATE)
)

SELECT * FROM sales
--TRUNCATE TABLE sales

CREATE VIEW vw_sales
AS
SELECT
	Region,
    Country,
    ItemType,
    SalesChannel,
    OrderPriority,
    OrderDate,
    OrderID,
    ShipDate,
    UnitsSold,
    UnitPrice,
    UnitCost,
    TotalRevenue,
    TotalCost,
    TotalProfit
FROM
	sales

SET LANGUAGE English

BULK INSERT vw_sales
FROM 'C:\db_bcp_2021\sales.csv'
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	BATCHSIZE = 250000
)