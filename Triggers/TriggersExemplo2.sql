USE GATILHO;

CREATE TABLE conta_corrente(
	conta_c VARCHAR(20) NOT NULL,
	valor DECIMAL(10, 2) NOT NULL,
	operacao CHAR(1) NOT NULL, -- D (débito) | C (crédito)
)

CREATE TABLE saldo_conta(
	conta_c VARCHAR(20) NOT NULL,
	saldo DECIMAL(10, 2) NOT NULL
)

CREATE OR ALTER TRIGGER TGR_SALDO_CC
ON conta_corrente
FOR INSERT
AS
BEGIN
	
	DECLARE @CONTA_C VARCHAR(20),
			@VALOR DECIMAL(10, 2),
			@OPER CHAR(1)

	SELECT
		@CONTA_C = i.conta_c,
		@VALOR = i.valor,
		@OPER = i.operacao
	FROM
		inserted i

	IF @OPER NOT IN('D', 'C')
	BEGIN
		RAISERROR('Operação não permitida.', 16, 1)

		ROLLBACK TRANSACTION
	END
	ELSE IF(
		SELECT
			COUNT(*)
		FROM
			saldo_conta
		WHERE
			conta_c = @CONTA_C
	) = 0 AND @OPER = 'D'
	BEGIN
		INSERT INTO
			saldo_conta
		VALUES
			(@CONTA_C, @VALOR * -1)
	END
	ELSE IF(
		SELECT
			COUNT(*)
		FROM
			saldo_conta
		WHERE
			conta_c = @CONTA_C
	) = 0 AND @OPER = 'C'
	BEGIN
		INSERT INTO
			saldo_conta
		VALUES
			(@CONTA_C, @VALOR)
	END
	ELSE IF(
		SELECT
			COUNT(*)
		FROM
			saldo_conta
		WHERE
			conta_c = @CONTA_C
	) > 0 AND @OPER = 'C'
	BEGIN
		UPDATE saldo_conta SET
			saldo = saldo + @VALOR
		WHERE
			conta_c = @CONTA_C
	END
	ELSE IF(
		SELECT
			COUNT(*)
		FROM
			saldo_conta
		WHERE
			conta_c = @CONTA_C
	) > 0 AND @OPER = 'D'
	BEGIN
		UPDATE saldo_conta SET
			saldo = saldo - @VALOR
		WHERE
			conta_c = @CONTA_C
	END
END

--INSERT INTO conta_corrente VALUES ('12345-9', 500.00, 'D')
--SELECT * FROM conta_corrente
--TRUNCATE TABLE conta_corrente
--TRUNCATE TABLE saldo_conta

SELECT * FROM conta_corrente
SELECT * FROM saldo_conta