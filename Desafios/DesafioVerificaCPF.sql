/*
DESAFIO: Crie uma função que receba um número de CPF sem separadores xxxxxxxxxxx (11 dígitos)
e verifique se o número é um CPF válido ou não. Caso seja um CPF válido retorne o mesmo formatado corretamente
xxx.xxx.xxx-xx, caso não seja válido, retorne a frase “O CPF digitado é inválido”.

Inserir o DDL da sentença SQL com a criação da Function e chamada de execução.*/

CREATE FUNCTION verificaCPF(
    @Nr_Documento VARCHAR(11)
)
RETURNS VARCHAR(50)
BEGIN
 
    DECLARE
        @count1 INT,
        @count2 INT,
        @digito1 INT,
        @digito2 INT,
        @bufferAux VARCHAR(11),
		@bufferAux2 VARCHAR(20)
 
    SET @bufferAux = LTRIM(RTRIM(@Nr_Documento))
    SET @digito1 = 0
 
 
    IF (@bufferAux IN ('00000000000', '11111111111', '22222222222', '33333333333', '44444444444', '55555555555', '66666666666', '77777777777', '88888888888', '99999999999', '12345678909'))
         RETURN 'O CPF digitado é inválido'
 
 
    IF (LEN(@bufferAux) <> 11)
        RETURN 'O CPF digitado é inválido'
    ELSE 
    BEGIN
 
        SET @bufferAux = SUBSTRING(@bufferAux, 1, 9)
 
        SET @count1 = 2
 
        WHILE (@count1 < = 10)
        BEGIN 
            SET @digito1 = @digito1 + (@count1 * CAST(SUBSTRING(@bufferAux, 11 - @count1, 1) as int))
            SET @count1 = @count1 + 1
        end 
 
        SET @digito1 = @digito1 - (@digito1/11)*11
 
        IF (@digito1 <= 1)
            SET @digito1 = 0
        ELSE 
            SET @digito1 = 11 - @digito1
 
        SET @bufferAux = @bufferAux + CAST(@digito1 AS VARCHAR(1))
 
        IF (@bufferAux <> SUBSTRING(@Nr_Documento, 1, 10))
             RETURN 'O CPF digitado é inválido'
        ELSE BEGIN 
        
            SET @digito2 = 0
            SET @count2 = 2
 
            WHILE (@count2 < = 11)
            BEGIN 
                SET @digito2 = @digito2 + (@count2 * CAST(SUBSTRING(@bufferAux, 12 - @count2, 1) AS INT))
                SET @count2 = @count2 + 1
            end 
 
            SET @digito2 = @digito2 - (@digito2/11)*11
 
            IF (@digito2 < 2)
                SET @digito2 = 0
            ELSE 
                SET @digito2 = 11 - @digito2
 
            SET @bufferAux = @bufferAux + CAST(@digito2 AS VARCHAR(1))
 
            IF (@bufferAux <> @Nr_Documento)
                RETURN 'O CPF digitado é inválido'
                
        END
    END 
	
	
	
	SET @bufferAux2 = CONCAT(SUBSTRING(@Nr_Documento, 1, 3),
									'.',SUBSTRING(@Nr_Documento, 4, 3),
									'.', SUBSTRING(@Nr_Documento, 7, 3),
									'-' , SUBSTRING(@Nr_Documento, 10, 2))




    RETURN @bufferAux2
    
END

SELECT dbo.verificaCPF('11111111111')  



