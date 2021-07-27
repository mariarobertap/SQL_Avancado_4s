--Funções Escalares

/*Funções Escalares: São funções escalares definidas pelo usuario retornam um valor unico
de dados do tipo definido na clausula returns.*/

/*Crie uma Function para retirar todos os espaços
em branco de uma string qualquer*/

CREATE FUNCTION RetirarEspacos(@V1 VARCHAR(50))
RETURNS VARCHAR(50)
AS
BEGIN
	RETURN trim(@V1);
END

drop function RetirarEspacos

SELECT dbo.RetirarEspacos('  String sem espacos ')