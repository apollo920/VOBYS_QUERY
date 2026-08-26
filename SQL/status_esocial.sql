// STATUS ESOCIAL
SELECT 
    'EMPRESA' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/siape/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_EMPRESA.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'CBMPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/cbmpi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_CBMPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'PGEPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/pgepi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_PGEPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'CGEPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/cgepi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_CGEPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SSPPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/ssppi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SSPPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'COJUV' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/cojuv/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_COJUV.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'ATIPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/atipi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_ATIPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'FAPEPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/fapepi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_FAPEPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'DEFCIVIL' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/defcivil/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_DEFCIVIL.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'ADH' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/adh/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_ADH.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SEAGRO' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/seagro/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SEAGRO.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'IDEPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/idepi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_IDEPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SURPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/surpi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SURPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SEID' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/seid/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SEID.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SECID' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/secid/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SECID.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'FUPIP' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/fupip/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_FUPIP.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SETUR' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/setur/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SETUR.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'AGESPISA' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/agespisa/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_AGESPISA.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SETRANS' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/setrans/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SETRANS.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'TVANTARES' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/tvantares/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_TVANTARES.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'VICEGOV' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/vicegov/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_VICEGOV.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SEINFRA' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/seinfra/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SEINFRA.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'CCOM' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/ccom/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_CCOM.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'FUNDESPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/seesp/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_FUNDESPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SEDET' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/sedet/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SEDET.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'INTERPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/interpi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_INTERPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'JUCEPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/jucepi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_JUCEPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SEMAR' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/semar/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SEMAR.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'GMG' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/gamil/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_GMG.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SEPLAN' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/seplan/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SEPLAN.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SAF' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/saf/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SAF.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SECULT' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/secult/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SECULT.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'DER' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/der/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_DER.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'DETRAN' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/detran/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_DETRAN.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'IASPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/iaspi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_IASPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'ADAPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/adapi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_ADAPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'IMEPIPROD' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/imepiprod/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_IMEPIPROD.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'CPVCI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/cpvci/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_CPVCI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'CENDROGAS' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/cendrogas/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_CENDROGAS.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'COFIR' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/cofir/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_COFIR.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SEMINPER' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/seminper/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SEMINPER.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'AGRESP' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/agrespi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_AGRESP.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'CEPM' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/cepm/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_CEPM.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'EMATER' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/emater/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_EMATER.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'FUESPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/fuespi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_FUESPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'EMATERPROD' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/ematerprod/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_EMATERPROD.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'DEFENSORIA' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org//esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_DEFENSORIA.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'PENSIONISTAS' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/pensionistas/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_PENSIONISTAS.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'CDTER' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/cdter/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_CDTER.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SERES' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/seres/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SERES.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SECESP' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/secesp/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SECESP.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'INATIVOS_PENSIONISTAS' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/inativos_pensionistas/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_INATIVOS_PENSIONISTAS.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL

SELECT 
    'EMGERPI_CORESA' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/emgerpi_coresa/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_EMGERPI_CORESA.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'FUNPREV' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/funprev/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_FUNPREV.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'FESPPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/fesppi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_FESPPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SIA' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/sia/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SIA.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SETRE' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/setre/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SETRE.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SEGOV' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/segov/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SEGOV.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SASC' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/sasc/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SASC.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'METRO' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/metro/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_METRO.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'PIAUIPREV' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/piauiprev/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_PIAUIPREV.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'INATIVOS_SEDUC' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/inativos_seduc/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_INATIVOS_SEDUC.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'INATIVOS_TCE' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/inativos_tce/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_INATIVOS_TCE.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SADA' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/sada/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SADA.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SECMULHERES' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/sempi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SECMULHERES.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'EMGERPI_EMATER' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/emgerpi_emater/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_EMGERPI_EMATER.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'REENVIO' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/reenvio/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_REENVIO.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SESAPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/sesapi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SESAPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'PMPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/pmpi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_PMPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SEJUSPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/sejuspi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SEJUSPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SEFAZPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/sefazpi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SEFAZPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SEADPREVPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/sead/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SEADPREVPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'IMEPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/imepi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_IMEPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'BEP' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/bep/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_BEP.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'EMGERPI_COMEPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/emgerpi_comepi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_EMGERPI_COMEPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'EMGERPI_COMDEPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/emgerpi_comdepi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_EMGERPI_COMDEPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'EMGERPI_COHAB' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/emgerpi_cohab/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_EMGERPI_COHAB.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'EMGERPI_PRODEPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/emgerpi_prodepi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_EMGERPI_PRODEPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'EMGERPI_CEASA' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/emgerpi_ceasa/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_EMGERPI_CEASA.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'EMGERPI_PIEMTUR' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/emgerpi_piemtur/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_EMGERPI_PIEMTUR.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'EMGERPI_ETELPI_FUNART' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/emgerpi_etelpi_funart/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_EMGERPI_ETELPI_FUNART.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'EMGERPI_CIDAPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/emgerpi_cidapi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_EMGERPI_CIDAPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'SEDUC' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/seduc/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_SEDUC.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'EMGERPI' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/emgerpi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_EMGERPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P'

UNION ALL
SELECT 
    'EMGERPI_CODIPI         ' ORGAO,
    TA.CODIGO,
    EE.CHAVE_VOBYS,
    CASE
        WHEN EE.STATUS_VOBYS = 'P' THEN 'Pendente'
        WHEN EE.STATUS_VOBYS = 'A' THEN 'Assinado'
        WHEN EE.STATUS_VOBYS = 'T' THEN 'Transmitido'
        WHEN EE.STATUS_VOBYS = 'E' THEN 'Erro'
        WHEN EE.STATUS_VOBYS = 'R' THEN 'Aprovado'
        WHEN EE.STATUS_VOBYS = 'G' THEN 'Aguardando Processamento'
        WHEN EE.STATUS_VOBYS = 'M' THEN 'Em preenchimento'
        WHEN EE.STATUS_VOBYS = 'X' THEN 'Excluido'
    END STATUS,
    EE.RECIBO,
    'https://siape.sead.pi.gov.br/org/emgerpi_codipi/esocial/envio/eventos/evento/' || EE.ID_ESOCIAL_EVENTO LINK
FROM
    SW_EMGERPI_CODIPI.ESOCIAL_EVENTO EE
    JOIN SW_PUBLICO.ESB_TIPO_ARQUIVO_ESOCIAL TA ON TA.ID_ESB_TIPO_ARQUIVO_ESOCIAL = EE.ID_ESOCIAL_TIPO_ARQUIVO
WHERE
    TA.CODIGO IN ('S-2299','S-2399')
    AND EE.STATUS_VOBYS = 'P';