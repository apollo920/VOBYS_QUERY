SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_EMPRESA.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMPRESA'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_CBMPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CBMPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_PGEPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'PGEPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_CGEPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CGEPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SSPPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SSPPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_COJUV.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'COJUV'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_ATIPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ATIPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_FAPEPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FAPEPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_DEFCIVIL.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DEFCIVIL'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_ADH.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ADH'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SEAGRO.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEAGRO'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_IDEPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IDEPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SURPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SURPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SEID.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEID'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SECID.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECID'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_FUPIP.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FUPIP'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SETUR.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SETUR'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_AGESPISA.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'AGESPISA'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SETRANS.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SETRANS'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_TVANTARES.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'TVANTARES'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_VICEGOV.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'VICEGOV'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SEINFRA.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEINFRA'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_CCOM.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CCOM'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_FUNDESPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FUNDESPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SEDET.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEDET'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_INTERPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'INTERPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_JUCEPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'JUCEPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SEMAR.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEMAR'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_GMG.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'GMG'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SEPLAN.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEPLAN'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SAF.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SAF'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SECULT.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECULT'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_DER.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DER'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_DETRAN.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DETRAN'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_IASPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IASPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_ADAPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ADAPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_IMEPIPROD.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IMEPIPROD'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_CPVCI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CPVCI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_CENDROGAS.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CENDROGAS'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_COFIR.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'COFIR'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SEMINPER.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEMINPER'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_AGRESP.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'AGRESP'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_CEPM.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CEPM'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_EMATER.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMATER'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_FUESPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FUESPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_EMATERPROD.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMATERPROD'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_DEFENSORIA.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DEFENSORIA'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_PENSIONISTAS.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'PENSIONISTAS'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_CDTER.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CDTER'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SERES.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SERES'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SECESP.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECESP'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_INATIVOS_PENSIONISTAS.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'INATIVOS_PENSIONISTAS'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SEDUC_PRECATORIO.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEDUC_PRECATORIO'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_EMGERPI_CORESA.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_CORESA'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_FUNPREV.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FUNPREV'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_FESPPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FESPPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SIA.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SIA'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SETRE.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SETRE'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SEGOV.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEGOV'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SASC.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SASC'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_METRO.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'METRO'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_PIAUIPREV.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'PIAUIPREV'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_INATIVOS_SEDUC.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'INATIVOS_SEDUC'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_INATIVOS_TCE.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'INATIVOS_TCE'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SADA.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SADA'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SECMULHERES.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECMULHERES'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_EMGERPI_EMATER.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_EMATER'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_REENVIO.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'REENVIO'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SESAPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SESAPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_PMPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'PMPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SEJUSPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEJUSPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SEFAZPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEFAZPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SEADPREVPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEADPREVPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_IMEPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IMEPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_BEP.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'BEP'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_EMGERPI_COMEPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_COMEPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_EMGERPI_COMDEPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_COMDEPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_EMGERPI_COHAB.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_COHAB'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_EMGERPI_PRODEPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_PRODEPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_EMGERPI_CEASA.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_CEASA'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_EMGERPI_PIEMTUR.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_PIEMTUR'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_EMGERPI_ETELPI_FUNART.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_ETELPI_FUNART'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_EMGERPI_CIDAPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_CIDAPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_SEDUC.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEDUC'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_EMGERPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        
SELECT 
    E.SIGLA,
    FO.CHAVE_FOLHA,
    'https://siape.sead.pi.gov.br/adm/'|| E.PARAMETRO_URL || '/folha-funcionario/folhas/folhas/folha-de-pagamento/' || FO.ID_FOLHA AS LINK
FROM 
    SW_EMGERPI_CODIPI.FOLHA FO
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_CODIPI'
WHERE
    FO.MES=3
    AND FO.ANO=2026
    AND FO.DATA_FECHAMENTO IS NULL
UNION ALL        