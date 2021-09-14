/*
    # Lista de Exercícios - Views & Indexed Views
    # Disciplina: Banco de Dados Avançado
    # Prof.: Tiago José Marciano #datalover🖤
*/

/* 
01) Crie uma view para exibir o número de orders completed (pedidos concluídos) 
por store (loja) e staff (vendedor).
Order status: 
1 = Pending; 
2 = Processing; 
3 = Rejected; 
4 = Completed
*/



SELECT 
	count(o.order_id) 'Completed orders' ,
	s.store_name as 'Store name',
	CONCAT(st.first_name, ' ',  st.last_name) 'Staff name'
FROM 
	sales.orders o
JOIN
	sales.stores s on o.store_id = s.store_id
JOIN
	sales.staffs st on st.staff_id = o.staff_id
WHERE
	o.order_status = 4
GROUP BY
	s.store_name,  st.staff_id, st.first_name,st.last_name
ORDER BY 
	1 DESC

/*
2) Crie uma view para exibir o [número de orders (pedidos) por ano, mês 
(order_date) e order status (situação)]. O número de orders deverá ser
apresentado em colunas representadas por cada order status (situação).
Order status: 
1 = Pending; 
2 = Processing; 
3 = Rejected; 
4 = Completed
*/   

SELECT 
	YEAR(order_date) as 'Year',
	MONTH(order_date) as 'Month',
	COUNT(CASE WHEN [order_status] = 1 THEN [order_id] END) as 'Pending',
	COUNT(CASE WHEN [order_status] = 2 THEN [order_id] END) as 'Processing',
	COUNT(CASE WHEN [order_status] = 3 THEN [order_id] END) as 'Rejected',
	COUNT(CASE WHEN [order_status] = 4 THEN [order_id] END) as 'Completed'
FROM 
	sales.orders
GROUP BY 
	YEAR(order_date),
	MONTH(order_date)
order by 
	YEAR(order_date),
	MONTH(order_date)

/*
3) Crie uma view para exibir a revenue (receita) e a revenue accumulated 
(receita acumulada) de orders completed (pedidos concluídos) por ano.
*/


	SELECT
		YEAR(o.order_date) as 'Year',
		FORMAT(SUM(oi.list_price * oi.quantity), 'C', 'PT-BR') AS 'Revenue',
		'Accumulated revenue' = (
				SELECT 
					FORMAT(SUM(oi2.list_price * oi2.quantity), 'C', 'PT-BR') 
					FROM 
						sales.order_items oi2
					JOIN
						sales.orders o2 on oi2.order_id = o2.order_id
					WHERE
					o2.order_status = 4
				AND  YEAR(o2.order_date) <= YEAR(o.order_date)
			   )
		FROM 
			sales.order_items oi
		JOIN
			sales.orders o on oi.order_id = o.order_id
		WHERE
			o.order_status = 4
		GROUP BY
			YEAR(o.order_date)


/*
4) Crie uma view para exibir o volume orders completed (volume de pedidos concluídos)
e a revenue (receita) por products (produtos) e model year (modelo do ano).
*/

	SELECT 
		COUNT(DISTINCT o.order_id) AS 'Volume',
		FORMAT(SUM(s.list_price * s.quantity), 'C', 'PT-BR') AS 'Revenue',
		CASE WHEN [order_status] = 4 THEN 'Completed' END as Status,
		p.product_name as 'Product name',
		p.model_year as 'Model year'
	FROM 
		sales.orders o
	JOIN
		sales.order_items s on o.order_id = s.order_id
	JOIN
		production.products p on s.product_id = p.product_id
	WHERE
		o.order_status = 4
	GROUP BY
		 o.order_status, p.product_name, p.model_year, p.product_id
	ORDER BY
		1 DESC



/*
5) Crie uma view para exibir o volume orders completed (volume de pedidos concluídos)
e a revenue (receita) por brands (marcas).
*/

	SELECT 
		count(distinct o.order_id) as 'Volume',
		CASE 
			WHEN [order_status] = 4
			THEN 'Completed'
		END as Status,
		FORMAT(SUM(s.list_price * s.quantity), 'C', 'PT-BR') as 'Revenue',
		b.brand_name as 'Brand Name'
	FROM 
		sales.orders o
	JOIN
		sales.order_items s on o.order_id = s.order_id
	JOIN
		production.products p on s.product_id = p.product_id
	JOIN
		production.brands b on b.brand_id = p.brand_id
	WHERE
		o.order_status = 4
	GROUP BY
		 b.brand_name, o.order_status, b.brand_id
	ORDER BY
		1 DESC


		  
/*
6) Crie uma view para exibir o volume orders completed (volume de pedidos concluídos)
e a revenue (receita) por categories (categorias).
*/

select * from production.categories

	SELECT 
		count(distinct o.order_id) as 'Volume',
		FORMAT(SUM(s.list_price * s.quantity), 'C', 'PT-BR') as 'Revenue',
		b.category_name as 'Categorie name'
	FROM 
		sales.orders o
	JOIN
		sales.order_items s on o.order_id = s.order_id
	JOIN
		production.products p on s.product_id = p.product_id
	JOIN
		production.categories b on b.category_id = p.category_id
	WHERE
		o.order_status = 4
	GROUP BY
		 b.category_name, b.category_id




/*
7) Crie uma view para exibir o volume orders completed (volume de pedidos concluídos)
e a revenue (receita) por state (estado) e city (cidade).
*/

	select * from sales.orders
	select * from sales.staffs

	select * from sales.customers

	SELECT 
		count(distinct o.order_id) as 'Volume',
		FORMAT(SUM(s.list_price * s.quantity), 'C', 'PT-BR') as 'Faturamento',
		c.city as 'City', 
		c.state as 'State'
	FROM 
		sales.orders o
	JOIN
		sales.customers c on c.customer_id = o.customer_id
	JOIN
		sales.order_items s on o.order_id = s.order_id
	WHERE
		o.order_status = 4
	GROUP BY
		c.city, c.state
	ORDER BY 
		c.state, 
		count(distinct o.order_id),
		SUM(s.list_price * s.quantity)


/*
8) Crie uma view para exibir a data da primeira e última order (pedido)
de cada customer (cliente).
*/

	SELECT 
		MIN(o.order_date) as 'First order',
		MAX(o.order_date) as 'Last order',
		CONCAT(c.first_name, ' ',  c.last_name) 'Staff name'
	FROM 
		sales.orders o
	JOIN
		sales.customers c on c.customer_id = o.customer_id
	GROUP BY
	  c.customer_id,
	  CONCAT(c.first_name, ' ',  c.last_name)
    ORDER BY 
		c.customer_id




/*
9) Crie uma indexed view para exibir o volume orders completed (volume de pedidos concluídos),
a revenue (receita), o discounts (total de descontos) e a percentage discounts 
(percentual de descontos) por ano e trimestre.
*/
CREATE VIEW sales.IVW_getPercentageOFFByquarter
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
		COUNT(DISTINCT o.order_id) AS volumn,
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


SELECT 
	*
FROM
	sales.IVW_getPercentageOFFByquarter
ORDER BY 
	5,
	6 

