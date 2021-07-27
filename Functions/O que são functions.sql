/*O que são Functions?

Functions são rotinas que retornam valores ou tabelas
implementadas com linguagem T-SQL, com ela, podemos criar
views parametrizadas.
*/
--Sintaxe:
CREATE FUNCTION nome_funcao (@Parametro tipo_dados)
RETURNS tipo dado retorno
AS
	BEGIN
		RETURN <CODIGO>
END

--EXEMPLO
CREATE FUNCTION SOMA(@V1 INT, @V2 INT)
RETURNS INT
AS
BEGIN
	RETURNS @V1 + @V2;
END

--Como executar?
SELECT dbo.SOMA(2,3)

