-- RELAT�RIO GRUPOS MENSAL

WITH TABELA_AUX AS (
	SELECT
		X.ORGAO,
		X.ID_FUNCIONARIO,
		X.ID_FOLHA_FUNCIONARIO,
		X.MATRICULA,
		X.CPF,
		X.COD_GRUPO,
		X.DESCRICAO_GRUPO,
		X.TIPO_RELATORIO,
		CASE
			WHEN X.COD_RUBRICA IN (714100, 714110) THEN 'BASE'
			WHEN X.COD_RUBRICA_LEGADO IN ('901') THEN 'FUNDO'
			WHEN X.COD_RUBRICA IN (714400, 714405, 714410, 714420) THEN 'PATRONAL'
			WHEN X.COD_RUBRICA IN (999997) THEN 'BRUTO'
		END AS TIPO_RUBRICA,
		X.VALOR_CALCULADO
	FROM
		(
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ADAPI'
                JOIN SW_ADAPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_ADAPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_ADAPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_ADAPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_ADAPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_ADAPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_ADAPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_ADAPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_ADAPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_ADAPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ADH'
                JOIN SW_ADH.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_ADH.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_ADH.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_ADH.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_ADH.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_ADH.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_ADH.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_ADH.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_ADH.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_ADH.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'AGESPISA'
                JOIN SW_AGESPISA.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_AGESPISA.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_AGESPISA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_AGESPISA.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_AGESPISA.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_AGESPISA.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_AGESPISA.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_AGESPISA.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_AGESPISA.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_AGESPISA.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'AGRESP'
                JOIN SW_AGRESP.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_AGRESP.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_AGRESP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_AGRESP.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_AGRESP.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_AGRESP.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_AGRESP.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_AGRESP.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_AGRESP.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_AGRESP.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ATIPI'
                JOIN SW_ATIPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_ATIPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_ATIPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_ATIPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_ATIPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_ATIPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_ATIPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_ATIPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_ATIPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_ATIPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CBMPI'
                JOIN SW_CBMPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_CBMPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_CBMPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CBMPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_CBMPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_CBMPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_CBMPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_CBMPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_CBMPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_CBMPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CCOM'
                JOIN SW_CCOM.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_CCOM.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_CCOM.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CCOM.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_CCOM.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_CCOM.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_CCOM.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_CCOM.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_CCOM.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_CCOM.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CDTER'
                JOIN SW_CDTER.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_CDTER.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_CDTER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CDTER.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_CDTER.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_CDTER.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_CDTER.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_CDTER.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_CDTER.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_CDTER.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CENDROGAS'
                JOIN SW_CENDROGAS.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_CENDROGAS.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_CENDROGAS.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CENDROGAS.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_CENDROGAS.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_CENDROGAS.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_CENDROGAS.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_CENDROGAS.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_CENDROGAS.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_CENDROGAS.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'COFIR'
                JOIN SW_COFIR.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_COFIR.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_COFIR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_COFIR.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_COFIR.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_COFIR.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_COFIR.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_COFIR.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_COFIR.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_COFIR.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'COJUV'
                JOIN SW_COJUV.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_COJUV.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_COJUV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_COJUV.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_COJUV.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_COJUV.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_COJUV.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_COJUV.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_COJUV.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_COJUV.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CPVCI'
                JOIN SW_CPVCI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_CPVCI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_CPVCI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CPVCI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_CPVCI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_CPVCI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_CPVCI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_CPVCI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_CPVCI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_CPVCI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DEFCIVIL'
                JOIN SW_DEFCIVIL.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_DEFCIVIL.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_DEFCIVIL.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_DEFCIVIL.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_DEFCIVIL.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_DEFCIVIL.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_DEFCIVIL.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_DEFCIVIL.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_DEFCIVIL.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_DEFCIVIL.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DER'
                JOIN SW_DER.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_DER.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_DER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_DER.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_DER.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_DER.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_DER.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_DER.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_DER.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_DER.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DETRAN'
                JOIN SW_DETRAN.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_DETRAN.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_DETRAN.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_DETRAN.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_DETRAN.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_DETRAN.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_DETRAN.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_DETRAN.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_DETRAN.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_DETRAN.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMATERPROD'
                JOIN SW_EMATERPROD.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_EMATERPROD.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_EMATERPROD.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_EMATERPROD.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_EMATERPROD.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_EMATERPROD.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_EMATERPROD.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_EMATERPROD.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_EMATERPROD.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_EMATERPROD.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FAPEPI'
                JOIN SW_FAPEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_FAPEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_FAPEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_FAPEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_FAPEPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_FAPEPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_FAPEPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_FAPEPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_FAPEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_FAPEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FUESPI'
                JOIN SW_FUESPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_FUESPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_FUESPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_FUESPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_FUESPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_FUESPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_FUESPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_FUESPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_FUESPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_FUESPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FUPIP'
                JOIN SW_FUPIP.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_FUPIP.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_FUPIP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_FUPIP.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_FUPIP.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_FUPIP.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_FUPIP.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_FUPIP.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_FUPIP.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_FUPIP.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'GMG'
                JOIN SW_GMG.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_GMG.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_GMG.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_GMG.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_GMG.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_GMG.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_GMG.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_GMG.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_GMG.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_GMG.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IASPI'
                JOIN SW_IASPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_IASPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_IASPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_IASPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_IASPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_IASPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_IASPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_IASPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_IASPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_IASPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IDEPI'
                JOIN SW_IDEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_IDEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_IDEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_IDEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_IDEPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_IDEPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_IDEPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_IDEPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_IDEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_IDEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IMEPI'
                JOIN SW_IMEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_IMEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_IMEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_IMEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_IMEPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_IMEPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_IMEPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_IMEPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_IMEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_IMEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IMEPIPROD'
                JOIN SW_IMEPIPROD.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_IMEPIPROD.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_IMEPIPROD.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_IMEPIPROD.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_IMEPIPROD.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_IMEPIPROD.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_IMEPIPROD.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_IMEPIPROD.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_IMEPIPROD.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_IMEPIPROD.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'INTERPI'
                JOIN SW_INTERPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_INTERPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_INTERPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_INTERPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_INTERPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_INTERPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_INTERPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_INTERPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_INTERPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_INTERPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'JUCEPI'
                JOIN SW_JUCEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_JUCEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_JUCEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_JUCEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_JUCEPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_JUCEPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_JUCEPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_JUCEPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_JUCEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_JUCEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'METRO'
                JOIN SW_METRO.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_METRO.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_METRO.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_METRO.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_METRO.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_METRO.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_METRO.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_METRO.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_METRO.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_METRO.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'PGEPI'
                JOIN SW_PGEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_PGEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_PGEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_PGEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_PGEPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_PGEPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_PGEPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_PGEPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_PGEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_PGEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'PMPI'
                JOIN SW_PMPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_PMPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_PMPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_PMPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_PMPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_PMPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_PMPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_PMPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_PMPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_PMPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SADA'
                JOIN SW_SADA.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SADA.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SADA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SADA.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SADA.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SADA.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SADA.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SADA.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SADA.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SADA.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SAF'
                JOIN SW_SAF.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SAF.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SAF.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SAF.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SAF.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SAF.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SAF.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SAF.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SAF.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SAF.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SASC'
                JOIN SW_SASC.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SASC.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SASC.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SASC.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SASC.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SASC.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SASC.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SASC.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SASC.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SASC.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEADPREVPI'
                JOIN SW_SEADPREVPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEADPREVPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEADPREVPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEADPREVPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEADPREVPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEADPREVPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEADPREVPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEADPREVPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEADPREVPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEADPREVPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEAGRO'
                JOIN SW_SEAGRO.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEAGRO.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEAGRO.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEAGRO.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEAGRO.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEAGRO.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEAGRO.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEAGRO.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEAGRO.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEAGRO.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECESP'
                JOIN SW_SECESP.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SECESP.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SECESP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SECESP.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SECESP.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SECESP.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SECESP.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SECESP.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SECESP.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SECESP.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECID'
                JOIN SW_SECID.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SECID.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SECID.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SECID.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SECID.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SECID.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SECID.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SECID.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SECID.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SECID.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECMULHERES'
                JOIN SW_SECMULHERES.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SECMULHERES.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SECMULHERES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SECMULHERES.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SECMULHERES.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SECMULHERES.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SECMULHERES.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SECMULHERES.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SECMULHERES.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SECMULHERES.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECULT'
                JOIN SW_SECULT.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SECULT.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SECULT.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SECULT.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SECULT.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SECULT.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SECULT.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SECULT.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SECULT.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SECULT.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEDET'
                JOIN SW_SEDET.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEDET.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEDET.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEDET.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEDET.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEDET.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEDET.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEDET.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEDET.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEDET.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEDUC'
                JOIN SW_SEDUC.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEDUC.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEDUC.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEDUC.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEDUC.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEDUC.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEDUC.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEDUC.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEDUC.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEDUC.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEFAZPI'
                JOIN SW_SEFAZPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEFAZPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEFAZPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEFAZPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEFAZPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEFAZPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEFAZPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEFAZPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEFAZPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEFAZPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEGOV'
                JOIN SW_SEGOV.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEGOV.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEGOV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEGOV.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEGOV.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEGOV.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEGOV.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEGOV.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEGOV.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEGOV.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEID'
                JOIN SW_SEID.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEID.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEID.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEID.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEID.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEID.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEID.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEID.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEID.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEID.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEINFRA'
                JOIN SW_SEINFRA.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEINFRA.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEINFRA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEINFRA.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEINFRA.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEINFRA.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEINFRA.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEINFRA.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEINFRA.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEINFRA.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEJUSPI'
                JOIN SW_SEJUSPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEJUSPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEJUSPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEJUSPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEJUSPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEJUSPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEJUSPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEJUSPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEJUSPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEJUSPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEMAR'
                JOIN SW_SEMAR.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEMAR.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEMAR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEMAR.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEMAR.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEMAR.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEMAR.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEMAR.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEMAR.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEMAR.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEMINPER'
                JOIN SW_SEMINPER.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEMINPER.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEMINPER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEMINPER.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEMINPER.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEMINPER.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEMINPER.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEMINPER.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEMINPER.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEMINPER.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEPLAN'
                JOIN SW_SEPLAN.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEPLAN.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEPLAN.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEPLAN.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEPLAN.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEPLAN.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEPLAN.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEPLAN.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEPLAN.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEPLAN.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SERES'
                JOIN SW_SERES.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SERES.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SERES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SERES.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SERES.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SERES.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SERES.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SERES.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SERES.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SERES.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SESAPI'
                JOIN SW_SESAPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SESAPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SESAPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SESAPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SESAPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SESAPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SESAPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SESAPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SESAPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SESAPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SETRANS'
                JOIN SW_SETRANS.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SETRANS.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SETRANS.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SETRANS.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SETRANS.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SETRANS.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SETRANS.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SETRANS.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SETRANS.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SETRANS.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SETUR'
                JOIN SW_SETUR.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SETUR.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SETUR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SETUR.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SETUR.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SETUR.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SETUR.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SETUR.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SETUR.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SETUR.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SSPPI'
                JOIN SW_SSPPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SSPPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SSPPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SSPPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SSPPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SSPPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SSPPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SSPPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SSPPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SSPPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SURPI'
                JOIN SW_SURPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SURPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SURPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SURPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SURPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SURPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SURPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SURPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SURPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SURPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'TVANTARES'
                JOIN SW_TVANTARES.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_TVANTARES.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_TVANTARES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_TVANTARES.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_TVANTARES.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_TVANTARES.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_TVANTARES.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_TVANTARES.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_TVANTARES.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_TVANTARES.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'VICEGOV'
                JOIN SW_VICEGOV.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_VICEGOV.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_VICEGOV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_VICEGOV.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_VICEGOV.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_VICEGOV.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_VICEGOV.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_VICEGOV.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_VICEGOV.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_VICEGOV.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND (
                        FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997)
                )
        ) X
)
SELECT
	BRUTO.ORGAO                                                                 AS "CODIGO EMPRESA",
        CASE
        WHEN
        BASE.IND_CONTRIBUICAO = 'S'
        OR FUNDO.IND_CONTRIBUICAO = 'S'
        OR PATRONAL.IND_CONTRIBUICAO = 'S'
        THEN 'S'
        ELSE 'N'
        END                                                                         AS IND_CONTRIBUICAO,
	COUNT(DISTINCT BRUTO.MATRICULA)                                             AS "CONTRACHEQUES",
	COUNT(DISTINCT BRUTO.CPF)                                                   AS "CPFs",
	BRUTO.COD_GRUPO                                                             AS "CODIGO GRUPO",
	BRUTO.DESCRICAO_GRUPO                                                       AS "GRUPO",
	CASE BRUTO.TIPO_RELATORIO
		WHEN 'E' THEN 'EXECUTIVO'
		ELSE 'OUTROS PODERES'
	END                                                                         AS "TIPO DE RELATORIO",
	NVL(SUM(BASE.VALOR_CALCULADO), 0)                                           AS "VALOR BASE",
	NVL(SUM(FUNDO.VALOR_CALCULADO), 0)                                          AS "VALOR FUNDO",
	NVL(SUM(PATRONAL.VALOR_CALCULADO), 0)                                       AS "VALOR 28%",
	NVL(SUM(FUNDO.VALOR_CALCULADO), 0) + NVL(SUM(PATRONAL.VALOR_CALCULADO), 0)  AS "REPASSE",
	NVL(SUM(BRUTO.VALOR_CALCULADO), 0)                                          AS "VALOR BRUTO"
FROM
	(
		SELECT
			BRUTO.ORGAO,
			BRUTO.ID_FUNCIONARIO,
			BRUTO.MATRICULA,
			BRUTO.CPF,
			BRUTO.COD_GRUPO,
			BRUTO.DESCRICAO_GRUPO,
			BRUTO.TIPO_RELATORIO,
			SUM(BRUTO.VALOR_CALCULADO) AS VALOR_CALCULADO
		FROM
			TABELA_AUX BRUTO
		WHERE
			BRUTO.TIPO_RUBRICA = 'BRUTO'
		GROUP BY
			BRUTO.ORGAO,
			BRUTO.ID_FUNCIONARIO,
			BRUTO.MATRICULA,
			BRUTO.CPF,
			BRUTO.COD_GRUPO,
			BRUTO.DESCRICAO_GRUPO,
			BRUTO.TIPO_RELATORIO
	) BRUTO
	LEFT JOIN (
		SELECT
			FUNDO.ORGAO,
			FUNDO.ID_FUNCIONARIO,
			FUNDO.MATRICULA,
			FUNDO.CPF,
			FUNDO.COD_GRUPO,
			FUNDO.DESCRICAO_GRUPO,
			FUNDO.TIPO_RELATORIO,
			SUM(FUNDO.VALOR_CALCULADO) AS VALOR_CALCULADO,
                        CASE
                                WHEN SUM(FUNDO.VALOR_CALCULADO) = 0 THEN 'N'
                                ELSE 'S'
                        END AS IND_CONTRIBUICAO
		FROM
			TABELA_AUX FUNDO
		WHERE
			FUNDO.TIPO_RUBRICA = 'FUNDO'
		GROUP BY
			FUNDO.ORGAO,
			FUNDO.ID_FUNCIONARIO,
			FUNDO.MATRICULA,
			FUNDO.CPF,
			FUNDO.COD_GRUPO,
			FUNDO.DESCRICAO_GRUPO,
			FUNDO.TIPO_RELATORIO
	) FUNDO ON FUNDO.ORGAO = BRUTO.ORGAO
            AND FUNDO.MATRICULA = BRUTO.MATRICULA
            AND FUNDO.CPF = BRUTO.CPF
            AND FUNDO.ID_FUNCIONARIO = BRUTO.ID_FUNCIONARIO
            AND FUNDO.COD_GRUPO = BRUTO.COD_GRUPO
	LEFT JOIN (
		SELECT
			PATRONAL.ORGAO,
			PATRONAL.ID_FUNCIONARIO,
			PATRONAL.MATRICULA,
			PATRONAL.CPF,
			PATRONAL.COD_GRUPO,
			PATRONAL.DESCRICAO_GRUPO,
			PATRONAL.TIPO_RELATORIO,
			SUM(PATRONAL.VALOR_CALCULADO) AS VALOR_CALCULADO,
                        CASE
                                WHEN SUM(PATRONAL.VALOR_CALCULADO) = 0 THEN 'N'
                                ELSE 'S'
                        END AS IND_CONTRIBUICAO
		FROM
			TABELA_AUX PATRONAL
		WHERE
			PATRONAL.TIPO_RUBRICA = 'PATRONAL'
		GROUP BY
			PATRONAL.ORGAO,
			PATRONAL.ID_FUNCIONARIO,
			PATRONAL.MATRICULA,
			PATRONAL.CPF,
			PATRONAL.COD_GRUPO,
			PATRONAL.DESCRICAO_GRUPO,
			PATRONAL.TIPO_RELATORIO
	) PATRONAL ON PATRONAL.ORGAO = BRUTO.ORGAO
            AND PATRONAL.MATRICULA = BRUTO.MATRICULA
            AND PATRONAL.CPF = BRUTO.CPF
            AND PATRONAL.ID_FUNCIONARIO = BRUTO.ID_FUNCIONARIO
            AND PATRONAL.COD_GRUPO = BRUTO.COD_GRUPO
	LEFT JOIN (
		SELECT
			BASE.ORGAO,
			BASE.ID_FUNCIONARIO,
			BASE.MATRICULA,
			BASE.CPF,
			BASE.COD_GRUPO,
			BASE.DESCRICAO_GRUPO,
			BASE.TIPO_RELATORIO,
			SUM(BASE.VALOR_CALCULADO) AS VALOR_CALCULADO,
                        CASE
                                WHEN SUM(BASE.VALOR_CALCULADO) = 0 THEN 'N'
                                ELSE 'S'
                        END AS IND_CONTRIBUICAO
		FROM
			TABELA_AUX BASE
		WHERE
            BASE.TIPO_RUBRICA = 'BASE'
		GROUP BY
			BASE.ORGAO,
			BASE.ID_FUNCIONARIO,
			BASE.MATRICULA,
			BASE.CPF,
			BASE.COD_GRUPO,
			BASE.DESCRICAO_GRUPO,
			BASE.TIPO_RELATORIO
	) BASE ON BASE.ORGAO = BRUTO.ORGAO
            AND BASE.MATRICULA = BRUTO.MATRICULA
            AND BASE.CPF = BRUTO.CPF
            AND BASE.ID_FUNCIONARIO = BRUTO.ID_FUNCIONARIO
            AND BASE.COD_GRUPO = BRUTO.COD_GRUPO
GROUP BY
	BRUTO.ORGAO,
	BRUTO.COD_GRUPO,
	BRUTO.DESCRICAO_GRUPO,
	BRUTO.TIPO_RELATORIO,
        BASE.IND_CONTRIBUICAO,
        FUNDO.IND_CONTRIBUICAO,
        PATRONAL.IND_CONTRIBUICAO
ORDER BY
	BRUTO.ORGAO,
	BRUTO.COD_GRUPO,
	BRUTO.DESCRICAO_GRUPO,
	BRUTO.TIPO_RELATORIO;


-- RELAT�RIO GRUPOS NATAL

WITH TABELA_AUX AS (
	SELECT
		X.ORGAO,
		X.ID_FUNCIONARIO,
		X.ID_FOLHA_FUNCIONARIO,
		X.MATRICULA,
		X.CPF,
		X.COD_GRUPO,
		X.DESCRICAO_GRUPO,
		X.TIPO_RELATORIO,
		CASE
            WHEN X.COD_RUBRICA IN (714250) THEN 'BASE' 
            WHEN X.COD_RUBRICA_LEGADO IN ('900') THEN 'FUNDO' 
            WHEN X.COD_RUBRICA IN (714450, 714455, 714460) THEN 'PATRONAL' 
            WHEN X.COD_RUBRICA IN (999997) THEN 'BRUTO' 
		END AS TIPO_RUBRICA,
		X.VALOR_CALCULADO
	FROM
		(
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ADAPI'
            JOIN SW_ADAPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_ADAPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_ADAPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_ADAPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_ADAPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_ADAPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_ADAPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_ADAPI.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_ADAPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_ADAPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ADH'
            JOIN SW_ADH.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_ADH.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_ADH.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_ADH.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_ADH.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_ADH.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_ADH.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_ADH.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_ADH.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_ADH.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'AGESPISA'
            JOIN SW_AGESPISA.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_AGESPISA.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_AGESPISA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_AGESPISA.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_AGESPISA.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_AGESPISA.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_AGESPISA.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_AGESPISA.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_AGESPISA.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_AGESPISA.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'AGRESP'
            JOIN SW_AGRESP.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_AGRESP.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_AGRESP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_AGRESP.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_AGRESP.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_AGRESP.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_AGRESP.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_AGRESP.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_AGRESP.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_AGRESP.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ATIPI'
            JOIN SW_ATIPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_ATIPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_ATIPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_ATIPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_ATIPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_ATIPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_ATIPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_ATIPI.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_ATIPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_ATIPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CBMPI'
            JOIN SW_CBMPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_CBMPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_CBMPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_CBMPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_CBMPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_CBMPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_CBMPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_CBMPI.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_CBMPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_CBMPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CCOM'
            JOIN SW_CCOM.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_CCOM.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_CCOM.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_CCOM.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_CCOM.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_CCOM.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_CCOM.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_CCOM.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_CCOM.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_CCOM.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CDTER'
            JOIN SW_CDTER.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_CDTER.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_CDTER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_CDTER.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_CDTER.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_CDTER.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_CDTER.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_CDTER.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_CDTER.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_CDTER.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CENDROGAS'
            JOIN SW_CENDROGAS.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_CENDROGAS.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_CENDROGAS.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_CENDROGAS.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_CENDROGAS.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_CENDROGAS.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_CENDROGAS.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_CENDROGAS.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_CENDROGAS.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_CENDROGAS.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'COFIR'
            JOIN SW_COFIR.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_COFIR.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_COFIR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_COFIR.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_COFIR.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_COFIR.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_COFIR.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_COFIR.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_COFIR.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_COFIR.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'COJUV'
            JOIN SW_COJUV.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_COJUV.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_COJUV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_COJUV.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_COJUV.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_COJUV.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_COJUV.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_COJUV.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_COJUV.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_COJUV.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CPVCI'
            JOIN SW_CPVCI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_CPVCI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_CPVCI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_CPVCI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_CPVCI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_CPVCI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_CPVCI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_CPVCI.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_CPVCI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_CPVCI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DEFCIVIL'
            JOIN SW_DEFCIVIL.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_DEFCIVIL.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_DEFCIVIL.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_DEFCIVIL.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_DEFCIVIL.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_DEFCIVIL.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_DEFCIVIL.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_DEFCIVIL.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_DEFCIVIL.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_DEFCIVIL.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DER'
            JOIN SW_DER.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_DER.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_DER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_DER.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_DER.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_DER.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_DER.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_DER.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_DER.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_DER.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DETRAN'
            JOIN SW_DETRAN.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_DETRAN.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_DETRAN.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_DETRAN.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_DETRAN.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_DETRAN.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_DETRAN.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_DETRAN.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_DETRAN.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_DETRAN.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMATERPROD'
            JOIN SW_EMATERPROD.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_EMATERPROD.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_EMATERPROD.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_EMATERPROD.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_EMATERPROD.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_EMATERPROD.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_EMATERPROD.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_EMATERPROD.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_EMATERPROD.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_EMATERPROD.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FAPEPI'
            JOIN SW_FAPEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_FAPEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_FAPEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_FAPEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_FAPEPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_FAPEPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_FAPEPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_FAPEPI.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_FAPEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_FAPEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FUESPI'
            JOIN SW_FUESPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_FUESPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_FUESPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_FUESPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_FUESPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_FUESPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_FUESPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_FUESPI.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_FUESPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_FUESPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FUPIP'
            JOIN SW_FUPIP.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_FUPIP.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_FUPIP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_FUPIP.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_FUPIP.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_FUPIP.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_FUPIP.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_FUPIP.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_FUPIP.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_FUPIP.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'GMG'
            JOIN SW_GMG.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_GMG.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_GMG.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_GMG.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_GMG.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_GMG.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_GMG.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_GMG.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_GMG.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_GMG.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IASPI'
            JOIN SW_IASPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_IASPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_IASPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_IASPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_IASPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_IASPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_IASPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_IASPI.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_IASPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_IASPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IDEPI'
            JOIN SW_IDEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_IDEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_IDEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_IDEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_IDEPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_IDEPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_IDEPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_IDEPI.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_IDEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_IDEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IMEPI'
            JOIN SW_IMEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_IMEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_IMEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_IMEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_IMEPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_IMEPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_IMEPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_IMEPI.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_IMEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_IMEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IMEPIPROD'
            JOIN SW_IMEPIPROD.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_IMEPIPROD.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_IMEPIPROD.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_IMEPIPROD.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_IMEPIPROD.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_IMEPIPROD.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_IMEPIPROD.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_IMEPIPROD.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_IMEPIPROD.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_IMEPIPROD.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'INTERPI'
            JOIN SW_INTERPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_INTERPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_INTERPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_INTERPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_INTERPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_INTERPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_INTERPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_INTERPI.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_INTERPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_INTERPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'JUCEPI'
            JOIN SW_JUCEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_JUCEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_JUCEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_JUCEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_JUCEPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_JUCEPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_JUCEPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_JUCEPI.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_JUCEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_JUCEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'METRO'
            JOIN SW_METRO.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_METRO.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_METRO.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_METRO.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_METRO.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_METRO.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_METRO.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_METRO.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_METRO.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_METRO.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'PGEPI'
            JOIN SW_PGEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_PGEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_PGEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_PGEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_PGEPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_PGEPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_PGEPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_PGEPI.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_PGEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_PGEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'PMPI'
            JOIN SW_PMPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_PMPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_PMPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_PMPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_PMPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_PMPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_PMPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_PMPI.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_PMPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_PMPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SADA'
            JOIN SW_SADA.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SADA.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SADA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SADA.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SADA.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SADA.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SADA.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SADA.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SADA.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SADA.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SAF'
            JOIN SW_SAF.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SAF.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SAF.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SAF.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SAF.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SAF.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SAF.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SAF.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SAF.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SAF.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SASC'
            JOIN SW_SASC.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SASC.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SASC.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SASC.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SASC.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SASC.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SASC.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SASC.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SASC.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SASC.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEADPREVPI'
            JOIN SW_SEADPREVPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEADPREVPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEADPREVPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEADPREVPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SEADPREVPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SEADPREVPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SEADPREVPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SEADPREVPI.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SEADPREVPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEADPREVPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEAGRO'
            JOIN SW_SEAGRO.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEAGRO.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEAGRO.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEAGRO.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SEAGRO.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SEAGRO.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SEAGRO.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SEAGRO.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SEAGRO.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEAGRO.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECESP'
            JOIN SW_SECESP.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SECESP.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SECESP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SECESP.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SECESP.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SECESP.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SECESP.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SECESP.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SECESP.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SECESP.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECID'
            JOIN SW_SECID.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SECID.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SECID.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SECID.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SECID.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SECID.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SECID.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SECID.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SECID.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SECID.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECMULHERES'
            JOIN SW_SECMULHERES.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SECMULHERES.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SECMULHERES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SECMULHERES.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SECMULHERES.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SECMULHERES.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SECMULHERES.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SECMULHERES.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SECMULHERES.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SECMULHERES.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECULT'
            JOIN SW_SECULT.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SECULT.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SECULT.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SECULT.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SECULT.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SECULT.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SECULT.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SECULT.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SECULT.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SECULT.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEDET'
            JOIN SW_SEDET.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEDET.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEDET.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEDET.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SEDET.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SEDET.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SEDET.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SEDET.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SEDET.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEDET.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEDUC'
            JOIN SW_SEDUC.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEDUC.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEDUC.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEDUC.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SEDUC.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SEDUC.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SEDUC.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SEDUC.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SEDUC.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEDUC.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEFAZPI'
            JOIN SW_SEFAZPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEFAZPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEFAZPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEFAZPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SEFAZPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SEFAZPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SEFAZPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SEFAZPI.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SEFAZPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEFAZPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEGOV'
            JOIN SW_SEGOV.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEGOV.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEGOV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEGOV.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SEGOV.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SEGOV.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SEGOV.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SEGOV.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SEGOV.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEGOV.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEID'
            JOIN SW_SEID.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEID.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEID.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEID.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SEID.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SEID.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SEID.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SEID.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SEID.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEID.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEINFRA'
            JOIN SW_SEINFRA.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEINFRA.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEINFRA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEINFRA.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SEINFRA.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SEINFRA.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SEINFRA.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SEINFRA.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SEINFRA.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEINFRA.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEJUSPI'
            JOIN SW_SEJUSPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEJUSPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEJUSPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEJUSPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SEJUSPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SEJUSPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SEJUSPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SEJUSPI.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SEJUSPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEJUSPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEMAR'
            JOIN SW_SEMAR.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEMAR.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEMAR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEMAR.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SEMAR.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SEMAR.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SEMAR.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SEMAR.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SEMAR.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEMAR.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEMINPER'
            JOIN SW_SEMINPER.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEMINPER.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEMINPER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEMINPER.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SEMINPER.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SEMINPER.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SEMINPER.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SEMINPER.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SEMINPER.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEMINPER.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEPLAN'
            JOIN SW_SEPLAN.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEPLAN.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEPLAN.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEPLAN.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SEPLAN.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SEPLAN.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SEPLAN.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SEPLAN.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SEPLAN.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEPLAN.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SERES'
            JOIN SW_SERES.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SERES.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SERES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SERES.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SERES.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SERES.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SERES.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SERES.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SERES.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SERES.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SESAPI'
            JOIN SW_SESAPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SESAPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SESAPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SESAPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SESAPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SESAPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SESAPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SESAPI.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SESAPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SESAPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SETRANS'
            JOIN SW_SETRANS.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SETRANS.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SETRANS.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SETRANS.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SETRANS.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SETRANS.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SETRANS.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SETRANS.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SETRANS.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SETRANS.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SETUR'
            JOIN SW_SETUR.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SETUR.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SETUR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SETUR.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SETUR.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SETUR.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SETUR.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SETUR.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SETUR.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SETUR.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SSPPI'
            JOIN SW_SSPPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SSPPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SSPPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SSPPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SSPPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SSPPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SSPPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SSPPI.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SSPPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SSPPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SURPI'
            JOIN SW_SURPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SURPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SURPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SURPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_SURPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_SURPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_SURPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_SURPI.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_SURPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SURPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'TVANTARES'
            JOIN SW_TVANTARES.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_TVANTARES.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_TVANTARES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_TVANTARES.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_TVANTARES.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_TVANTARES.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_TVANTARES.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_TVANTARES.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_TVANTARES.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_TVANTARES.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
            NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
            GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'VICEGOV'
            JOIN SW_VICEGOV.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_VICEGOV.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_VICEGOV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_VICEGOV.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            LEFT JOIN SW_VICEGOV.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
            LEFT JOIN SW_VICEGOV.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
            LEFT JOIN SW_VICEGOV.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                    SELECT
                            X.ID_LOTA_GRUPO_RELATORIO
                    FROM
                            SW_VICEGOV.RHB_LOTA_GRUPO_RELATORIO X
                    WHERE
                            X.CODIGO = E.ORGAO_SIAFI
            ))
            JOIN SW_VICEGOV.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_VICEGOV.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714250)
                    OR FR.COD_RUBRICA_LEGADO IN ('900')
                    OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                    OR FR.COD_RUBRICA IN (999997) )
		) X
)
SELECT
	BRUTO.ORGAO                                                                 AS "CODIGO EMPRESA",
        CASE
        WHEN
        BASE.IND_CONTRIBUICAO = 'S'
        OR FUNDO.IND_CONTRIBUICAO = 'S'
        OR PATRONAL.IND_CONTRIBUICAO = 'S'
        THEN 'S'
        ELSE 'N'
        END                                                                         AS IND_CONTRIBUICAO,
	COUNT(DISTINCT BRUTO.MATRICULA)                                             AS "CONTRACHEQUES",
	COUNT(DISTINCT BRUTO.CPF)                                                   AS "CPFs",
	BRUTO.COD_GRUPO                                                             AS "CODIGO GRUPO",
	BRUTO.DESCRICAO_GRUPO                                                       AS "GRUPO",
	CASE BRUTO.TIPO_RELATORIO
		WHEN 'E' THEN 'EXECUTIVO'
		ELSE 'OUTROS PODERES'
	END                                                                         AS "TIPO DE RELATORIO",
	NVL(SUM(BASE.VALOR_CALCULADO), 0)                                           AS "VALOR BASE",
	NVL(SUM(FUNDO.VALOR_CALCULADO), 0)                                          AS "VALOR FUNDO",
	NVL(SUM(PATRONAL.VALOR_CALCULADO), 0)                                       AS "VALOR 28%",
	NVL(SUM(FUNDO.VALOR_CALCULADO), 0) + NVL(SUM(PATRONAL.VALOR_CALCULADO), 0)  AS "REPASSE",
	NVL(SUM(BRUTO.VALOR_CALCULADO), 0)                                          AS "VALOR BRUTO"
FROM
	(
		SELECT
			BRUTO.ORGAO,
			BRUTO.ID_FUNCIONARIO,
			BRUTO.MATRICULA,
			BRUTO.CPF,
			BRUTO.COD_GRUPO,
			BRUTO.DESCRICAO_GRUPO,
			BRUTO.TIPO_RELATORIO,
			SUM(BRUTO.VALOR_CALCULADO) AS VALOR_CALCULADO
		FROM
			TABELA_AUX BRUTO
		WHERE
			BRUTO.TIPO_RUBRICA = 'BRUTO'
		GROUP BY
			BRUTO.ORGAO,
			BRUTO.ID_FUNCIONARIO,
			BRUTO.MATRICULA,
			BRUTO.CPF,
			BRUTO.COD_GRUPO,
			BRUTO.DESCRICAO_GRUPO,
			BRUTO.TIPO_RELATORIO
	) BRUTO
	LEFT JOIN (
		SELECT
			FUNDO.ORGAO,
			FUNDO.ID_FUNCIONARIO,
			FUNDO.MATRICULA,
			FUNDO.CPF,
			FUNDO.COD_GRUPO,
			FUNDO.DESCRICAO_GRUPO,
			FUNDO.TIPO_RELATORIO,
			SUM(FUNDO.VALOR_CALCULADO) AS VALOR_CALCULADO,
                        CASE
                                WHEN SUM(FUNDO.VALOR_CALCULADO) = 0 THEN 'N'
                                ELSE 'S'
                        END AS IND_CONTRIBUICAO
		FROM
			TABELA_AUX FUNDO
		WHERE
			FUNDO.TIPO_RUBRICA = 'FUNDO'
		GROUP BY
			FUNDO.ORGAO,
			FUNDO.ID_FUNCIONARIO,
			FUNDO.MATRICULA,
			FUNDO.CPF,
			FUNDO.COD_GRUPO,
			FUNDO.DESCRICAO_GRUPO,
			FUNDO.TIPO_RELATORIO
	) FUNDO ON FUNDO.ORGAO = BRUTO.ORGAO
            AND FUNDO.MATRICULA = BRUTO.MATRICULA
            AND FUNDO.CPF = BRUTO.CPF
            AND FUNDO.ID_FUNCIONARIO = BRUTO.ID_FUNCIONARIO
            AND FUNDO.COD_GRUPO = BRUTO.COD_GRUPO
	LEFT JOIN (
		SELECT
			PATRONAL.ORGAO,
			PATRONAL.ID_FUNCIONARIO,
			PATRONAL.MATRICULA,
			PATRONAL.CPF,
			PATRONAL.COD_GRUPO,
			PATRONAL.DESCRICAO_GRUPO,
			PATRONAL.TIPO_RELATORIO,
			SUM(PATRONAL.VALOR_CALCULADO) AS VALOR_CALCULADO,
                        CASE
                                WHEN SUM(PATRONAL.VALOR_CALCULADO) = 0 THEN 'N'
                                ELSE 'S'
                        END AS IND_CONTRIBUICAO
		FROM
			TABELA_AUX PATRONAL
		WHERE
			PATRONAL.TIPO_RUBRICA = 'PATRONAL'
		GROUP BY
			PATRONAL.ORGAO,
			PATRONAL.ID_FUNCIONARIO,
			PATRONAL.MATRICULA,
			PATRONAL.CPF,
			PATRONAL.COD_GRUPO,
			PATRONAL.DESCRICAO_GRUPO,
			PATRONAL.TIPO_RELATORIO
	) PATRONAL ON PATRONAL.ORGAO = BRUTO.ORGAO
            AND PATRONAL.MATRICULA = BRUTO.MATRICULA
            AND PATRONAL.CPF = BRUTO.CPF
            AND PATRONAL.ID_FUNCIONARIO = BRUTO.ID_FUNCIONARIO
            AND PATRONAL.COD_GRUPO = BRUTO.COD_GRUPO
	LEFT JOIN (
		SELECT
			BASE.ORGAO,
			BASE.ID_FUNCIONARIO,
			BASE.MATRICULA,
			BASE.CPF,
			BASE.COD_GRUPO,
			BASE.DESCRICAO_GRUPO,
			BASE.TIPO_RELATORIO,
			SUM(BASE.VALOR_CALCULADO) AS VALOR_CALCULADO,
                        CASE
                                WHEN SUM(BASE.VALOR_CALCULADO) = 0 THEN 'N'
                                ELSE 'S'
                        END AS IND_CONTRIBUICAO
		FROM
			TABELA_AUX BASE
		WHERE
            BASE.TIPO_RUBRICA = 'BASE'
		GROUP BY
			BASE.ORGAO,
			BASE.ID_FUNCIONARIO,
			BASE.MATRICULA,
			BASE.CPF,
			BASE.COD_GRUPO,
			BASE.DESCRICAO_GRUPO,
			BASE.TIPO_RELATORIO
	) BASE ON BASE.ORGAO = BRUTO.ORGAO
            AND BASE.MATRICULA = BRUTO.MATRICULA
            AND BASE.CPF = BRUTO.CPF
            AND BASE.ID_FUNCIONARIO = BRUTO.ID_FUNCIONARIO
            AND BASE.COD_GRUPO = BRUTO.COD_GRUPO
GROUP BY
	BRUTO.ORGAO,
	BRUTO.COD_GRUPO,
	BRUTO.DESCRICAO_GRUPO,
	BRUTO.TIPO_RELATORIO,
        BASE.IND_CONTRIBUICAO,
        FUNDO.IND_CONTRIBUICAO,
        PATRONAL.IND_CONTRIBUICAO
ORDER BY
	BRUTO.ORGAO,
	BRUTO.COD_GRUPO,
	BRUTO.DESCRICAO_GRUPO,
	BRUTO.TIPO_RELATORIO;


-- RELAT�RIO LOTAÇÕES MENSAL

WITH TABELA_AUX AS (
    SELECT
        X.ORGAO,
        X.ID_FUNCIONARIO,
        X.ID_FOLHA_FUNCIONARIO,
        X.MATRICULA,
        X.CPF,
        X.COD_LOTACAO,
        X.NOME_LOTACAO,
        CASE
            WHEN X.COD_RUBRICA IN (714100, 714110) THEN 'BASE'
            WHEN X.COD_RUBRICA_LEGADO IN ('901') THEN 'FUNDO'
            WHEN X.COD_RUBRICA IN (714400, 714405, 714410, 714420) THEN 'PATRONAL'
            WHEN X.COD_RUBRICA IN (999997) THEN 'BRUTO'
        END AS TIPO_RUBRICA,
        X.VALOR_CALCULADO
    FROM
        (
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ADAPI'
            JOIN SW_ADAPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_ADAPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_ADAPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_ADAPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_ADAPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_ADAPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ADH'
            JOIN SW_ADH.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_ADH.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_ADH.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_ADH.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_ADH.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_ADH.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'AGESPISA'
            JOIN SW_AGESPISA.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_AGESPISA.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_AGESPISA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_AGESPISA.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_AGESPISA.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_AGESPISA.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'AGRESP'
            JOIN SW_AGRESP.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_AGRESP.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_AGRESP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_AGRESP.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_AGRESP.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_AGRESP.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ATIPI'
            JOIN SW_ATIPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_ATIPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_ATIPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_ATIPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_ATIPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_ATIPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CBMPI'
            JOIN SW_CBMPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_CBMPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_CBMPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_CBMPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_CBMPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_CBMPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CCOM'
            JOIN SW_CCOM.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_CCOM.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_CCOM.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_CCOM.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_CCOM.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_CCOM.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CDTER'
            JOIN SW_CDTER.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_CDTER.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_CDTER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_CDTER.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_CDTER.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_CDTER.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CENDROGAS'
            JOIN SW_CENDROGAS.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_CENDROGAS.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_CENDROGAS.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_CENDROGAS.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_CENDROGAS.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_CENDROGAS.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'COFIR'
            JOIN SW_COFIR.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_COFIR.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_COFIR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_COFIR.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_COFIR.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_COFIR.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'COJUV'
            JOIN SW_COJUV.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_COJUV.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_COJUV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_COJUV.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_COJUV.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_COJUV.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CPVCI'
            JOIN SW_CPVCI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_CPVCI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_CPVCI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_CPVCI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_CPVCI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_CPVCI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DEFCIVIL'
            JOIN SW_DEFCIVIL.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_DEFCIVIL.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_DEFCIVIL.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_DEFCIVIL.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_DEFCIVIL.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_DEFCIVIL.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DER'
            JOIN SW_DER.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_DER.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_DER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_DER.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_DER.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_DER.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DETRAN'
            JOIN SW_DETRAN.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_DETRAN.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_DETRAN.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_DETRAN.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_DETRAN.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_DETRAN.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMATERPROD'
            JOIN SW_EMATERPROD.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_EMATERPROD.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_EMATERPROD.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_EMATERPROD.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_EMATERPROD.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_EMATERPROD.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FAPEPI'
            JOIN SW_FAPEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_FAPEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_FAPEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_FAPEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_FAPEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_FAPEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FUESPI'
            JOIN SW_FUESPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_FUESPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_FUESPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_FUESPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_FUESPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_FUESPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FUPIP'
            JOIN SW_FUPIP.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_FUPIP.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_FUPIP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_FUPIP.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_FUPIP.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_FUPIP.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'GMG'
            JOIN SW_GMG.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_GMG.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_GMG.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_GMG.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_GMG.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_GMG.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IASPI'
            JOIN SW_IASPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_IASPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_IASPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_IASPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_IASPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_IASPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IDEPI'
            JOIN SW_IDEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_IDEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_IDEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_IDEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_IDEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_IDEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IMEPI'
            JOIN SW_IMEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_IMEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_IMEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_IMEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_IMEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_IMEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IMEPIPROD'
            JOIN SW_IMEPIPROD.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_IMEPIPROD.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_IMEPIPROD.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_IMEPIPROD.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_IMEPIPROD.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_IMEPIPROD.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'INTERPI'
            JOIN SW_INTERPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_INTERPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_INTERPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_INTERPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_INTERPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_INTERPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'JUCEPI'
            JOIN SW_JUCEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_JUCEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_JUCEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_JUCEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_JUCEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_JUCEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'METRO'
            JOIN SW_METRO.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_METRO.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_METRO.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_METRO.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_METRO.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_METRO.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'PGEPI'
            JOIN SW_PGEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_PGEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_PGEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_PGEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_PGEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_PGEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'PMPI'
            JOIN SW_PMPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_PMPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_PMPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_PMPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_PMPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_PMPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SADA'
            JOIN SW_SADA.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SADA.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SADA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SADA.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SADA.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SADA.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SAF'
            JOIN SW_SAF.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SAF.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SAF.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SAF.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SAF.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SAF.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SASC'
            JOIN SW_SASC.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SASC.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SASC.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SASC.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SASC.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SASC.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEADPREVPI'
            JOIN SW_SEADPREVPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEADPREVPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEADPREVPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEADPREVPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEADPREVPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEADPREVPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEAGRO'
            JOIN SW_SEAGRO.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEAGRO.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEAGRO.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEAGRO.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEAGRO.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEAGRO.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECESP'
            JOIN SW_SECESP.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SECESP.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SECESP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SECESP.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SECESP.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SECESP.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECID'
            JOIN SW_SECID.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SECID.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SECID.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SECID.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SECID.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SECID.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECMULHERES'
            JOIN SW_SECMULHERES.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SECMULHERES.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SECMULHERES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SECMULHERES.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SECMULHERES.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SECMULHERES.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECULT'
            JOIN SW_SECULT.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SECULT.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SECULT.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SECULT.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SECULT.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SECULT.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEDET'
            JOIN SW_SEDET.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEDET.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEDET.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEDET.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEDET.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEDET.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEDUC'
            JOIN SW_SEDUC.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEDUC.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEDUC.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEDUC.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEDUC.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEDUC.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEFAZPI'
            JOIN SW_SEFAZPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEFAZPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEFAZPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEFAZPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEFAZPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEFAZPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEGOV'
            JOIN SW_SEGOV.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEGOV.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEGOV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEGOV.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEGOV.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEGOV.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEID'
            JOIN SW_SEID.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEID.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEID.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEID.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEID.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEID.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEINFRA'
            JOIN SW_SEINFRA.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEINFRA.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEINFRA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEINFRA.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEINFRA.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEINFRA.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEJUSPI'
            JOIN SW_SEJUSPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEJUSPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEJUSPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEJUSPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEJUSPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEJUSPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEMAR'
            JOIN SW_SEMAR.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEMAR.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEMAR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEMAR.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEMAR.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEMAR.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEMINPER'
            JOIN SW_SEMINPER.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEMINPER.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEMINPER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEMINPER.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEMINPER.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEMINPER.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEPLAN'
            JOIN SW_SEPLAN.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SEPLAN.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SEPLAN.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEPLAN.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SEPLAN.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SEPLAN.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SERES'
            JOIN SW_SERES.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SERES.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SERES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SERES.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SERES.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SERES.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SESAPI'
            JOIN SW_SESAPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SESAPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SESAPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SESAPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SESAPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SESAPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SETRANS'
            JOIN SW_SETRANS.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SETRANS.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SETRANS.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SETRANS.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SETRANS.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SETRANS.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SETUR'
            JOIN SW_SETUR.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SETUR.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SETUR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SETUR.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SETUR.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SETUR.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SSPPI'
            JOIN SW_SSPPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SSPPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SSPPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SSPPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SSPPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SSPPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SURPI'
            JOIN SW_SURPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_SURPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_SURPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SURPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_SURPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_SURPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'TVANTARES'
            JOIN SW_TVANTARES.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_TVANTARES.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_TVANTARES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_TVANTARES.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_TVANTARES.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_TVANTARES.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
        UNION ALL
        SELECT
            FF.ID_FOLHA_FUNCIONARIO,
            F.ID_FUNCIONARIO,
            REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
            PDC.CPF_PESSOA                                              AS CPF,
            E.ORGAO_SIAFI                                               AS ORGAO,
            FR.COD_RUBRICA,
            FR.COD_RUBRICA_LEGADO,
            FFR.VALOR_CALCULADO,
            FO.MES,
            FO.ANO,
            FO.ID_TIPO_FOLHA,
            FF.COD_LOTACAO,
            FF.NOME_LOTACAO
        FROM
            SW_PUBLICO.PESSOA P
            JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
            JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'VICEGOV'
            JOIN SW_VICEGOV.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
            JOIN SW_VICEGOV.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
            JOIN SW_VICEGOV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_VICEGOV.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
            JOIN SW_VICEGOV.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
            JOIN SW_VICEGOV.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
            JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
        WHERE
            FO.ID_TIPO_FOLHA = 1000000
            AND FO.MES = 7
            AND FO.ANO = 2026
            AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
            AND FI.ID_REGIME IN (2, 1000003)
            AND ( FR.COD_RUBRICA IN (714100, 714110)
                    OR FR.COD_RUBRICA_LEGADO IN ('901')
                    OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                    OR FR.COD_RUBRICA IN (999997) )
    ) X
)
SELECT
    BRUTO.ORGAO                                                                 AS "CODIGO EMPRESA",
    CASE
        WHEN
        BASE.IND_CONTRIBUICAO = 'S'
        OR FUNDO.IND_CONTRIBUICAO = 'S'
        OR PATRONAL.IND_CONTRIBUICAO = 'S'
        THEN 'S'
        ELSE 'N'
        END                                                                         AS IND_CONTRIBUICAO,
    COUNT(DISTINCT BRUTO.MATRICULA)                                             AS "CONTRACHEQUES",
    COUNT(DISTINCT BRUTO.CPF)                                                   AS "CPFs",
    BRUTO.COD_LOTACAO                                                           AS "CODIGO LOTACAO",
    BRUTO.NOME_LOTACAO                                                          AS "LOTACAO",
    NVL(SUM(BASE.VALOR_CALCULADO), 0)                                           AS "VALOR BASE",
    NVL(SUM(FUNDO.VALOR_CALCULADO), 0)                                          AS "VALOR FUNDO",
    NVL(SUM(PATRONAL.VALOR_CALCULADO), 0)                                       AS "VALOR 28%",
    NVL(SUM(FUNDO.VALOR_CALCULADO), 0) + NVL(SUM(PATRONAL.VALOR_CALCULADO), 0)  AS "REPASSE",
    NVL(SUM(BRUTO.VALOR_CALCULADO), 0)                                          AS "VALOR BRUTO"
FROM
    (
        SELECT
            BRUTO.ORGAO,
            BRUTO.ID_FUNCIONARIO,
            BRUTO.MATRICULA,
            BRUTO.CPF,
            BRUTO.COD_LOTACAO,
            BRUTO.NOME_LOTACAO,
            SUM(BRUTO.VALOR_CALCULADO) AS VALOR_CALCULADO
        FROM
            TABELA_AUX BRUTO
        WHERE
            BRUTO.TIPO_RUBRICA = 'BRUTO'
        GROUP BY
            BRUTO.ORGAO,
            BRUTO.ID_FUNCIONARIO,
            BRUTO.MATRICULA,
            BRUTO.CPF,
            BRUTO.COD_LOTACAO,
            BRUTO.NOME_LOTACAO
    ) BRUTO
    LEFT JOIN (
        SELECT
            FUNDO.ORGAO,
            FUNDO.ID_FUNCIONARIO,
            FUNDO.MATRICULA,
            FUNDO.CPF,
            FUNDO.COD_LOTACAO,
            FUNDO.NOME_LOTACAO,
            SUM(FUNDO.VALOR_CALCULADO) AS VALOR_CALCULADO,
            CASE
                                WHEN SUM(FUNDO.VALOR_CALCULADO) = 0 THEN 'N'
                                ELSE 'S'
                        END AS IND_CONTRIBUICAO
        FROM
            TABELA_AUX FUNDO
        WHERE
            FUNDO.TIPO_RUBRICA = 'FUNDO'
        GROUP BY
            FUNDO.ORGAO,
            FUNDO.ID_FUNCIONARIO,
            FUNDO.MATRICULA,
            FUNDO.CPF,
            FUNDO.COD_LOTACAO,
            FUNDO.NOME_LOTACAO
    ) FUNDO ON FUNDO.ORGAO = BRUTO.ORGAO
            AND FUNDO.MATRICULA = BRUTO.MATRICULA
            AND FUNDO.CPF = BRUTO.CPF
            AND FUNDO.ID_FUNCIONARIO = BRUTO.ID_FUNCIONARIO
            AND FUNDO.COD_LOTACAO = BRUTO.COD_LOTACAO
            AND FUNDO.NOME_LOTACAO = BRUTO.NOME_LOTACAO
    LEFT JOIN (
        SELECT
            PATRONAL.ORGAO,
            PATRONAL.ID_FUNCIONARIO,
            PATRONAL.MATRICULA,
            PATRONAL.CPF,
            PATRONAL.COD_LOTACAO,
            PATRONAL.NOME_LOTACAO,
            SUM(PATRONAL.VALOR_CALCULADO) AS VALOR_CALCULADO,
            CASE
                                WHEN SUM(PATRONAL.VALOR_CALCULADO) = 0 THEN 'N'
                                ELSE 'S'
                        END AS IND_CONTRIBUICAO
        FROM
            TABELA_AUX PATRONAL
        WHERE
            PATRONAL.TIPO_RUBRICA = 'PATRONAL'
        GROUP BY
            PATRONAL.ORGAO,
            PATRONAL.ID_FUNCIONARIO,
            PATRONAL.MATRICULA,
            PATRONAL.CPF,
            PATRONAL.COD_LOTACAO,
            PATRONAL.NOME_LOTACAO
    ) PATRONAL ON PATRONAL.ORGAO = BRUTO.ORGAO
            AND PATRONAL.MATRICULA = BRUTO.MATRICULA
            AND PATRONAL.CPF = BRUTO.CPF
            AND PATRONAL.ID_FUNCIONARIO = BRUTO.ID_FUNCIONARIO
            AND PATRONAL.COD_LOTACAO = BRUTO.COD_LOTACAO
            AND PATRONAL.NOME_LOTACAO = BRUTO.NOME_LOTACAO
    LEFT JOIN (
        SELECT
            BASE.ORGAO,
            BASE.ID_FUNCIONARIO,
            BASE.MATRICULA,
            BASE.CPF,
            BASE.COD_LOTACAO,
            BASE.NOME_LOTACAO,
            SUM(BASE.VALOR_CALCULADO) AS VALOR_CALCULADO,
            CASE
                                WHEN SUM(BASE.VALOR_CALCULADO) = 0 THEN 'N'
                                ELSE 'S'
                        END AS IND_CONTRIBUICAO
        FROM
            TABELA_AUX BASE
        WHERE
            BASE.TIPO_RUBRICA = 'BASE'
        GROUP BY
            BASE.ORGAO,
            BASE.ID_FUNCIONARIO,
            BASE.MATRICULA,
            BASE.CPF,
            BASE.COD_LOTACAO,
            BASE.NOME_LOTACAO
    ) BASE ON BASE.ORGAO = BRUTO.ORGAO
            AND BASE.MATRICULA = BRUTO.MATRICULA
            AND BASE.CPF = BRUTO.CPF
            AND BASE.ID_FUNCIONARIO = BRUTO.ID_FUNCIONARIO
            AND BASE.COD_LOTACAO = BRUTO.COD_LOTACAO
            AND BASE.NOME_LOTACAO = BRUTO.NOME_LOTACAO
GROUP BY
    BRUTO.ORGAO,
    BRUTO.COD_LOTACAO,
    BRUTO.NOME_LOTACAO,
    BASE.IND_CONTRIBUICAO,
    FUNDO.IND_CONTRIBUICAO,
    PATRONAL.IND_CONTRIBUICAO
ORDER BY
    BRUTO.ORGAO,
    BRUTO.COD_LOTACAO,
    BRUTO.NOME_LOTACAO;


-- RELAT�RIO LOTAÇÕES NATAL

WITH TABELA_AUX AS (
		SELECT
            X.ORGAO,
            X.ID_FUNCIONARIO,
            X.ID_FOLHA_FUNCIONARIO,
            X.MATRICULA,
            X.CPF,
            X.COD_LOTACAO,
            X.NOME_LOTACAO,
            CASE
                WHEN X.COD_RUBRICA IN (714250) THEN 'BASE'
                WHEN X.COD_RUBRICA_LEGADO IN ('900') THEN 'FUNDO'
                WHEN X.COD_RUBRICA IN (714450, 714455, 714460) THEN 'PATRONAL'
                WHEN X.COD_RUBRICA IN (999997) THEN 'BRUTO'
            END AS TIPO_RUBRICA,
            X.VALOR_CALCULADO
    FROM
        (
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ADAPI'
                JOIN SW_ADAPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_ADAPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_ADAPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_ADAPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_ADAPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_ADAPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ADH'
                JOIN SW_ADH.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_ADH.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_ADH.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_ADH.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_ADH.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_ADH.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'AGESPISA'
                JOIN SW_AGESPISA.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_AGESPISA.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_AGESPISA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_AGESPISA.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_AGESPISA.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_AGESPISA.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'AGRESP'
                JOIN SW_AGRESP.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_AGRESP.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_AGRESP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_AGRESP.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_AGRESP.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_AGRESP.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ATIPI'
                JOIN SW_ATIPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_ATIPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_ATIPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_ATIPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_ATIPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_ATIPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CBMPI'
                JOIN SW_CBMPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_CBMPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_CBMPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CBMPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CBMPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_CBMPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CCOM'
                JOIN SW_CCOM.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_CCOM.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_CCOM.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CCOM.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CCOM.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_CCOM.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CDTER'
                JOIN SW_CDTER.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_CDTER.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_CDTER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CDTER.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CDTER.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_CDTER.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CENDROGAS'
                JOIN SW_CENDROGAS.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_CENDROGAS.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_CENDROGAS.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CENDROGAS.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CENDROGAS.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_CENDROGAS.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'COFIR'
                JOIN SW_COFIR.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_COFIR.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_COFIR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_COFIR.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_COFIR.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_COFIR.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'COJUV'
                JOIN SW_COJUV.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_COJUV.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_COJUV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_COJUV.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_COJUV.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_COJUV.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CPVCI'
                JOIN SW_CPVCI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_CPVCI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_CPVCI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CPVCI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CPVCI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_CPVCI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DEFCIVIL'
                JOIN SW_DEFCIVIL.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_DEFCIVIL.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_DEFCIVIL.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_DEFCIVIL.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_DEFCIVIL.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_DEFCIVIL.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DER'
                JOIN SW_DER.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_DER.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_DER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_DER.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_DER.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_DER.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DETRAN'
                JOIN SW_DETRAN.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_DETRAN.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_DETRAN.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_DETRAN.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_DETRAN.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_DETRAN.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMATERPROD'
                JOIN SW_EMATERPROD.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_EMATERPROD.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_EMATERPROD.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_EMATERPROD.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_EMATERPROD.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_EMATERPROD.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FAPEPI'
                JOIN SW_FAPEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_FAPEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_FAPEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_FAPEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_FAPEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_FAPEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FUESPI'
                JOIN SW_FUESPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_FUESPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_FUESPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_FUESPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_FUESPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_FUESPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FUPIP'
                JOIN SW_FUPIP.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_FUPIP.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_FUPIP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_FUPIP.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_FUPIP.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_FUPIP.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'GMG'
                JOIN SW_GMG.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_GMG.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_GMG.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_GMG.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_GMG.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_GMG.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IASPI'
                JOIN SW_IASPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_IASPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_IASPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_IASPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_IASPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_IASPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IDEPI'
                JOIN SW_IDEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_IDEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_IDEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_IDEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_IDEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_IDEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IMEPI'
                JOIN SW_IMEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_IMEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_IMEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_IMEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_IMEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_IMEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IMEPIPROD'
                JOIN SW_IMEPIPROD.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_IMEPIPROD.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_IMEPIPROD.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_IMEPIPROD.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_IMEPIPROD.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_IMEPIPROD.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'INTERPI'
                JOIN SW_INTERPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_INTERPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_INTERPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_INTERPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_INTERPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_INTERPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'JUCEPI'
                JOIN SW_JUCEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_JUCEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_JUCEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_JUCEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_JUCEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_JUCEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'METRO'
                JOIN SW_METRO.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_METRO.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_METRO.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_METRO.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_METRO.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_METRO.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'PGEPI'
                JOIN SW_PGEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_PGEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_PGEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_PGEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_PGEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_PGEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'PMPI'
                JOIN SW_PMPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_PMPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_PMPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_PMPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_PMPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_PMPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SADA'
                JOIN SW_SADA.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SADA.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SADA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SADA.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SADA.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SADA.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SAF'
                JOIN SW_SAF.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SAF.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SAF.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SAF.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SAF.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SAF.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SASC'
                JOIN SW_SASC.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SASC.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SASC.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SASC.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SASC.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SASC.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEADPREVPI'
                JOIN SW_SEADPREVPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEADPREVPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEADPREVPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEADPREVPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEADPREVPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEADPREVPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEAGRO'
                JOIN SW_SEAGRO.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEAGRO.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEAGRO.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEAGRO.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEAGRO.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEAGRO.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECESP'
                JOIN SW_SECESP.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SECESP.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SECESP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SECESP.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SECESP.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SECESP.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECID'
                JOIN SW_SECID.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SECID.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SECID.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SECID.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SECID.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SECID.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECMULHERES'
                JOIN SW_SECMULHERES.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SECMULHERES.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SECMULHERES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SECMULHERES.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SECMULHERES.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SECMULHERES.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECULT'
                JOIN SW_SECULT.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SECULT.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SECULT.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SECULT.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SECULT.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SECULT.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEDET'
                JOIN SW_SEDET.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEDET.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEDET.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEDET.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEDET.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEDET.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEDUC'
                JOIN SW_SEDUC.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEDUC.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEDUC.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEDUC.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEDUC.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEDUC.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEFAZPI'
                JOIN SW_SEFAZPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEFAZPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEFAZPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEFAZPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEFAZPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEFAZPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEGOV'
                JOIN SW_SEGOV.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEGOV.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEGOV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEGOV.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEGOV.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEGOV.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEID'
                JOIN SW_SEID.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEID.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEID.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEID.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEID.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEID.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEINFRA'
                JOIN SW_SEINFRA.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEINFRA.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEINFRA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEINFRA.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEINFRA.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEINFRA.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEJUSPI'
                JOIN SW_SEJUSPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEJUSPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEJUSPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEJUSPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEJUSPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEJUSPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEMAR'
                JOIN SW_SEMAR.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEMAR.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEMAR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEMAR.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEMAR.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEMAR.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEMINPER'
                JOIN SW_SEMINPER.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEMINPER.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEMINPER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEMINPER.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEMINPER.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEMINPER.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEPLAN'
                JOIN SW_SEPLAN.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEPLAN.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEPLAN.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEPLAN.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEPLAN.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEPLAN.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SERES'
                JOIN SW_SERES.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SERES.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SERES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SERES.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SERES.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SERES.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SESAPI'
                JOIN SW_SESAPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SESAPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SESAPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SESAPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SESAPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SESAPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SETRANS'
                JOIN SW_SETRANS.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SETRANS.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SETRANS.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SETRANS.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SETRANS.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SETRANS.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SETUR'
                JOIN SW_SETUR.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SETUR.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SETUR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SETUR.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SETUR.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SETUR.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SSPPI'
                JOIN SW_SSPPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SSPPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SSPPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SSPPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SSPPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SSPPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SURPI'
                JOIN SW_SURPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SURPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SURPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SURPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SURPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SURPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'TVANTARES'
                JOIN SW_TVANTARES.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_TVANTARES.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_TVANTARES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_TVANTARES.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_TVANTARES.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_TVANTARES.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                FF.COD_LOTACAO,
                FF.NOME_LOTACAO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'VICEGOV'
                JOIN SW_VICEGOV.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_VICEGOV.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_VICEGOV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_VICEGOV.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_VICEGOV.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_VICEGOV.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
        ) X
)
SELECT
    BRUTO.ORGAO                                                                 AS "CODIGO EMPRESA",
    CASE
        WHEN
        BASE.IND_CONTRIBUICAO = 'S'
        OR FUNDO.IND_CONTRIBUICAO = 'S'
        OR PATRONAL.IND_CONTRIBUICAO = 'S'
        THEN 'S'
        ELSE 'N'
        END                                                                         AS IND_CONTRIBUICAO,
    COUNT(DISTINCT BRUTO.MATRICULA)                                             AS "CONTRACHEQUES",
    COUNT(DISTINCT BRUTO.CPF)                                                   AS "CPFs",
    BRUTO.COD_LOTACAO                                                           AS "CODIGO LOTACAO",
    BRUTO.NOME_LOTACAO                                                          AS "LOTACAO",
    NVL(SUM(BASE.VALOR_CALCULADO), 0)                                           AS "VALOR BASE",
    NVL(SUM(FUNDO.VALOR_CALCULADO), 0)                                          AS "VALOR FUNDO",
    NVL(SUM(PATRONAL.VALOR_CALCULADO), 0)                                       AS "VALOR 28%",
    NVL(SUM(FUNDO.VALOR_CALCULADO), 0) + NVL(SUM(PATRONAL.VALOR_CALCULADO), 0)  AS "REPASSE",
    NVL(SUM(BRUTO.VALOR_CALCULADO), 0)                                          AS "VALOR BRUTO"
FROM
    (
        SELECT
            BRUTO.ORGAO,
            BRUTO.ID_FUNCIONARIO,
            BRUTO.MATRICULA,
            BRUTO.CPF,
            BRUTO.COD_LOTACAO,
            BRUTO.NOME_LOTACAO,
            SUM(BRUTO.VALOR_CALCULADO) AS VALOR_CALCULADO
        FROM
            TABELA_AUX BRUTO
        WHERE
            BRUTO.TIPO_RUBRICA = 'BRUTO'
        GROUP BY
            BRUTO.ORGAO,
            BRUTO.ID_FUNCIONARIO,
            BRUTO.MATRICULA,
            BRUTO.CPF,
            BRUTO.COD_LOTACAO,
            BRUTO.NOME_LOTACAO
    ) BRUTO
    LEFT JOIN (
        SELECT
            FUNDO.ORGAO,
            FUNDO.ID_FUNCIONARIO,
            FUNDO.MATRICULA,
            FUNDO.CPF,
            FUNDO.COD_LOTACAO,
            FUNDO.NOME_LOTACAO,
            SUM(FUNDO.VALOR_CALCULADO) AS VALOR_CALCULADO,
            CASE
                                WHEN SUM(FUNDO.VALOR_CALCULADO) = 0 THEN 'N'
                                ELSE 'S'
                        END AS IND_CONTRIBUICAO
        FROM
            TABELA_AUX FUNDO
        WHERE
            FUNDO.TIPO_RUBRICA = 'FUNDO'
        GROUP BY
            FUNDO.ORGAO,
            FUNDO.ID_FUNCIONARIO,
            FUNDO.MATRICULA,
            FUNDO.CPF,
            FUNDO.COD_LOTACAO,
            FUNDO.NOME_LOTACAO
    ) FUNDO ON FUNDO.ORGAO = BRUTO.ORGAO
            AND FUNDO.MATRICULA = BRUTO.MATRICULA
            AND FUNDO.CPF = BRUTO.CPF
            AND FUNDO.ID_FUNCIONARIO = BRUTO.ID_FUNCIONARIO
            AND FUNDO.COD_LOTACAO = BRUTO.COD_LOTACAO
            AND FUNDO.NOME_LOTACAO = BRUTO.NOME_LOTACAO
    LEFT JOIN (
        SELECT
            PATRONAL.ORGAO,
            PATRONAL.ID_FUNCIONARIO,
            PATRONAL.MATRICULA,
            PATRONAL.CPF,
            PATRONAL.COD_LOTACAO,
            PATRONAL.NOME_LOTACAO,
            SUM(PATRONAL.VALOR_CALCULADO) AS VALOR_CALCULADO,
            CASE
                                WHEN SUM(PATRONAL.VALOR_CALCULADO) = 0 THEN 'N'
                                ELSE 'S'
                        END AS IND_CONTRIBUICAO
        FROM
            TABELA_AUX PATRONAL
        WHERE
            PATRONAL.TIPO_RUBRICA = 'PATRONAL'
        GROUP BY
            PATRONAL.ORGAO,
            PATRONAL.ID_FUNCIONARIO,
            PATRONAL.MATRICULA,
            PATRONAL.CPF,
            PATRONAL.COD_LOTACAO,
            PATRONAL.NOME_LOTACAO
    ) PATRONAL ON PATRONAL.ORGAO = BRUTO.ORGAO
            AND PATRONAL.MATRICULA = BRUTO.MATRICULA
            AND PATRONAL.CPF = BRUTO.CPF
            AND PATRONAL.ID_FUNCIONARIO = BRUTO.ID_FUNCIONARIO
            AND PATRONAL.COD_LOTACAO = BRUTO.COD_LOTACAO
            AND PATRONAL.NOME_LOTACAO = BRUTO.NOME_LOTACAO
    LEFT JOIN (
        SELECT
            BASE.ORGAO,
            BASE.ID_FUNCIONARIO,
            BASE.MATRICULA,
            BASE.CPF,
            BASE.COD_LOTACAO,
            BASE.NOME_LOTACAO,
            SUM(BASE.VALOR_CALCULADO) AS VALOR_CALCULADO,
            CASE
                                WHEN SUM(BASE.VALOR_CALCULADO) = 0 THEN 'N'
                                ELSE 'S'
                        END AS IND_CONTRIBUICAO
        FROM
            TABELA_AUX BASE
        WHERE
            BASE.TIPO_RUBRICA = 'BASE'
        GROUP BY
            BASE.ORGAO,
            BASE.ID_FUNCIONARIO,
            BASE.MATRICULA,
            BASE.CPF,
            BASE.COD_LOTACAO,
            BASE.NOME_LOTACAO
    ) BASE ON BASE.ORGAO = BRUTO.ORGAO
            AND BASE.MATRICULA = BRUTO.MATRICULA
            AND BASE.CPF = BRUTO.CPF
            AND BASE.ID_FUNCIONARIO = BRUTO.ID_FUNCIONARIO
            AND BASE.COD_LOTACAO = BRUTO.COD_LOTACAO
            AND BASE.NOME_LOTACAO = BRUTO.NOME_LOTACAO
GROUP BY
    BRUTO.ORGAO,
    BRUTO.COD_LOTACAO,
    BRUTO.NOME_LOTACAO,
    BASE.IND_CONTRIBUICAO,
    FUNDO.IND_CONTRIBUICAO,
    PATRONAL.IND_CONTRIBUICAO
ORDER BY
    BRUTO.ORGAO,
    BRUTO.COD_LOTACAO,
    BRUTO.NOME_LOTACAO;


-- RELAT�RIO POR FAIXA MENSAL

WITH TABELA_AUX AS (
    SELECT
        X.ORGAO,
        X.ID_FUNCIONARIO,
        X.ID_FOLHA_FUNCIONARIO,
        X.MATRICULA,
        X.CPF,
        X.COD_GRUPO,
        X.DESCRICAO_GRUPO,
        X.TIPO_RELATORIO,
        CASE
			WHEN X.COD_RUBRICA IN (714100, 714110) THEN 'BASE'
			WHEN X.COD_RUBRICA_LEGADO IN ('901') THEN 'FUNDO'
			WHEN X.COD_RUBRICA IN (714400, 714405, 714410, 714420) THEN 'PATRONAL'
			WHEN X.COD_RUBRICA IN (999997) THEN 'BRUTO'
		END AS TIPO_RUBRICA,
        X.VALOR_CALCULADO
    FROM
        (
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ADAPI'
                JOIN SW_ADAPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_ADAPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_ADAPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_ADAPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_ADAPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_ADAPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_ADAPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_ADAPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_ADAPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_ADAPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ADH'
                JOIN SW_ADH.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_ADH.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_ADH.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_ADH.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_ADH.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_ADH.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_ADH.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_ADH.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_ADH.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_ADH.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'AGESPISA'
                JOIN SW_AGESPISA.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_AGESPISA.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_AGESPISA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_AGESPISA.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_AGESPISA.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_AGESPISA.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_AGESPISA.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_AGESPISA.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_AGESPISA.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_AGESPISA.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'AGRESP'
                JOIN SW_AGRESP.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_AGRESP.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_AGRESP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_AGRESP.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_AGRESP.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_AGRESP.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_AGRESP.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_AGRESP.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_AGRESP.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_AGRESP.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ATIPI'
                JOIN SW_ATIPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_ATIPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_ATIPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_ATIPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_ATIPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_ATIPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_ATIPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_ATIPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_ATIPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_ATIPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CBMPI'
                JOIN SW_CBMPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_CBMPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_CBMPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CBMPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_CBMPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_CBMPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_CBMPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_CBMPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_CBMPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_CBMPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CCOM'
                JOIN SW_CCOM.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_CCOM.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_CCOM.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CCOM.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_CCOM.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_CCOM.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_CCOM.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_CCOM.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_CCOM.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_CCOM.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CDTER'
                JOIN SW_CDTER.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_CDTER.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_CDTER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CDTER.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_CDTER.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_CDTER.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_CDTER.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_CDTER.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_CDTER.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_CDTER.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CENDROGAS'
                JOIN SW_CENDROGAS.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_CENDROGAS.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_CENDROGAS.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CENDROGAS.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_CENDROGAS.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_CENDROGAS.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_CENDROGAS.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_CENDROGAS.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_CENDROGAS.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_CENDROGAS.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'COFIR'
                JOIN SW_COFIR.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_COFIR.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_COFIR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_COFIR.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_COFIR.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_COFIR.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_COFIR.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_COFIR.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_COFIR.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_COFIR.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'COJUV'
                JOIN SW_COJUV.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_COJUV.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_COJUV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_COJUV.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_COJUV.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_COJUV.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_COJUV.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_COJUV.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_COJUV.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_COJUV.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CPVCI'
                JOIN SW_CPVCI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_CPVCI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_CPVCI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CPVCI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_CPVCI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_CPVCI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_CPVCI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_CPVCI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_CPVCI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_CPVCI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DEFCIVIL'
                JOIN SW_DEFCIVIL.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_DEFCIVIL.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_DEFCIVIL.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_DEFCIVIL.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_DEFCIVIL.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_DEFCIVIL.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_DEFCIVIL.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_DEFCIVIL.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_DEFCIVIL.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_DEFCIVIL.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DER'
                JOIN SW_DER.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_DER.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_DER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_DER.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_DER.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_DER.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_DER.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_DER.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_DER.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_DER.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DETRAN'
                JOIN SW_DETRAN.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_DETRAN.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_DETRAN.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_DETRAN.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_DETRAN.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_DETRAN.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_DETRAN.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_DETRAN.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_DETRAN.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_DETRAN.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMATERPROD'
                JOIN SW_EMATERPROD.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_EMATERPROD.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_EMATERPROD.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_EMATERPROD.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_EMATERPROD.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_EMATERPROD.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_EMATERPROD.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_EMATERPROD.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_EMATERPROD.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_EMATERPROD.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FAPEPI'
                JOIN SW_FAPEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_FAPEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_FAPEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_FAPEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_FAPEPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_FAPEPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_FAPEPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_FAPEPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_FAPEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_FAPEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FUESPI'
                JOIN SW_FUESPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_FUESPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_FUESPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_FUESPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_FUESPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_FUESPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_FUESPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_FUESPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_FUESPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_FUESPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FUPIP'
                JOIN SW_FUPIP.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_FUPIP.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_FUPIP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_FUPIP.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_FUPIP.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_FUPIP.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_FUPIP.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_FUPIP.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_FUPIP.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_FUPIP.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'GMG'
                JOIN SW_GMG.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_GMG.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_GMG.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_GMG.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_GMG.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_GMG.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_GMG.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_GMG.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_GMG.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_GMG.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IASPI'
                JOIN SW_IASPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_IASPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_IASPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_IASPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_IASPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_IASPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_IASPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_IASPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_IASPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_IASPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IDEPI'
                JOIN SW_IDEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_IDEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_IDEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_IDEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_IDEPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_IDEPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_IDEPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_IDEPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_IDEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_IDEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IMEPI'
                JOIN SW_IMEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_IMEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_IMEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_IMEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_IMEPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_IMEPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_IMEPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_IMEPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_IMEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_IMEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IMEPIPROD'
                JOIN SW_IMEPIPROD.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_IMEPIPROD.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_IMEPIPROD.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_IMEPIPROD.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_IMEPIPROD.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_IMEPIPROD.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_IMEPIPROD.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_IMEPIPROD.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_IMEPIPROD.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_IMEPIPROD.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'INTERPI'
                JOIN SW_INTERPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_INTERPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_INTERPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_INTERPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_INTERPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_INTERPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_INTERPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_INTERPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_INTERPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_INTERPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'JUCEPI'
                JOIN SW_JUCEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_JUCEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_JUCEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_JUCEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_JUCEPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_JUCEPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_JUCEPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_JUCEPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_JUCEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_JUCEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'METRO'
                JOIN SW_METRO.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_METRO.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_METRO.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_METRO.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_METRO.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_METRO.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_METRO.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_METRO.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_METRO.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_METRO.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'PGEPI'
                JOIN SW_PGEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_PGEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_PGEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_PGEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_PGEPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_PGEPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_PGEPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_PGEPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_PGEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_PGEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'PMPI'
                JOIN SW_PMPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_PMPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_PMPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_PMPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_PMPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_PMPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_PMPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_PMPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_PMPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_PMPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SADA'
                JOIN SW_SADA.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SADA.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SADA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SADA.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SADA.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SADA.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SADA.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SADA.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SADA.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SADA.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SAF'
                JOIN SW_SAF.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SAF.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SAF.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SAF.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SAF.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SAF.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SAF.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SAF.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SAF.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SAF.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SASC'
                JOIN SW_SASC.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SASC.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SASC.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SASC.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SASC.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SASC.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SASC.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SASC.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SASC.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SASC.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEADPREVPI'
                JOIN SW_SEADPREVPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEADPREVPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEADPREVPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEADPREVPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEADPREVPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEADPREVPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEADPREVPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEADPREVPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEADPREVPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEADPREVPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEAGRO'
                JOIN SW_SEAGRO.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEAGRO.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEAGRO.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEAGRO.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEAGRO.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEAGRO.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEAGRO.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEAGRO.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEAGRO.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEAGRO.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECESP'
                JOIN SW_SECESP.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SECESP.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SECESP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SECESP.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SECESP.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SECESP.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SECESP.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SECESP.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SECESP.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SECESP.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECID'
                JOIN SW_SECID.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SECID.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SECID.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SECID.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SECID.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SECID.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SECID.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SECID.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SECID.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SECID.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECMULHERES'
                JOIN SW_SECMULHERES.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SECMULHERES.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SECMULHERES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SECMULHERES.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SECMULHERES.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SECMULHERES.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SECMULHERES.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SECMULHERES.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SECMULHERES.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SECMULHERES.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECULT'
                JOIN SW_SECULT.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SECULT.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SECULT.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SECULT.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SECULT.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SECULT.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SECULT.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SECULT.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SECULT.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SECULT.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEDET'
                JOIN SW_SEDET.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEDET.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEDET.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEDET.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEDET.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEDET.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEDET.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEDET.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEDET.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEDET.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEDUC'
                JOIN SW_SEDUC.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEDUC.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEDUC.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEDUC.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEDUC.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEDUC.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEDUC.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEDUC.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEDUC.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEDUC.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEFAZPI'
                JOIN SW_SEFAZPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEFAZPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEFAZPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEFAZPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEFAZPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEFAZPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEFAZPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEFAZPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEFAZPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEFAZPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEGOV'
                JOIN SW_SEGOV.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEGOV.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEGOV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEGOV.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEGOV.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEGOV.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEGOV.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEGOV.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEGOV.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEGOV.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEID'
                JOIN SW_SEID.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEID.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEID.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEID.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEID.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEID.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEID.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEID.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEID.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEID.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEINFRA'
                JOIN SW_SEINFRA.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEINFRA.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEINFRA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEINFRA.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEINFRA.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEINFRA.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEINFRA.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEINFRA.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEINFRA.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEINFRA.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEJUSPI'
                JOIN SW_SEJUSPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEJUSPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEJUSPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEJUSPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEJUSPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEJUSPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEJUSPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEJUSPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEJUSPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEJUSPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEMAR'
                JOIN SW_SEMAR.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEMAR.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEMAR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEMAR.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEMAR.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEMAR.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEMAR.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEMAR.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEMAR.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEMAR.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEMINPER'
                JOIN SW_SEMINPER.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEMINPER.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEMINPER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEMINPER.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEMINPER.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEMINPER.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEMINPER.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEMINPER.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEMINPER.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEMINPER.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEPLAN'
                JOIN SW_SEPLAN.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEPLAN.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEPLAN.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEPLAN.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEPLAN.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEPLAN.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEPLAN.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEPLAN.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEPLAN.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEPLAN.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SERES'
                JOIN SW_SERES.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SERES.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SERES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SERES.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SERES.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SERES.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SERES.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SERES.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SERES.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SERES.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SESAPI'
                JOIN SW_SESAPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SESAPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SESAPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SESAPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SESAPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SESAPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SESAPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SESAPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SESAPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SESAPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SETRANS'
                JOIN SW_SETRANS.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SETRANS.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SETRANS.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SETRANS.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SETRANS.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SETRANS.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SETRANS.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SETRANS.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SETRANS.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SETRANS.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SETUR'
                JOIN SW_SETUR.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SETUR.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SETUR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SETUR.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SETUR.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SETUR.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SETUR.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SETUR.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SETUR.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SETUR.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SSPPI'
                JOIN SW_SSPPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SSPPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SSPPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SSPPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SSPPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SSPPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SSPPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SSPPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SSPPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SSPPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SURPI'
                JOIN SW_SURPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SURPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SURPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SURPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SURPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SURPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SURPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SURPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SURPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SURPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'TVANTARES'
                JOIN SW_TVANTARES.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_TVANTARES.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_TVANTARES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_TVANTARES.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_TVANTARES.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_TVANTARES.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_TVANTARES.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_TVANTARES.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_TVANTARES.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_TVANTARES.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'VICEGOV'
                JOIN SW_VICEGOV.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_VICEGOV.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_VICEGOV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_VICEGOV.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_VICEGOV.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_VICEGOV.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_VICEGOV.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_VICEGOV.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_VICEGOV.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_VICEGOV.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714100, 714110)
                        OR FR.COD_RUBRICA_LEGADO IN ('901')
                        OR FR.COD_RUBRICA IN (714400, 714405, 714410, 714420)
                        OR FR.COD_RUBRICA IN (999997) )
        ) X
)
SELECT
    BRUTO.ORGAO                                                                 AS "CODIGO EMPRESA",
    CASE
        WHEN
        BASE.IND_CONTRIBUICAO = 'S'
        OR FUNDO.IND_CONTRIBUICAO = 'S'
        OR PATRONAL.IND_CONTRIBUICAO = 'S'
        THEN 'S'
        ELSE 'N'
        END                                                                         AS IND_CONTRIBUICAO,
    COUNT(DISTINCT BRUTO.MATRICULA)                                             AS "CONTRACHEQUES",
    COUNT(DISTINCT BRUTO.CPF)                                                   AS "CPFs",
    BRUTO.COD_GRUPO                                                             AS "CODIGO GRUPO",
    BRUTO.DESCRICAO_GRUPO                                                       AS "GRUPO",
    CASE BRUTO.TIPO_RELATORIO
        WHEN 'E' THEN 'EXECUTIVO'
        ELSE 'OUTROS PODERES'
    END                                                                         AS "TIPO DE RELATORIO",
    NVL(BASE.FAIXA, 1)                                                          AS "FAIXA",
    NVL(SUM(BASE.VALOR_CALCULADO), 0)                                           AS "VALOR BASE",
    NVL(SUM(FUNDO.VALOR_CALCULADO), 0)                                          AS "VALOR FUNDO",
    NVL(SUM(PATRONAL.VALOR_CALCULADO), 0)                                       AS "VALOR 28%",
    NVL(SUM(FUNDO.VALOR_CALCULADO), 0) + NVL(SUM(PATRONAL.VALOR_CALCULADO), 0)  AS "REPASSE",
    NVL(SUM(BRUTO.VALOR_CALCULADO), 0)                                          AS "VALOR BRUTO"
FROM
    (
        SELECT
            BRUTO.ORGAO,
            BRUTO.ID_FUNCIONARIO,
            BRUTO.MATRICULA,
            BRUTO.CPF,
            BRUTO.COD_GRUPO,
            BRUTO.DESCRICAO_GRUPO,
            BRUTO.TIPO_RELATORIO,
            SUM(BRUTO.VALOR_CALCULADO) AS VALOR_CALCULADO
        FROM
            TABELA_AUX BRUTO
        WHERE
            BRUTO.TIPO_RUBRICA = 'BRUTO'
        GROUP BY
            BRUTO.ORGAO,
            BRUTO.ID_FUNCIONARIO,
            BRUTO.MATRICULA,
            BRUTO.CPF,
            BRUTO.COD_GRUPO,
            BRUTO.DESCRICAO_GRUPO,
            BRUTO.TIPO_RELATORIO
    ) BRUTO
    LEFT JOIN (
        SELECT
            FUNDO.ORGAO,
            FUNDO.ID_FUNCIONARIO,
            FUNDO.MATRICULA,
            FUNDO.CPF,
            FUNDO.COD_GRUPO,
            FUNDO.DESCRICAO_GRUPO,
            FUNDO.TIPO_RELATORIO,
            SUM(FUNDO.VALOR_CALCULADO) AS VALOR_CALCULADO,
            CASE
                                WHEN SUM(FUNDO.VALOR_CALCULADO) = 0 THEN 'N'
                                ELSE 'S'
                        END AS IND_CONTRIBUICAO
        FROM
            TABELA_AUX FUNDO
        WHERE
            FUNDO.TIPO_RUBRICA = 'FUNDO'
        GROUP BY
            FUNDO.ORGAO,
            FUNDO.ID_FUNCIONARIO,
            FUNDO.MATRICULA,
            FUNDO.CPF,
            FUNDO.COD_GRUPO,
            FUNDO.DESCRICAO_GRUPO,
            FUNDO.TIPO_RELATORIO
    ) FUNDO ON FUNDO.ORGAO = BRUTO.ORGAO
            AND FUNDO.MATRICULA = BRUTO.MATRICULA
            AND FUNDO.CPF = BRUTO.CPF
            AND FUNDO.ID_FUNCIONARIO = BRUTO.ID_FUNCIONARIO
            AND FUNDO.COD_GRUPO = BRUTO.COD_GRUPO
    LEFT JOIN (
        SELECT
            PATRONAL.ORGAO,
            PATRONAL.ID_FUNCIONARIO,
            PATRONAL.MATRICULA,
            PATRONAL.CPF,
            PATRONAL.COD_GRUPO,
            PATRONAL.DESCRICAO_GRUPO,
            PATRONAL.TIPO_RELATORIO,
            SUM(PATRONAL.VALOR_CALCULADO) AS VALOR_CALCULADO,
            CASE
                                WHEN SUM(PATRONAL.VALOR_CALCULADO) = 0 THEN 'N'
                                ELSE 'S'
                        END AS IND_CONTRIBUICAO
        FROM
            TABELA_AUX PATRONAL
        WHERE
            PATRONAL.TIPO_RUBRICA = 'PATRONAL'
        GROUP BY
            PATRONAL.ORGAO,
            PATRONAL.ID_FUNCIONARIO,
            PATRONAL.MATRICULA,
            PATRONAL.CPF,
            PATRONAL.COD_GRUPO,
            PATRONAL.DESCRICAO_GRUPO,
            PATRONAL.TIPO_RELATORIO
    ) PATRONAL ON PATRONAL.ORGAO = BRUTO.ORGAO
            AND PATRONAL.MATRICULA = BRUTO.MATRICULA
            AND PATRONAL.CPF = BRUTO.CPF
            AND PATRONAL.ID_FUNCIONARIO = BRUTO.ID_FUNCIONARIO
            AND PATRONAL.COD_GRUPO = BRUTO.COD_GRUPO
    LEFT JOIN (
        SELECT
            BASE.ORGAO,
            BASE.ID_FUNCIONARIO,
            BASE.MATRICULA,
            BASE.CPF,
            BASE.COD_GRUPO,
            BASE.DESCRICAO_GRUPO,
            BASE.TIPO_RELATORIO,
            SUM(BASE.VALOR_CALCULADO) AS VALOR_CALCULADO,
            CASE
                                WHEN SUM(BASE.VALOR_CALCULADO) = 0 THEN 'N'
                                ELSE 'S'
                        END AS IND_CONTRIBUICAO,
            CASE
                WHEN SUM(BASE.VALOR_CALCULADO) BETWEEN 0 AND 1518               THEN 1
                WHEN SUM(BASE.VALOR_CALCULADO) BETWEEN 1518.01 AND 1800         THEN 2
                WHEN SUM(BASE.VALOR_CALCULADO) BETWEEN 1800.01 AND 3000         THEN 3
                WHEN SUM(BASE.VALOR_CALCULADO) BETWEEN 3000.01 AND 999999999.99 THEN 4
                ELSE - 1
            END AS FAIXA
        FROM
            TABELA_AUX BASE
        WHERE
            BASE.TIPO_RUBRICA = 'BASE'
        GROUP BY
            BASE.ORGAO,
            BASE.ID_FUNCIONARIO,
            BASE.MATRICULA,
            BASE.CPF,
            BASE.COD_GRUPO,
            BASE.DESCRICAO_GRUPO,
            BASE.TIPO_RELATORIO
    ) BASE ON BASE.ORGAO = BRUTO.ORGAO
            AND BASE.MATRICULA = BRUTO.MATRICULA
            AND BASE.CPF = BRUTO.CPF
            AND BASE.ID_FUNCIONARIO = BRUTO.ID_FUNCIONARIO
            AND BASE.COD_GRUPO = BRUTO.COD_GRUPO
GROUP BY
    BRUTO.ORGAO,
    BRUTO.COD_GRUPO,
    BRUTO.DESCRICAO_GRUPO,
    BRUTO.TIPO_RELATORIO,
    NVL(BASE.FAIXA, 1),
    BASE.IND_CONTRIBUICAO,
    FUNDO.IND_CONTRIBUICAO,
    PATRONAL.IND_CONTRIBUICAO
ORDER BY
    BRUTO.ORGAO,
    BRUTO.COD_GRUPO,
    BRUTO.DESCRICAO_GRUPO,
    BRUTO.TIPO_RELATORIO,
    NVL(BASE.FAIXA, 1);


-- RELAT�RIO POR FAIXA NATAL

WITH TABELA_AUX AS (
    SELECT
        X.ORGAO,
        X.ID_FUNCIONARIO,
        X.ID_FOLHA_FUNCIONARIO,
        X.MATRICULA,
        X.CPF,
        X.COD_GRUPO,
        X.DESCRICAO_GRUPO,
        X.TIPO_RELATORIO,
        CASE  
            WHEN X.COD_RUBRICA IN (714250) THEN 'BASE'
            WHEN X.COD_RUBRICA_LEGADO IN ('900') THEN 'FUNDO' 
            WHEN X.COD_RUBRICA IN (714450, 714455, 714460) THEN 'PATRONAL' 
            WHEN X.COD_RUBRICA IN (999997) THEN 'BRUTO' 
        END AS TIPO_RUBRICA,
        X.VALOR_CALCULADO
    FROM
        (
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ADAPI'
                JOIN SW_ADAPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_ADAPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_ADAPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_ADAPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_ADAPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_ADAPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_ADAPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_ADAPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_ADAPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_ADAPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ADH'
                JOIN SW_ADH.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_ADH.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_ADH.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_ADH.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_ADH.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_ADH.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_ADH.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_ADH.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_ADH.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_ADH.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'AGESPISA'
                JOIN SW_AGESPISA.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_AGESPISA.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_AGESPISA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_AGESPISA.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_AGESPISA.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_AGESPISA.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_AGESPISA.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_AGESPISA.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_AGESPISA.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_AGESPISA.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'AGRESP'
                JOIN SW_AGRESP.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_AGRESP.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_AGRESP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_AGRESP.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_AGRESP.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_AGRESP.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_AGRESP.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_AGRESP.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_AGRESP.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_AGRESP.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ATIPI'
                JOIN SW_ATIPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_ATIPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_ATIPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_ATIPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_ATIPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_ATIPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_ATIPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_ATIPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_ATIPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_ATIPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CBMPI'
                JOIN SW_CBMPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_CBMPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_CBMPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CBMPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_CBMPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_CBMPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_CBMPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_CBMPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_CBMPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_CBMPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CCOM'
                JOIN SW_CCOM.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_CCOM.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_CCOM.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CCOM.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_CCOM.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_CCOM.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_CCOM.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_CCOM.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_CCOM.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_CCOM.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CDTER'
                JOIN SW_CDTER.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_CDTER.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_CDTER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CDTER.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_CDTER.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_CDTER.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_CDTER.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_CDTER.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_CDTER.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_CDTER.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CENDROGAS'
                JOIN SW_CENDROGAS.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_CENDROGAS.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_CENDROGAS.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CENDROGAS.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_CENDROGAS.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_CENDROGAS.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_CENDROGAS.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_CENDROGAS.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_CENDROGAS.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_CENDROGAS.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'COFIR'
                JOIN SW_COFIR.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_COFIR.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_COFIR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_COFIR.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_COFIR.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_COFIR.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_COFIR.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_COFIR.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_COFIR.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_COFIR.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'COJUV'
                JOIN SW_COJUV.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_COJUV.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_COJUV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_COJUV.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_COJUV.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_COJUV.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_COJUV.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_COJUV.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_COJUV.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_COJUV.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CPVCI'
                JOIN SW_CPVCI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_CPVCI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_CPVCI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_CPVCI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_CPVCI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_CPVCI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_CPVCI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_CPVCI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_CPVCI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_CPVCI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DEFCIVIL'
                JOIN SW_DEFCIVIL.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_DEFCIVIL.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_DEFCIVIL.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_DEFCIVIL.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_DEFCIVIL.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_DEFCIVIL.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_DEFCIVIL.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_DEFCIVIL.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_DEFCIVIL.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_DEFCIVIL.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DER'
                JOIN SW_DER.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_DER.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_DER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_DER.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_DER.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_DER.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_DER.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_DER.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_DER.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_DER.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DETRAN'
                JOIN SW_DETRAN.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_DETRAN.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_DETRAN.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_DETRAN.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_DETRAN.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_DETRAN.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_DETRAN.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_DETRAN.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_DETRAN.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_DETRAN.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMATERPROD'
                JOIN SW_EMATERPROD.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_EMATERPROD.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_EMATERPROD.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_EMATERPROD.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_EMATERPROD.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_EMATERPROD.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_EMATERPROD.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_EMATERPROD.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_EMATERPROD.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_EMATERPROD.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FAPEPI'
                JOIN SW_FAPEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_FAPEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_FAPEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_FAPEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_FAPEPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_FAPEPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_FAPEPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_FAPEPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_FAPEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_FAPEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FUESPI'
                JOIN SW_FUESPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_FUESPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_FUESPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_FUESPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_FUESPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_FUESPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_FUESPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_FUESPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_FUESPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_FUESPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FUPIP'
                JOIN SW_FUPIP.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_FUPIP.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_FUPIP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_FUPIP.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_FUPIP.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_FUPIP.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_FUPIP.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_FUPIP.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_FUPIP.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_FUPIP.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'GMG'
                JOIN SW_GMG.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_GMG.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_GMG.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_GMG.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_GMG.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_GMG.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_GMG.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_GMG.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_GMG.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_GMG.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IASPI'
                JOIN SW_IASPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_IASPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_IASPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_IASPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_IASPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_IASPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_IASPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_IASPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_IASPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_IASPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IDEPI'
                JOIN SW_IDEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_IDEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_IDEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_IDEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_IDEPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_IDEPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_IDEPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_IDEPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_IDEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_IDEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IMEPI'
                JOIN SW_IMEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_IMEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_IMEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_IMEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_IMEPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_IMEPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_IMEPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_IMEPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_IMEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_IMEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IMEPIPROD'
                JOIN SW_IMEPIPROD.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_IMEPIPROD.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_IMEPIPROD.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_IMEPIPROD.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_IMEPIPROD.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_IMEPIPROD.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_IMEPIPROD.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_IMEPIPROD.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_IMEPIPROD.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_IMEPIPROD.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'INTERPI'
                JOIN SW_INTERPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_INTERPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_INTERPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_INTERPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_INTERPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_INTERPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_INTERPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_INTERPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_INTERPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_INTERPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'JUCEPI'
                JOIN SW_JUCEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_JUCEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_JUCEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_JUCEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_JUCEPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_JUCEPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_JUCEPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_JUCEPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_JUCEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_JUCEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'METRO'
                JOIN SW_METRO.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_METRO.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_METRO.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_METRO.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_METRO.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_METRO.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_METRO.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_METRO.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_METRO.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_METRO.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'PGEPI'
                JOIN SW_PGEPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_PGEPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_PGEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_PGEPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_PGEPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_PGEPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_PGEPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_PGEPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_PGEPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_PGEPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'PMPI'
                JOIN SW_PMPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_PMPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_PMPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_PMPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_PMPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_PMPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_PMPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_PMPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_PMPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_PMPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SADA'
                JOIN SW_SADA.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SADA.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SADA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SADA.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SADA.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SADA.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SADA.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SADA.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SADA.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SADA.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SAF'
                JOIN SW_SAF.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SAF.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SAF.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SAF.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SAF.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SAF.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SAF.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SAF.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SAF.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SAF.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SASC'
                JOIN SW_SASC.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SASC.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SASC.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SASC.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SASC.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SASC.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SASC.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SASC.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SASC.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SASC.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEADPREVPI'
                JOIN SW_SEADPREVPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEADPREVPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEADPREVPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEADPREVPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEADPREVPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEADPREVPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEADPREVPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEADPREVPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEADPREVPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEADPREVPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEAGRO'
                JOIN SW_SEAGRO.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEAGRO.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEAGRO.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEAGRO.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEAGRO.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEAGRO.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEAGRO.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEAGRO.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEAGRO.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEAGRO.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECESP'
                JOIN SW_SECESP.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SECESP.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SECESP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SECESP.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SECESP.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SECESP.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SECESP.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SECESP.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SECESP.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SECESP.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECID'
                JOIN SW_SECID.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SECID.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SECID.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SECID.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SECID.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SECID.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SECID.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SECID.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SECID.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SECID.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECMULHERES'
                JOIN SW_SECMULHERES.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SECMULHERES.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SECMULHERES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SECMULHERES.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SECMULHERES.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SECMULHERES.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SECMULHERES.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SECMULHERES.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SECMULHERES.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SECMULHERES.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECULT'
                JOIN SW_SECULT.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SECULT.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SECULT.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SECULT.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SECULT.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SECULT.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SECULT.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SECULT.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SECULT.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SECULT.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEDET'
                JOIN SW_SEDET.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEDET.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEDET.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEDET.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEDET.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEDET.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEDET.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEDET.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEDET.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEDET.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEDUC'
                JOIN SW_SEDUC.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEDUC.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEDUC.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEDUC.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEDUC.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEDUC.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEDUC.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEDUC.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEDUC.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEDUC.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEFAZPI'
                JOIN SW_SEFAZPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEFAZPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEFAZPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEFAZPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEFAZPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEFAZPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEFAZPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEFAZPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEFAZPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEFAZPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEGOV'
                JOIN SW_SEGOV.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEGOV.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEGOV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEGOV.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEGOV.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEGOV.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEGOV.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEGOV.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEGOV.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEGOV.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEID'
                JOIN SW_SEID.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEID.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEID.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEID.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEID.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEID.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEID.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEID.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEID.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEID.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEINFRA'
                JOIN SW_SEINFRA.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEINFRA.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEINFRA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEINFRA.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEINFRA.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEINFRA.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEINFRA.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEINFRA.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEINFRA.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEINFRA.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEJUSPI'
                JOIN SW_SEJUSPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEJUSPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEJUSPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEJUSPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEJUSPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEJUSPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEJUSPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEJUSPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEJUSPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEJUSPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEMAR'
                JOIN SW_SEMAR.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEMAR.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEMAR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEMAR.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEMAR.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEMAR.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEMAR.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEMAR.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEMAR.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEMAR.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEMINPER'
                JOIN SW_SEMINPER.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEMINPER.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEMINPER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEMINPER.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEMINPER.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEMINPER.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEMINPER.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEMINPER.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEMINPER.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEMINPER.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEPLAN'
                JOIN SW_SEPLAN.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SEPLAN.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SEPLAN.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SEPLAN.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SEPLAN.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SEPLAN.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SEPLAN.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SEPLAN.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SEPLAN.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SEPLAN.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SERES'
                JOIN SW_SERES.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SERES.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SERES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SERES.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SERES.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SERES.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SERES.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SERES.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SERES.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SERES.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SESAPI'
                JOIN SW_SESAPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SESAPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SESAPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SESAPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SESAPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SESAPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SESAPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SESAPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SESAPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SESAPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SETRANS'
                JOIN SW_SETRANS.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SETRANS.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SETRANS.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SETRANS.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SETRANS.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SETRANS.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SETRANS.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SETRANS.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SETRANS.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SETRANS.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SETUR'
                JOIN SW_SETUR.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SETUR.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SETUR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SETUR.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SETUR.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SETUR.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SETUR.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SETUR.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SETUR.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SETUR.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SSPPI'
                JOIN SW_SSPPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SSPPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SSPPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SSPPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SSPPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SSPPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SSPPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SSPPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SSPPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SSPPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SURPI'
                JOIN SW_SURPI.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_SURPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_SURPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_SURPI.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_SURPI.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_SURPI.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_SURPI.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_SURPI.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_SURPI.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_SURPI.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'TVANTARES'
                JOIN SW_TVANTARES.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_TVANTARES.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_TVANTARES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_TVANTARES.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_TVANTARES.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_TVANTARES.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_TVANTARES.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_TVANTARES.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_TVANTARES.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_TVANTARES.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
            UNION ALL
            SELECT
                FF.ID_FOLHA_FUNCIONARIO,
                F.ID_FUNCIONARIO,
                REGEXP_REPLACE(PV.COD_INSTITUCIONAL, '[^0-9A-Za-z]', '')    AS MATRICULA,
                PDC.CPF_PESSOA                                              AS CPF,
                E.ORGAO_SIAFI                                               AS ORGAO,
                FR.COD_RUBRICA,
                FR.COD_RUBRICA_LEGADO,
                FFR.VALOR_CALCULADO,
                FO.MES,
                FO.ANO,
                FO.ID_TIPO_FOLHA,
                NVL(GRUP_REL.CODIGO, 'SEM GRUPO')                           AS COD_GRUPO,
                NVL(GRUP_REL.DESCRICAO, 'SEM GRUPO')                        AS DESCRICAO_GRUPO,
                GRUP_REL.TIPO_RELATORIO                                     AS TIPO_RELATORIO
            FROM
                SW_PUBLICO.PESSOA P
                JOIN SW_PUBLICO.PESSOA_DOC_CPF PDC ON PDC.ID_PESSOA = P.ID_PESSOA AND PDC.DATA_BAIXA IS NULL
                JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'VICEGOV'
                JOIN SW_VICEGOV.PESSOA_VINCULO PV ON PV.ID_PESSOA = P.ID_PESSOA
                JOIN SW_VICEGOV.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
                JOIN SW_VICEGOV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                JOIN SW_VICEGOV.FOLHA_FUNC FF ON FF.ID_FUNCIONARIO = F.ID_FUNCIONARIO
                LEFT JOIN SW_VICEGOV.RHB_LOTACAO LOT ON LOT.COD_LOTACAO = FF.COD_LOTACAO
                LEFT JOIN SW_VICEGOV.RHB_LOTACAO_GRUPO LOT_GRUP ON LOT_GRUP.ID_LOTACAO = LOT.ID_LOTACAO
                LEFT JOIN SW_VICEGOV.RHB_LOTA_GRUPO_RELATORIO GRUP_REL ON GRUP_REL.ID_LOTA_GRUPO_RELATORIO = COALESCE(LOT_GRUP.ID_LOTA_GRUPO_RELATORIO,(
                        SELECT
                                X.ID_LOTA_GRUPO_RELATORIO
                        FROM
                                SW_VICEGOV.RHB_LOTA_GRUPO_RELATORIO X
                        WHERE
                                X.CODIGO = E.ORGAO_SIAFI
                ))
                JOIN SW_VICEGOV.FOLHA FO ON FO.ID_FOLHA = FF.ID_FOLHA
                JOIN SW_VICEGOV.FOLHA_FUNC_RUBRICA FFR ON FFR.ID_FOLHA_FUNCIONARIO = FF.ID_FOLHA_FUNCIONARIO
                JOIN SW_PUBLICO.FOLHA_RUBRICA FR ON FR.ID_RUBRICA = FFR.ID_RUBRICA
            WHERE
                FO.ID_TIPO_FOLHA = 1000000
                AND FO.MES = 7
                AND FO.ANO = 2026
                AND REGEXP_LIKE(FO.CHAVE_FOLHA, '-100|-110|-120|-200')
                AND FI.ID_REGIME IN (2, 1000003)
                AND ( FR.COD_RUBRICA IN (714250)
                OR FR.COD_RUBRICA_LEGADO IN ('900')
                OR FR.COD_RUBRICA IN (714450, 714455, 714460)
                OR FR.COD_RUBRICA IN (999997) )
        ) X
)
SELECT
    BRUTO.ORGAO                                                                 AS "CODIGO EMPRESA",
    CASE
        WHEN
            BASE.IND_CONTRIBUICAO = 'S'
            OR FUNDO.IND_CONTRIBUICAO = 'S'
            OR PATRONAL.IND_CONTRIBUICAO = 'S'
        THEN 'S'
        ELSE 'N'
    END                                                                         AS IND_CONTRIBUICAO,
    COUNT(DISTINCT BRUTO.MATRICULA)                                             AS "CONTRACHEQUES",
    COUNT(DISTINCT BRUTO.CPF)                                                   AS "CPFs",
    BRUTO.COD_GRUPO                                                             AS "CODIGO GRUPO",
    BRUTO.DESCRICAO_GRUPO                                                       AS "GRUPO",
    CASE BRUTO.TIPO_RELATORIO
        WHEN 'E' THEN 'EXECUTIVO'
        ELSE 'OUTROS PODERES'
    END                                                                         AS "TIPO DE RELATORIO",
    NVL(BASE.FAIXA, 1)                                                          AS "FAIXA",
    NVL(SUM(BASE.VALOR_CALCULADO), 0)                                           AS "VALOR BASE",
    NVL(SUM(FUNDO.VALOR_CALCULADO), 0)                                          AS "VALOR FUNDO",
    NVL(SUM(PATRONAL.VALOR_CALCULADO), 0)                                       AS "VALOR 28%",
    NVL(SUM(FUNDO.VALOR_CALCULADO), 0) + NVL(SUM(PATRONAL.VALOR_CALCULADO), 0)  AS "REPASSE",
    NVL(SUM(BRUTO.VALOR_CALCULADO), 0)                                          AS "VALOR BRUTO"
FROM
    (
        SELECT
            BRUTO.ORGAO,
            BRUTO.ID_FUNCIONARIO,
            BRUTO.MATRICULA,
            BRUTO.CPF,
            BRUTO.COD_GRUPO,
            BRUTO.DESCRICAO_GRUPO,
            BRUTO.TIPO_RELATORIO,
            SUM(BRUTO.VALOR_CALCULADO) AS VALOR_CALCULADO
        FROM
            TABELA_AUX BRUTO
        WHERE
            BRUTO.TIPO_RUBRICA = 'BRUTO'
        GROUP BY
            BRUTO.ORGAO,
            BRUTO.ID_FUNCIONARIO,
            BRUTO.MATRICULA,
            BRUTO.CPF,
            BRUTO.COD_GRUPO,
            BRUTO.DESCRICAO_GRUPO,
            BRUTO.TIPO_RELATORIO
    ) BRUTO
    LEFT JOIN (
        SELECT
            FUNDO.ORGAO,
            FUNDO.ID_FUNCIONARIO,
            FUNDO.MATRICULA,
            FUNDO.CPF,
            FUNDO.COD_GRUPO,
            FUNDO.DESCRICAO_GRUPO,
            FUNDO.TIPO_RELATORIO,
            SUM(FUNDO.VALOR_CALCULADO) AS VALOR_CALCULADO,
            CASE
                WHEN SUM(FUNDO.VALOR_CALCULADO) = 0 THEN 'N'
                ELSE 'S'
            END AS IND_CONTRIBUICAO
        FROM
            TABELA_AUX FUNDO
        WHERE
            FUNDO.TIPO_RUBRICA = 'FUNDO'
        GROUP BY
            FUNDO.ORGAO,
            FUNDO.ID_FUNCIONARIO,
            FUNDO.MATRICULA,
            FUNDO.CPF,
            FUNDO.COD_GRUPO,
            FUNDO.DESCRICAO_GRUPO,
            FUNDO.TIPO_RELATORIO
    ) FUNDO ON FUNDO.ORGAO = BRUTO.ORGAO
            AND FUNDO.MATRICULA = BRUTO.MATRICULA
            AND FUNDO.CPF = BRUTO.CPF
            AND FUNDO.ID_FUNCIONARIO = BRUTO.ID_FUNCIONARIO
            AND FUNDO.COD_GRUPO = BRUTO.COD_GRUPO
    LEFT JOIN (
        SELECT
            PATRONAL.ORGAO,
            PATRONAL.ID_FUNCIONARIO,
            PATRONAL.MATRICULA,
            PATRONAL.CPF,
            PATRONAL.COD_GRUPO,
            PATRONAL.DESCRICAO_GRUPO,
            PATRONAL.TIPO_RELATORIO,
            SUM(PATRONAL.VALOR_CALCULADO) AS VALOR_CALCULADO,
            CASE
                WHEN SUM(PATRONAL.VALOR_CALCULADO) = 0 THEN 'N'
                ELSE 'S'
            END AS IND_CONTRIBUICAO
        FROM
            TABELA_AUX PATRONAL
        WHERE
            PATRONAL.TIPO_RUBRICA = 'PATRONAL'
        GROUP BY
            PATRONAL.ORGAO,
            PATRONAL.ID_FUNCIONARIO,
            PATRONAL.MATRICULA,
            PATRONAL.CPF,
            PATRONAL.COD_GRUPO,
            PATRONAL.DESCRICAO_GRUPO,
            PATRONAL.TIPO_RELATORIO
    ) PATRONAL ON PATRONAL.ORGAO = BRUTO.ORGAO
            AND PATRONAL.MATRICULA = BRUTO.MATRICULA
            AND PATRONAL.CPF = BRUTO.CPF
            AND PATRONAL.ID_FUNCIONARIO = BRUTO.ID_FUNCIONARIO
            AND PATRONAL.COD_GRUPO = BRUTO.COD_GRUPO
    LEFT JOIN (
        SELECT
            BASE.ORGAO,
            BASE.ID_FUNCIONARIO,
            BASE.MATRICULA,
            BASE.CPF,
            BASE.COD_GRUPO,
            BASE.DESCRICAO_GRUPO,
            BASE.TIPO_RELATORIO,
            SUM(BASE.VALOR_CALCULADO) AS VALOR_CALCULADO,
            CASE
                WHEN SUM(BASE.VALOR_CALCULADO) = 0 THEN 'N'
                ELSE 'S'
            END AS IND_CONTRIBUICAO,
            CASE
                WHEN SUM(BASE.VALOR_CALCULADO) BETWEEN 0 AND 1518               THEN 1
                WHEN SUM(BASE.VALOR_CALCULADO) BETWEEN 1518.01 AND 1800         THEN 2
                WHEN SUM(BASE.VALOR_CALCULADO) BETWEEN 1800.01 AND 3000         THEN 3
                WHEN SUM(BASE.VALOR_CALCULADO) BETWEEN 3000.01 AND 999999999.99 THEN 4
                ELSE - 1
            END AS FAIXA
        FROM
            TABELA_AUX BASE
        WHERE
            BASE.TIPO_RUBRICA = 'BASE'
        GROUP BY
            BASE.ORGAO,
            BASE.ID_FUNCIONARIO,
            BASE.MATRICULA,
            BASE.CPF,
            BASE.COD_GRUPO,
            BASE.DESCRICAO_GRUPO,
            BASE.TIPO_RELATORIO
    ) BASE ON BASE.ORGAO = BRUTO.ORGAO
            AND BASE.MATRICULA = BRUTO.MATRICULA
            AND BASE.CPF = BRUTO.CPF
            AND BASE.ID_FUNCIONARIO = BRUTO.ID_FUNCIONARIO
            AND BASE.COD_GRUPO = BRUTO.COD_GRUPO
GROUP BY
    BRUTO.ORGAO,
    BRUTO.COD_GRUPO,
    BRUTO.DESCRICAO_GRUPO,
    BRUTO.TIPO_RELATORIO,
    NVL(BASE.FAIXA, 1),
    BASE.IND_CONTRIBUICAO,
    FUNDO.IND_CONTRIBUICAO,
    PATRONAL.IND_CONTRIBUICAO
ORDER BY
    BRUTO.ORGAO,
    BRUTO.COD_GRUPO,
    BRUTO.DESCRICAO_GRUPO,
    BRUTO.TIPO_RELATORIO,
    NVL(BASE.FAIXA, 1);