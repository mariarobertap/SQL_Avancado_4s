
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
CREATE VIEW sales.vw_exercicio_01
AS
SELECT 
	s.store_name,
	CONCAT(st.first_name, ' ', st.last_name) as staff_name,
	COUNT(o.order_id) as count_orders
FROM
	sales.orders o
	JOIN sales.stores s
		ON s.store_id = o.store_id
	JOIN sales.staffs st
		ON st.staff_id = o.staff_id
WHERE
	o.order_status = 4
GROUP BY
	s.store_name,
	CONCAT(st.first_name, ' ', st.last_name)

/*
2) Crie uma view para exibir o número de orders (pedidos) por ano, mês 
(order_date) e order status (situação). O número de orders deverá ser
apresentado em colunas representadas por cada order status (situação).
Order status: 
1 = Pending; 
2 = Processing; 
3 = Rejected; 
4 = Completed
*/
CREATE VIEW sales.vw_exercicio_02
AS
SELECT
	T_COLS.[Year],
	T_COLS.[Month],
	ISNULL(T_COLS.Pending, 0) as Pending,
	ISNULL(T_COLS.Processing, 0) as Processing,
	ISNULL(T_COLS.Rejected, 0) as Rejected,
	ISNULL(T_COLS.Completed, 0) as Completed
FROM
(
	SELECT
		YEAR(o.order_date) as 'Year',
		MONTH(o.order_date) as 'Month',
		CASE o.order_status
			WHEN 1 THEN 'Pending'
			WHEN 2 THEN 'Processing'
			WHEN 3 THEN 'Rejected'
			WHEN 4 THEN 'Completed'
		END AS order_status,
		COUNT(o.order_status) as count_orders
	FROM
		sales.orders o
	GROUP BY
		YEAR(o.order_date),
		MONTH(o.order_date),
		CASE o.order_status
			WHEN 1 THEN 'Pending'
			WHEN 2 THEN 'Processing'
			WHEN 3 THEN 'Rejected'
			WHEN 4 THEN 'Completed'
		END
) AS T_ROWS
PIVOT (
	SUM(count_orders) FOR order_status IN(
		[Pending], [Processing], [Rejected], [Completed]
	)
) AS T_COLS

/*
3) Crie uma view para exibir a revenue (receita) e a revenue accumulated 
(receita acumulada) de orders completed (pedidos concluídos) por ano.
*/
CREATE VIEW sales.vw_exercicio_03
AS
SELECT
	YEAR(o.order_date) as 'Year',
	FORMAT(SUM((i.quantity * i.list_price) * (1 - i.discount)), 'C', 'EN-US') as revenue,
	Acc_Revenue = (
		SELECT
			FORMAT(SUM((si.quantity * si.list_price) * (1 - si.discount)), 'C', 'EN-US')
		FROM
			sales.order_items si
			JOIN sales.orders so
				ON so.order_id = si.order_id
		WHERE
			so.order_status = 4
			AND YEAR(so.order_date) <= YEAR(o.order_date)
	)
FROM
	sales.order_items i
	JOIN sales.orders o
		ON o.order_id = i.order_id
WHERE
	o.order_status = 4
GROUP BY
	YEAR(o.order_date)

/*
4) Crie uma view para exibir o volume orders completed (volume de pedidos concluídos)
e a revenue (receita) por products (produtos) e model year (modelo do ano).
*/
CREATE VIEW sales.vw_exercicio_04
AS
SELECT
	p.product_name,
	p.model_year,
	COUNT(DISTINCT o.order_id) as volume_orders,
	FORMAT(SUM((i.quantity * i.list_price) * (1 - i.discount)), 'C', 'EN-US') as revenue
FROM
	sales.order_items i
	JOIN sales.orders o
		ON o.order_id = i.order_id
	JOIN production.products p
		ON p.product_id = i.product_id
WHERE
	o.order_status = 4
GROUP BY
	p.product_name,
	p.model_year

/*
5) Crie uma view para exibir o volume orders completed (volume de pedidos concluídos)
e a revenue (receita) por brands (marcas).
*/
CREATE VIEW sales.vw_exercicio_5
AS
SELECT
	b.brand_name,
	COUNT(DISTINCT o.order_id) as volume_orders,
	FORMAT(SUM((i.quantity * i.list_price) * (1 - i.discount)), 'C', 'EN-US') as revenue
FROM
	sales.order_items i
	JOIN sales.orders o
		ON o.order_id = i.order_id
	JOIN production.products p
		ON p.product_id = i.product_id
	JOIN production.brands b
		ON b.brand_id = p.brand_id
WHERE
	o.order_status = 4
GROUP BY
	b.brand_name

/*
6) Crie uma view para exibir o volume orders completed (volume de pedidos concluídos)
e a revenue (receita) por categories (categorias).
*/

/*
7) Crie uma view para exibir o volume orders completed (volume de pedidos concluídos)
e a revenue (receita) por state (estado) e city (cidade).
*/

/*
8) Crie uma view para exibir a data da primeira e última order (pedido)
de cada customer (cliente).
*/

/*
9) DESAFIO: Crie uma indexed view para exibir o volume orders completed (volume de pedidos concluídos),
a revenue (receita), o discounts (total de descontos) e a percentage discounts 
(percentual de descontos) por ano e trimestre.
*/