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
	count(o.order_id), s.store_name, st.first_name
FROM 
	sales.orders o
JOIN
	sales.stores s on o.store_id = s.store_id
JOIN
	sales.staffs st on s.store_id = st.store_id
WHERE
	o.order_status = 4
GROUP BY
	s.store_name, st.first_name

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

select * from sales.orders

SELECT 
	count(o.order_id), o.order_status, Month(order_date), year(order_date)
FROM 
	sales.orders o
JOIN
	sales.stores s on o.store_id = s.store_id
JOIN
	sales.staffs st on s.store_id = st.store_id
WHERE
	o.order_status = 4
GROUP BY
	 Month(order_date), year(order_date),  o.order_status



/*
3) Crie uma view para exibir a revenue (receita) e a revenue accumulated 
(receita acumulada) de orders completed (pedidos concluídos) por ano.
*/


	SELECT
		YEAR(o.order_date) as 'Ano',
		FORMAT(SUM(oi.list_price * oi.quantity), 'C', 'PT-BR') AS 'Faturamento',
		'Faturamento Acumulado' = (
				SELECT 
					FORMAT(SUM(oi2.list_price * oi2.quantity), 'C', 'PT-BR') AS 'Montante Total'
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
		FORMAT(SUM(s.list_price * s.quantity), 'C', 'PT-BR') AS 'Faturamento',
		o.order_status, p.product_name, p.model_year
	FROM 
		sales.orders o
	JOIN
		sales.order_items s on o.order_id = s.order_id
	JOIN
		production.products p on s.product_id = p.product_id
	WHERE
		o.order_status = 4
	GROUP BY
		 o.order_status, p.product_name, p.model_year



/*
5) Crie uma view para exibir o volume orders completed (volume de pedidos concluídos)
e a revenue (receita) por brands (marcas).
*/

	SELECT 
		count(o.order_id) as 'Volume',
		FORMAT(SUM(s.list_price * s.quantity), 'C', 'PT-BR') as 'Faturamento',
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
		 b.brand_name

		  
/*
6) Crie uma view para exibir o volume orders completed (volume de pedidos concluídos)
e a revenue (receita) por categories (categorias).
*/

select * from production.categories

	SELECT 
		count(o.order_id) as 'Volume',
		FORMAT(SUM(s.list_price * s.quantity), 'C', 'PT-BR') as 'Faturamento',
		b.category_name as 'Brand Name'
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
		 b.category_name




/*
7) Crie uma view para exibir o volume orders completed (volume de pedidos concluídos)
e a revenue (receita) por state (estado) e city (cidade).
*/

	select * from sales.orders
	select * from sales.staffs

	select * from sales.customers

	SELECT 
		count(o.order_id) as 'Volume',
		FORMAT(SUM(s.list_price * s.quantity), 'C', 'PT-BR') as 'Faturamento',
		c.street as 'Rua'
	FROM 
		sales.orders o
	JOIN
		sales.customers c on c.customer_id = o.customer_id
	JOIN
		sales.order_items s on o.order_id = s.order_id
	WHERE
		o.order_status = 4
	GROUP BY
		c.street

/*
8) Crie uma view para exibir a data da primeira e última order (pedido)
de cada customer (cliente).
*/


/*
9) Crie uma indexed view para exibir o volume orders completed (volume de pedidos concluídos),
a revenue (receita), o discounts (total de descontos) e a percentage discounts 
(percentual de descontos) por ano e trimestre.
*/
