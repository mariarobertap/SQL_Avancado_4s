@ECHO OFF

Set Server=localhost
Set Username=tiagomarciano
Set Password=xo11@dyv$
Set ArquivoJapan=C:\db_bcp_2021\sales_japan.csv
Set ArquivoItaly=C:\db_bcp_2021\sales_italy.csv
Set ArquivoEua=C:\db_bcp_2021\sales_eua.csv
Set Log=C:\db_bcp_2021\sales_desafio.log

ECHO Inicio do BCP: %TIME%
ECHO Aguarde a exportação dos dados...

bcp "SELECT * FROM DB_BULK.dbo.sales WHERE country = 'japan'" queryout %ArquivoJapan% -o %Log% -S %Server% -U %Username% -P %Password% -c -t ","

bcp "SELECT * FROM DB_BULK.dbo.sales WHERE country = 'italy'" queryout %ArquivoItaly% -o %Log% -S %Server% -U %Username% -P %Password% -c -t ","

bcp "SELECT * FROM DB_BULK.dbo.sales WHERE country = 'United States of America'" queryout %ArquivoEua% -o %Log% -S %Server% -U %Username% -P %Password% -c -t ","

ECHO Termino do BCP...: %TIME%
ECHO Log no arquivo %Log%

PAUSE