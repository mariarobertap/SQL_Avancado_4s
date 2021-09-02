
/*Acumulado por ano BANCO[BikeStores]*/
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
