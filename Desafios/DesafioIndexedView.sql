/*
	Desafio indexed view
	Banco BikeStores.bak
*/

/*
9) Crie uma indexed view para exibir o volume orders completed (volume de pedidos concluídos),
a revenue (receita), o discounts (total de descontos) e a percentage discounts 
(percentual de descontos) por ano e trimestre.
*/

select * from sales.orders 

CREATE VIEW sales.ivw_getPercentageOFFByquarter
WITH SCHEMABINDING
AS
SELECT 
	tab.volumn as 'Volume' ,
	FORMAT(tab.amount,  'C', 'PT-BR') 'Total amount (revenue)',
	FORMAT(tab.disc,   'C', 'PT-BR') 'Total discounts',
	CONVERT(VARCHAR(6),CAST(ROUND((tab.disc / tab.amount *100), 2) AS DECIMAL(18,2))) + '%' 'Percent OFF',
	tab.year AS 'Year',
	tab.trimestre AS 'Quarter'
	
FROM(
	SELECT 
		count(DISTINCT o.order_id) AS volumn,
		SUM((s.quantity * s.list_price) * (1 - s.discount)) AS amount,
		SUM(((s.list_price * s.quantity)  * s.discount)) AS disc,
		YEAR(o.order_date) AS year,
		DATEPART(QUARTER, o.order_date) as trimestre
	FROM 
		sales.orders o
	JOIN
		sales.order_items s ON o.order_id = s.order_id
	JOIN
		production.products p ON s.product_id = p.product_id
	WHERE
		o.order_status = 4 
	GROUP BY
		YEAR(o.order_date),
		DATEPART(QUARTER, o.order_date)

)  AS tab
ORDER BY 
	tab.year,
	tab.trimestre