SELECT
    S.*
FROM
    (
    SELECT
        'ADAPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_ADAPI.FOLHA FO
        JOIN SW_ADAPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_ADAPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_ADAPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_ADAPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'ADH' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_ADH.FOLHA FO
        JOIN SW_ADH.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_ADH.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_ADH.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_ADH.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'AGESPISA' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_AGESPISA.FOLHA FO
        JOIN SW_AGESPISA.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_AGESPISA.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_AGESPISA.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_AGESPISA.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'AGESPISA02' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_AGESPISA02.FOLHA FO
        JOIN SW_AGESPISA02.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_AGESPISA02.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_AGESPISA02.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_AGESPISA02.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'AGRESP' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_AGRESP.FOLHA FO
        JOIN SW_AGRESP.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_AGRESP.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_AGRESP.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_AGRESP.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'BEP' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_BEP.FOLHA FO
        JOIN SW_BEP.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_BEP.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_BEP.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_BEP.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'CBMPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_CBMPI.FOLHA FO
        JOIN SW_CBMPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_CBMPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_CBMPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_CBMPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'CCOM' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_CCOM.FOLHA FO
        JOIN SW_CCOM.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_CCOM.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_CCOM.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_CCOM.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'CDTER' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_CDTER.FOLHA FO
        JOIN SW_CDTER.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_CDTER.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_CDTER.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_CDTER.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'CENDROGAS' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_CENDROGAS.FOLHA FO
        JOIN SW_CENDROGAS.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_CENDROGAS.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_CENDROGAS.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_CENDROGAS.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'COFIR' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_COFIR.FOLHA FO
        JOIN SW_COFIR.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_COFIR.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_COFIR.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_COFIR.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'COJUV' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_COJUV.FOLHA FO
        JOIN SW_COJUV.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_COJUV.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_COJUV.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_COJUV.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'DEFCIVIL' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_DEFCIVIL.FOLHA FO
        JOIN SW_DEFCIVIL.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_DEFCIVIL.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_DEFCIVIL.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_DEFCIVIL.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'DER' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_DER.FOLHA FO
        JOIN SW_DER.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_DER.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_DER.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_DER.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'DETRAN' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_DETRAN.FOLHA FO
        JOIN SW_DETRAN.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_DETRAN.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_DETRAN.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_DETRAN.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'EMGERPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_EMGERPI.FOLHA FO
        JOIN SW_EMGERPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_EMGERPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_EMGERPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_EMGERPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'EMGERPI_CEASA' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_EMGERPI_CEASA.FOLHA FO
        JOIN SW_EMGERPI_CEASA.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_EMGERPI_CEASA.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_EMGERPI_CEASA.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_EMGERPI_CEASA.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'EMGERPI_CIDAPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_EMGERPI_CIDAPI.FOLHA FO
        JOIN SW_EMGERPI_CIDAPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_EMGERPI_CIDAPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_EMGERPI_CIDAPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_EMGERPI_CIDAPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'EMGERPI_CODIPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_EMGERPI_CODIPI.FOLHA FO
        JOIN SW_EMGERPI_CODIPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_EMGERPI_CODIPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_EMGERPI_CODIPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_EMGERPI_CODIPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'EMGERPI_COHAB' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_EMGERPI_COHAB.FOLHA FO
        JOIN SW_EMGERPI_COHAB.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_EMGERPI_COHAB.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_EMGERPI_COHAB.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_EMGERPI_COHAB.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'EMGERPI_COMDEPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_EMGERPI_COMDEPI.FOLHA FO
        JOIN SW_EMGERPI_COMDEPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_EMGERPI_COMDEPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_EMGERPI_COMDEPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_EMGERPI_COMDEPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'EMGERPI_COMEPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_EMGERPI_COMEPI.FOLHA FO
        JOIN SW_EMGERPI_COMEPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_EMGERPI_COMEPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_EMGERPI_COMEPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_EMGERPI_COMEPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'EMGERPI_CORESA' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_EMGERPI_CORESA.FOLHA FO
        JOIN SW_EMGERPI_CORESA.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_EMGERPI_CORESA.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_EMGERPI_CORESA.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_EMGERPI_CORESA.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'EMGERPI_EMATER' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_EMGERPI_EMATER.FOLHA FO
        JOIN SW_EMGERPI_EMATER.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_EMGERPI_EMATER.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_EMGERPI_EMATER.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_EMGERPI_EMATER.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'EMGERPI_ETELPI_FUNART' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_EMGERPI_ETELPI_FUNART.FOLHA FO
        JOIN SW_EMGERPI_ETELPI_FUNART.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_EMGERPI_ETELPI_FUNART.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_EMGERPI_ETELPI_FUNART.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_EMGERPI_ETELPI_FUNART.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'EMGERPI_PIEMTUR' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_EMGERPI_PIEMTUR.FOLHA FO
        JOIN SW_EMGERPI_PIEMTUR.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_EMGERPI_PIEMTUR.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_EMGERPI_PIEMTUR.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_EMGERPI_PIEMTUR.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'EMGERPI_PRODEPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_EMGERPI_PRODEPI.FOLHA FO
        JOIN SW_EMGERPI_PRODEPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_EMGERPI_PRODEPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_EMGERPI_PRODEPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_EMGERPI_PRODEPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'FAPEPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_FAPEPI.FOLHA FO
        JOIN SW_FAPEPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_FAPEPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_FAPEPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_FAPEPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'FESPPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_FESPPI.FOLHA FO
        JOIN SW_FESPPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_FESPPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_FESPPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_FESPPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'FUESPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_FUESPI.FOLHA FO
        JOIN SW_FUESPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_FUESPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_FUESPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_FUESPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'FUNPREV' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_FUNPREV.FOLHA FO
        JOIN SW_FUNPREV.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_FUNPREV.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_FUNPREV.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_FUNPREV.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'FUPIP' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_FUPIP.FOLHA FO
        JOIN SW_FUPIP.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_FUPIP.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_FUPIP.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_FUPIP.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'GMG' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_GMG.FOLHA FO
        JOIN SW_GMG.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_GMG.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_GMG.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_GMG.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'IASPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_IASPI.FOLHA FO
        JOIN SW_IASPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_IASPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_IASPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_IASPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'IDEPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_IDEPI.FOLHA FO
        JOIN SW_IDEPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_IDEPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_IDEPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_IDEPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'IMEPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_IMEPI.FOLHA FO
        JOIN SW_IMEPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_IMEPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_IMEPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_IMEPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'IMEPIPROD' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_IMEPIPROD.FOLHA FO
        JOIN SW_IMEPIPROD.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_IMEPIPROD.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_IMEPIPROD.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_IMEPIPROD.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'INTERPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_INTERPI.FOLHA FO
        JOIN SW_INTERPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_INTERPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_INTERPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_INTERPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'JUCEPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_JUCEPI.FOLHA FO
        JOIN SW_JUCEPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_JUCEPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_JUCEPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_JUCEPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'METRO' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_METRO.FOLHA FO
        JOIN SW_METRO.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_METRO.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_METRO.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_METRO.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'PGEPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_PGEPI.FOLHA FO
        JOIN SW_PGEPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_PGEPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_PGEPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_PGEPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'PMPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_PMPI.FOLHA FO
        JOIN SW_PMPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_PMPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_PMPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_PMPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SADA' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SADA.FOLHA FO
        JOIN SW_SADA.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SADA.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SADA.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SADA.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SAF' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SAF.FOLHA FO
        JOIN SW_SAF.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SAF.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SAF.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SAF.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SASC' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SASC.FOLHA FO
        JOIN SW_SASC.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SASC.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SASC.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SASC.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SEADPREVPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SEADPREVPI.FOLHA FO
        JOIN SW_SEADPREVPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SEADPREVPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SEADPREVPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SEADPREVPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SEAGRO' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SEAGRO.FOLHA FO
        JOIN SW_SEAGRO.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SEAGRO.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SEAGRO.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SEAGRO.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SECESP' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SECESP.FOLHA FO
        JOIN SW_SECESP.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SECESP.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SECESP.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SECESP.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SECID' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SECID.FOLHA FO
        JOIN SW_SECID.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SECID.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SECID.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SECID.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SECMULHERES' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SECMULHERES.FOLHA FO
        JOIN SW_SECMULHERES.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SECMULHERES.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SECMULHERES.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SECMULHERES.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SECULT' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SECULT.FOLHA FO
        JOIN SW_SECULT.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SECULT.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SECULT.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SECULT.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SEDET' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SEDET.FOLHA FO
        JOIN SW_SEDET.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SEDET.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SEDET.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SEDET.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SEDUC' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SEDUC.FOLHA FO
        JOIN SW_SEDUC.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SEDUC.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SEDUC.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SEDUC.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SEFAZPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SEFAZPI.FOLHA FO
        JOIN SW_SEFAZPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SEFAZPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SEFAZPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SEFAZPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SEGOV' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SEGOV.FOLHA FO
        JOIN SW_SEGOV.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SEGOV.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SEGOV.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SEGOV.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SEID' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SEID.FOLHA FO
        JOIN SW_SEID.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SEID.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SEID.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SEID.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SEINFRA' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SEINFRA.FOLHA FO
        JOIN SW_SEINFRA.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SEINFRA.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SEINFRA.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SEINFRA.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SEJUSPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SEJUSPI.FOLHA FO
        JOIN SW_SEJUSPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SEJUSPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SEJUSPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SEJUSPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SEMAR' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SEMAR.FOLHA FO
        JOIN SW_SEMAR.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SEMAR.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SEMAR.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SEMAR.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SEMINPER' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SEMINPER.FOLHA FO
        JOIN SW_SEMINPER.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SEMINPER.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SEMINPER.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SEMINPER.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SEPLAN' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SEPLAN.FOLHA FO
        JOIN SW_SEPLAN.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SEPLAN.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SEPLAN.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SEPLAN.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SERES' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SERES.FOLHA FO
        JOIN SW_SERES.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SERES.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SERES.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SERES.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SESAPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SESAPI.FOLHA FO
        JOIN SW_SESAPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SESAPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SESAPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SESAPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SETRANS' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SETRANS.FOLHA FO
        JOIN SW_SETRANS.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SETRANS.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SETRANS.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SETRANS.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SETRE' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SETRE.FOLHA FO
        JOIN SW_SETRE.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SETRE.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SETRE.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SETRE.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SETUR' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SETUR.FOLHA FO
        JOIN SW_SETUR.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SETUR.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SETUR.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SETUR.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SIA' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SIA.FOLHA FO
        JOIN SW_SIA.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SIA.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SIA.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SIA.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SSPPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SSPPI.FOLHA FO
        JOIN SW_SSPPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SSPPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SSPPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SSPPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'SURPI' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_SURPI.FOLHA FO
        JOIN SW_SURPI.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_SURPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_SURPI.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_SURPI.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'TVANTARES' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_TVANTARES.FOLHA FO
        JOIN SW_TVANTARES.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_TVANTARES.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_TVANTARES.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_TVANTARES.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026

UNION ALL

    SELECT
        'VICEGOV' ORGAO,
        FO.CHAVE_FOLHA,
        FF.COD_INSTITUCIONAL MATRICULA,
        PDC.CPF_PESSOA CPF,
        HN.NOME,
        PD.NOME_DIVISAO DIVISAO,
        PS.NOME_SITUACAO SITUACAO,
        IG.INDMV MULTIPLOS_VINCULOS,
        IG.MV_VLR_REM_OE VALOR_MULT_VINC,
        CASE 
            WHEN IG.INDMV = 'V1' THEN '1-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a remuneração por ele informada o percentual da’s’ alíquota’s’ será’ão’ obtido’s’ considerando a remuneração total do trabalhador.'
            WHEN IG.INDMV = 'V2' THEN '2-O declarante aplica a’s’ alíquota’s’ de desconto do segurado sobre a diferença entre o limite máximo do salário de contribuição e a remuneração de outra’s’ empresa’s’ para as quais o trabalhador informou que houve o desconto.'
            WHEN IG.INDMV = 'V3' THEN '3-O declarante não realiza desconto do segurado, uma vez que houve desconto sobre o limite máximo de salário de contribuição em outra’s’ empresas’'
            ELSE NULL
        END IND_DESCONTO_CONTRI_PREV,
        IG.MV_TP_INSC TIPO_INSCRICAO,
        IG.MV_NR_INSC NUMERO_INSCRICAO_CNPJ,
        IG.MV_COD_CATEG COD_CATEG_TRABALHADOR,
        IG.MV_VLR_REM_OE VALOR_REMUNERACAO
        --'UPDATE SW_ADAPI.FUNCIONARIO_INF_GOVERNO SET MV_VLR_REM_OE = NULL WHERE ID_FUNCIONARIO = ' || IG.ID_FUNCIONARIO AS UPDATE_CONCAT
    FROM
        SW_VICEGOV.FOLHA FO
        JOIN SW_VICEGOV.FOLHA_FUNC FF ON FF.ID_FOLHA = FO.ID_FOLHA
        LEFT JOIN SW_VICEGOV.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FF.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
        LEFT JOIN SW_VICEGOV.RHB_PERFIL P ON P.ID_PERFIL = FP.ID_PERFIL
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_DIVISAO PD ON PD.ID_DIVISAO = P.ID_DIVISAO
        LEFT JOIN SW_PUBLICO.RHB_PERFIL_SITUACAO PS ON PS.ID_SITUACAO = P.ID_SITUACAO
        LEFT JOIN SW_VICEGOV.FUNCIONARIO_INF_GOVERNO IG ON IG.ID_FUNCIONARIO = FF.ID_FUNCIONARIO
        JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND PDC.DATA_BAIXA IS NULL
        JOIN SW_PUBLICO.PESSOA_HISTORICO_NOMES HN ON HN.ID_PESSOA = FF.ID_PESSOA_FUNCIONARIO AND HN.DATA_FIM IS NULL
    WHERE
        FO.MES = 9
        AND FO.ANO = 2026
) S
ORDER BY
    S.CPF,
    S.ORGAO