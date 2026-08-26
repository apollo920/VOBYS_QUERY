SELECT S.* FROM (
    SELECT
    'CBMPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CBMPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CBMPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CBMPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CBMPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_CBMPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CBMPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_CBMPI.FOLHA FO
    JOIN SW_CBMPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_CBMPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_CBMPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_CBMPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_CBMPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CBMPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_CBMPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_CBMPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_CBMPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'PGEPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_PGEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_PGEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_PGEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_PGEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_PGEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_PGEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_PGEPI.FOLHA FO
    JOIN SW_PGEPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_PGEPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_PGEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_PGEPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_PGEPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'PGEPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_PGEPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PGEPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_PGEPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'CGEPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CGEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CGEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CGEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CGEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_CGEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CGEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_CGEPI.FOLHA FO
    JOIN SW_CGEPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_CGEPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_CGEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_CGEPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_CGEPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CGEPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_CGEPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_CGEPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_CGEPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SSPPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SSPPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SSPPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SSPPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SSPPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SSPPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SSPPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SSPPI.FOLHA FO
    JOIN SW_SSPPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SSPPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SSPPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SSPPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SSPPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SSPPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SSPPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SSPPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SSPPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'COJUV' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_COJUV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_COJUV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_COJUV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_COJUV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_COJUV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_COJUV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_COJUV.FOLHA FO
    JOIN SW_COJUV.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_COJUV.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_COJUV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_COJUV.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_COJUV.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'COJUV'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_COJUV.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_COJUV.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_COJUV.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'ATIPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_ATIPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_ATIPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_ATIPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_ATIPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_ATIPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_ATIPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_ATIPI.FOLHA FO
    JOIN SW_ATIPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_ATIPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_ATIPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_ATIPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_ATIPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ATIPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_ATIPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_ATIPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_ATIPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'FAPEPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FAPEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FAPEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FAPEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FAPEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_FAPEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FAPEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_FAPEPI.FOLHA FO
    JOIN SW_FAPEPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_FAPEPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_FAPEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_FAPEPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_FAPEPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FAPEPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_FAPEPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_FAPEPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_FAPEPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'DEFCIVIL' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_DEFCIVIL.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_DEFCIVIL.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_DEFCIVIL.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_DEFCIVIL.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_DEFCIVIL.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_DEFCIVIL.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_DEFCIVIL.FOLHA FO
    JOIN SW_DEFCIVIL.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_DEFCIVIL.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_DEFCIVIL.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_DEFCIVIL.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_DEFCIVIL.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DEFCIVIL'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_DEFCIVIL.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_DEFCIVIL.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_DEFCIVIL.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'ADH' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_ADH.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_ADH.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_ADH.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_ADH.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_ADH.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_ADH.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_ADH.FOLHA FO
    JOIN SW_ADH.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_ADH.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_ADH.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_ADH.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_ADH.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ADH'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_ADH.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_ADH.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_ADH.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SEAGRO' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEAGRO.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEAGRO.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEAGRO.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEAGRO.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SEAGRO.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEAGRO.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SEAGRO.FOLHA FO
    JOIN SW_SEAGRO.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SEAGRO.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SEAGRO.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SEAGRO.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEAGRO.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEAGRO'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SEAGRO.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SEAGRO.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SEAGRO.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'IDEPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_IDEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_IDEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_IDEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_IDEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_IDEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_IDEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_IDEPI.FOLHA FO
    JOIN SW_IDEPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_IDEPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_IDEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_IDEPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_IDEPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IDEPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_IDEPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_IDEPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_IDEPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SURPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SURPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SURPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SURPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SURPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SURPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SURPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SURPI.FOLHA FO
    JOIN SW_SURPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SURPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SURPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SURPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SURPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SURPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SURPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SURPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SURPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SEID' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEID.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEID.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEID.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEID.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SEID.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEID.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SEID.FOLHA FO
    JOIN SW_SEID.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SEID.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SEID.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SEID.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEID.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEID'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SEID.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SEID.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SEID.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SECID' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SECID.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SECID.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SECID.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SECID.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SECID.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SECID.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SECID.FOLHA FO
    JOIN SW_SECID.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SECID.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SECID.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SECID.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SECID.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECID'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SECID.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SECID.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SECID.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'FUPIP' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FUPIP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FUPIP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FUPIP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FUPIP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_FUPIP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FUPIP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_FUPIP.FOLHA FO
    JOIN SW_FUPIP.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_FUPIP.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_FUPIP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_FUPIP.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_FUPIP.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FUPIP'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_FUPIP.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_FUPIP.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_FUPIP.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SETUR' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SETUR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SETUR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SETUR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SETUR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SETUR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SETUR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SETUR.FOLHA FO
    JOIN SW_SETUR.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SETUR.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SETUR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SETUR.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SETUR.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SETUR'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SETUR.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SETUR.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SETUR.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'AGESPISA' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_AGESPISA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_AGESPISA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_AGESPISA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_AGESPISA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_AGESPISA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_AGESPISA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_AGESPISA.FOLHA FO
    JOIN SW_AGESPISA.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_AGESPISA.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_AGESPISA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_AGESPISA.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_AGESPISA.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'AGESPISA'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_AGESPISA.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_AGESPISA.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_AGESPISA.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SETRANS' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SETRANS.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SETRANS.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SETRANS.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SETRANS.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SETRANS.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SETRANS.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SETRANS.FOLHA FO
    JOIN SW_SETRANS.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SETRANS.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SETRANS.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SETRANS.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SETRANS.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SETRANS'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SETRANS.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SETRANS.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SETRANS.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'TVANTARES' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_TVANTARES.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_TVANTARES.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_TVANTARES.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_TVANTARES.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_TVANTARES.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_TVANTARES.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_TVANTARES.FOLHA FO
    JOIN SW_TVANTARES.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_TVANTARES.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_TVANTARES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_TVANTARES.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_TVANTARES.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'TVANTARES'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_TVANTARES.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_TVANTARES.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_TVANTARES.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'VICEGOV' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_VICEGOV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_VICEGOV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_VICEGOV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_VICEGOV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_VICEGOV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_VICEGOV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_VICEGOV.FOLHA FO
    JOIN SW_VICEGOV.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_VICEGOV.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_VICEGOV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_VICEGOV.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_VICEGOV.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'VICEGOV'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_VICEGOV.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_VICEGOV.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_VICEGOV.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SEINFRA' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEINFRA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEINFRA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEINFRA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEINFRA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SEINFRA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEINFRA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SEINFRA.FOLHA FO
    JOIN SW_SEINFRA.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SEINFRA.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SEINFRA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SEINFRA.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEINFRA.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEINFRA'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SEINFRA.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SEINFRA.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SEINFRA.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'CCOM' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CCOM.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CCOM.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CCOM.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CCOM.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_CCOM.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CCOM.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_CCOM.FOLHA FO
    JOIN SW_CCOM.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_CCOM.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_CCOM.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_CCOM.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_CCOM.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CCOM'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_CCOM.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_CCOM.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_CCOM.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'FUNDESPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FUNDESPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FUNDESPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FUNDESPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FUNDESPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_FUNDESPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FUNDESPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_FUNDESPI.FOLHA FO
    JOIN SW_FUNDESPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_FUNDESPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_FUNDESPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_FUNDESPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_FUNDESPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FUNDESPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_FUNDESPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_FUNDESPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_FUNDESPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SEDET' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEDET.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEDET.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEDET.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEDET.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SEDET.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEDET.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SEDET.FOLHA FO
    JOIN SW_SEDET.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SEDET.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SEDET.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SEDET.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEDET.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEDET'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SEDET.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SEDET.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SEDET.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'INTERPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_INTERPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_INTERPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_INTERPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_INTERPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_INTERPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_INTERPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_INTERPI.FOLHA FO
    JOIN SW_INTERPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_INTERPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_INTERPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_INTERPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_INTERPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'INTERPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_INTERPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_INTERPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_INTERPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'JUCEPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_JUCEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_JUCEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_JUCEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_JUCEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_JUCEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_JUCEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_JUCEPI.FOLHA FO
    JOIN SW_JUCEPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_JUCEPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_JUCEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_JUCEPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_JUCEPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'JUCEPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_JUCEPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_JUCEPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_JUCEPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SEMAR' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEMAR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEMAR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEMAR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEMAR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SEMAR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEMAR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SEMAR.FOLHA FO
    JOIN SW_SEMAR.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SEMAR.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SEMAR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SEMAR.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEMAR.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEMAR'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SEMAR.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SEMAR.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SEMAR.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'GMG' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_GMG.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_GMG.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_GMG.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_GMG.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_GMG.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_GMG.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_GMG.FOLHA FO
    JOIN SW_GMG.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_GMG.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_GMG.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_GMG.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_GMG.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'GMG'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_GMG.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_GMG.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_GMG.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SEPLAN' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEPLAN.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEPLAN.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEPLAN.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEPLAN.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SEPLAN.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEPLAN.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SEPLAN.FOLHA FO
    JOIN SW_SEPLAN.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SEPLAN.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SEPLAN.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SEPLAN.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEPLAN.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEPLAN'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SEPLAN.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SEPLAN.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SEPLAN.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SAF' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SAF.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SAF.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SAF.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SAF.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SAF.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SAF.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SAF.FOLHA FO
    JOIN SW_SAF.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SAF.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SAF.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SAF.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SAF.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SAF'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SAF.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SAF.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SAF.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SECULT' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SECULT.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SECULT.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SECULT.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SECULT.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SECULT.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SECULT.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SECULT.FOLHA FO
    JOIN SW_SECULT.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SECULT.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SECULT.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SECULT.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SECULT.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECULT'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SECULT.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SECULT.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SECULT.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'DER' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_DER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_DER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_DER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_DER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_DER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_DER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_DER.FOLHA FO
    JOIN SW_DER.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_DER.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_DER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_DER.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_DER.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DER'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_DER.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_DER.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_DER.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'DETRAN' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_DETRAN.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_DETRAN.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_DETRAN.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_DETRAN.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_DETRAN.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_DETRAN.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_DETRAN.FOLHA FO
    JOIN SW_DETRAN.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_DETRAN.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_DETRAN.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_DETRAN.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_DETRAN.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'DETRAN'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_DETRAN.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_DETRAN.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_DETRAN.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'IASPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_IASPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_IASPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_IASPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_IASPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_IASPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_IASPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_IASPI.FOLHA FO
    JOIN SW_IASPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_IASPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_IASPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_IASPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_IASPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IASPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_IASPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_IASPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_IASPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'ADAPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_ADAPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_ADAPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_ADAPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_ADAPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_ADAPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_ADAPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_ADAPI.FOLHA FO
    JOIN SW_ADAPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_ADAPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_ADAPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_ADAPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_ADAPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'ADAPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_ADAPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_ADAPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_ADAPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'IMEPIPROD' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_IMEPIPROD.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_IMEPIPROD.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_IMEPIPROD.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_IMEPIPROD.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_IMEPIPROD.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_IMEPIPROD.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_IMEPIPROD.FOLHA FO
    JOIN SW_IMEPIPROD.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_IMEPIPROD.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_IMEPIPROD.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_IMEPIPROD.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_IMEPIPROD.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IMEPIPROD'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_IMEPIPROD.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_IMEPIPROD.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_IMEPIPROD.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'CPVCI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CPVCI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CPVCI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CPVCI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CPVCI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_CPVCI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CPVCI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_CPVCI.FOLHA FO
    JOIN SW_CPVCI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_CPVCI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_CPVCI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_CPVCI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_CPVCI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CPVCI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_CPVCI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_CPVCI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_CPVCI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'CENDROGAS' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CENDROGAS.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CENDROGAS.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CENDROGAS.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CENDROGAS.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_CENDROGAS.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CENDROGAS.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_CENDROGAS.FOLHA FO
    JOIN SW_CENDROGAS.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_CENDROGAS.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_CENDROGAS.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_CENDROGAS.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_CENDROGAS.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CENDROGAS'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_CENDROGAS.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_CENDROGAS.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_CENDROGAS.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'COFIR' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_COFIR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_COFIR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_COFIR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_COFIR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_COFIR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_COFIR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_COFIR.FOLHA FO
    JOIN SW_COFIR.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_COFIR.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_COFIR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_COFIR.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_COFIR.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'COFIR'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_COFIR.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_COFIR.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_COFIR.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SEMINPER' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEMINPER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEMINPER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEMINPER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEMINPER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SEMINPER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEMINPER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SEMINPER.FOLHA FO
    JOIN SW_SEMINPER.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SEMINPER.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SEMINPER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SEMINPER.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEMINPER.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEMINPER'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SEMINPER.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SEMINPER.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SEMINPER.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'AGRESP' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_AGRESP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_AGRESP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_AGRESP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_AGRESP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_AGRESP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_AGRESP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_AGRESP.FOLHA FO
    JOIN SW_AGRESP.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_AGRESP.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_AGRESP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_AGRESP.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_AGRESP.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'AGRESP'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_AGRESP.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_AGRESP.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_AGRESP.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'CEPM' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CEPM.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CEPM.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CEPM.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CEPM.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_CEPM.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CEPM.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_CEPM.FOLHA FO
    JOIN SW_CEPM.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_CEPM.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_CEPM.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_CEPM.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_CEPM.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CEPM'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_CEPM.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_CEPM.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_CEPM.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'EMATER' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMATER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMATER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMATER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMATER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_EMATER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMATER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_EMATER.FOLHA FO
    JOIN SW_EMATER.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_EMATER.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_EMATER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_EMATER.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMATER.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMATER'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_EMATER.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_EMATER.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_EMATER.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'FUESPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FUESPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FUESPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FUESPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FUESPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_FUESPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FUESPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_FUESPI.FOLHA FO
    JOIN SW_FUESPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_FUESPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_FUESPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_FUESPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_FUESPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FUESPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_FUESPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_FUESPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_FUESPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'EMATERPROD' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMATERPROD.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMATERPROD.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMATERPROD.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMATERPROD.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_EMATERPROD.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMATERPROD.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_EMATERPROD.FOLHA FO
    JOIN SW_EMATERPROD.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_EMATERPROD.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_EMATERPROD.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_EMATERPROD.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMATERPROD.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMATERPROD'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_EMATERPROD.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_EMATERPROD.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_EMATERPROD.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'CDTER' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CDTER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CDTER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CDTER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CDTER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_CDTER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_CDTER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_CDTER.FOLHA FO
    JOIN SW_CDTER.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_CDTER.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_CDTER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_CDTER.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_CDTER.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'CDTER'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_CDTER.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_CDTER.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_CDTER.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SERES' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SERES.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SERES.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SERES.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SERES.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SERES.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SERES.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SERES.FOLHA FO
    JOIN SW_SERES.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SERES.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SERES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SERES.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SERES.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SERES'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SERES.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SERES.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SERES.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SECESP' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SECESP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SECESP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SECESP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SECESP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SECESP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SECESP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SECESP.FOLHA FO
    JOIN SW_SECESP.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SECESP.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SECESP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SECESP.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SECESP.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECESP'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SECESP.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SECESP.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SECESP.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'EMGERPI_CORESA' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_CORESA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_CORESA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_CORESA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_CORESA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_EMGERPI_CORESA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_CORESA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_EMGERPI_CORESA.FOLHA FO
    JOIN SW_EMGERPI_CORESA.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_EMGERPI_CORESA.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_EMGERPI_CORESA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_CORESA.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_CORESA.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_CORESA'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_CORESA.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_CORESA.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_EMGERPI_CORESA.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'FUNPREV' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FUNPREV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FUNPREV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FUNPREV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FUNPREV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_FUNPREV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FUNPREV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_FUNPREV.FOLHA FO
    JOIN SW_FUNPREV.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_FUNPREV.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_FUNPREV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_FUNPREV.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_FUNPREV.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FUNPREV'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_FUNPREV.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_FUNPREV.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_FUNPREV.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'FESPPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FESPPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FESPPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FESPPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FESPPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_FESPPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_FESPPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_FESPPI.FOLHA FO
    JOIN SW_FESPPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_FESPPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_FESPPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_FESPPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_FESPPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'FESPPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_FESPPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_FESPPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_FESPPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SIA' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SIA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SIA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SIA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SIA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SIA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SIA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SIA.FOLHA FO
    JOIN SW_SIA.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SIA.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SIA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SIA.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SIA.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SIA'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SIA.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SIA.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SIA.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SETRE' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SETRE.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SETRE.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SETRE.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SETRE.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SETRE.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SETRE.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SETRE.FOLHA FO
    JOIN SW_SETRE.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SETRE.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SETRE.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SETRE.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SETRE.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SETRE'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SETRE.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SETRE.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SETRE.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'AGESPISA02' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_AGESPISA02.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_AGESPISA02.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_AGESPISA02.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_AGESPISA02.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_AGESPISA02.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_AGESPISA02.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_AGESPISA02.FOLHA FO
    JOIN SW_AGESPISA02.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_AGESPISA02.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_AGESPISA02.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_AGESPISA02.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_AGESPISA02.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'AGESPISA02'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_AGESPISA02.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_AGESPISA02.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_AGESPISA02.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SEGOV' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEGOV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEGOV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEGOV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEGOV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SEGOV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEGOV.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SEGOV.FOLHA FO
    JOIN SW_SEGOV.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SEGOV.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SEGOV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SEGOV.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEGOV.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEGOV'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SEGOV.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SEGOV.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SEGOV.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SASC' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SASC.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SASC.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SASC.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SASC.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SASC.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SASC.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SASC.FOLHA FO
    JOIN SW_SASC.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SASC.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SASC.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SASC.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SASC.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SASC'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SASC.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SASC.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SASC.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'METRO' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_METRO.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_METRO.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_METRO.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_METRO.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_METRO.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_METRO.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_METRO.FOLHA FO
    JOIN SW_METRO.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_METRO.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_METRO.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_METRO.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_METRO.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'METRO'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_METRO.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_METRO.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_METRO.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SADA' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SADA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SADA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SADA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SADA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SADA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SADA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SADA.FOLHA FO
    JOIN SW_SADA.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SADA.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SADA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SADA.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SADA.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SADA'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SADA.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SADA.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SADA.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SECMULHERES' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SECMULHERES.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SECMULHERES.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SECMULHERES.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SECMULHERES.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SECMULHERES.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SECMULHERES.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SECMULHERES.FOLHA FO
    JOIN SW_SECMULHERES.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SECMULHERES.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SECMULHERES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SECMULHERES.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SECMULHERES.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SECMULHERES'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SECMULHERES.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SECMULHERES.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SECMULHERES.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'EMGERPI_EMATER' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_EMATER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_EMATER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_EMATER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_EMATER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_EMGERPI_EMATER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_EMATER.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_EMGERPI_EMATER.FOLHA FO
    JOIN SW_EMGERPI_EMATER.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_EMGERPI_EMATER.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_EMGERPI_EMATER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_EMATER.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_EMATER.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_EMATER'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_EMATER.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_EMATER.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_EMGERPI_EMATER.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SESAPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SESAPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SESAPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SESAPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SESAPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SESAPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SESAPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SESAPI.FOLHA FO
    JOIN SW_SESAPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SESAPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SESAPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SESAPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SESAPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SESAPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SESAPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SESAPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SESAPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'PMPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_PMPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_PMPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_PMPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_PMPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_PMPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_PMPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_PMPI.FOLHA FO
    JOIN SW_PMPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_PMPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_PMPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_PMPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_PMPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'PMPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_PMPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PMPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_PMPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SEJUSPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEJUSPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEJUSPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEJUSPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEJUSPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SEJUSPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEJUSPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SEJUSPI.FOLHA FO
    JOIN SW_SEJUSPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SEJUSPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SEJUSPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SEJUSPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEJUSPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEJUSPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SEJUSPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SEJUSPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SEJUSPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SEFAZPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEFAZPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEFAZPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEFAZPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEFAZPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SEFAZPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEFAZPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SEFAZPI.FOLHA FO
    JOIN SW_SEFAZPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SEFAZPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SEFAZPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SEFAZPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEFAZPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEFAZPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SEFAZPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SEFAZPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SEFAZPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SEADPREVPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEADPREVPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEADPREVPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEADPREVPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEADPREVPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SEADPREVPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEADPREVPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SEADPREVPI.FOLHA FO
    JOIN SW_SEADPREVPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SEADPREVPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SEADPREVPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SEADPREVPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEADPREVPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEADPREVPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SEADPREVPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SEADPREVPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SEADPREVPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'IMEPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_IMEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_IMEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_IMEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_IMEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_IMEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_IMEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_IMEPI.FOLHA FO
    JOIN SW_IMEPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_IMEPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_IMEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_IMEPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_IMEPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'IMEPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_IMEPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_IMEPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_IMEPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'BEP' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_BEP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_BEP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_BEP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_BEP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_BEP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_BEP.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_BEP.FOLHA FO
    JOIN SW_BEP.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_BEP.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_BEP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_BEP.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_BEP.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'BEP'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_BEP.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_BEP.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_BEP.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'EMGERPI_COMEPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_COMEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_COMEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_COMEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_COMEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_EMGERPI_COMEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_COMEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_EMGERPI_COMEPI.FOLHA FO
    JOIN SW_EMGERPI_COMEPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_EMGERPI_COMEPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_EMGERPI_COMEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_COMEPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_COMEPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_COMEPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_COMEPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_COMEPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_EMGERPI_COMEPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'EMGERPI_COMDEPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_COMDEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_COMDEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_COMDEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_COMDEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_EMGERPI_COMDEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_COMDEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_EMGERPI_COMDEPI.FOLHA FO
    JOIN SW_EMGERPI_COMDEPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_EMGERPI_COMDEPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_EMGERPI_COMDEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_COMDEPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_COMDEPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_COMDEPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_COMDEPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_COMDEPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_EMGERPI_COMDEPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'EMGERPI_COHAB' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_COHAB.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_COHAB.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_COHAB.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_COHAB.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_EMGERPI_COHAB.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_COHAB.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_EMGERPI_COHAB.FOLHA FO
    JOIN SW_EMGERPI_COHAB.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_EMGERPI_COHAB.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_EMGERPI_COHAB.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_COHAB.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_COHAB.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_COHAB'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_COHAB.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_COHAB.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_EMGERPI_COHAB.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'EMGERPI_PRODEPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_PRODEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_PRODEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_PRODEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_PRODEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_EMGERPI_PRODEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_PRODEPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_EMGERPI_PRODEPI.FOLHA FO
    JOIN SW_EMGERPI_PRODEPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_EMGERPI_PRODEPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_EMGERPI_PRODEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_PRODEPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_PRODEPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_PRODEPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_PRODEPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_PRODEPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_EMGERPI_PRODEPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'EMGERPI_CEASA' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_CEASA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_CEASA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_CEASA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_CEASA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_EMGERPI_CEASA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_CEASA.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_EMGERPI_CEASA.FOLHA FO
    JOIN SW_EMGERPI_CEASA.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_EMGERPI_CEASA.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_EMGERPI_CEASA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_CEASA.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_CEASA.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_CEASA'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_CEASA.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_CEASA.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_EMGERPI_CEASA.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'EMGERPI_PIEMTUR' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_PIEMTUR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_PIEMTUR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_PIEMTUR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_PIEMTUR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_EMGERPI_PIEMTUR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_PIEMTUR.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_EMGERPI_PIEMTUR.FOLHA FO
    JOIN SW_EMGERPI_PIEMTUR.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_EMGERPI_PIEMTUR.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_EMGERPI_PIEMTUR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_PIEMTUR.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_PIEMTUR.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_PIEMTUR'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_PIEMTUR.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_PIEMTUR.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_EMGERPI_PIEMTUR.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'EMGERPI_ETELPI_FUNART' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_ETELPI_FUNART.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_ETELPI_FUNART.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_ETELPI_FUNART.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_ETELPI_FUNART.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_EMGERPI_ETELPI_FUNART.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_ETELPI_FUNART.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_EMGERPI_ETELPI_FUNART.FOLHA FO
    JOIN SW_EMGERPI_ETELPI_FUNART.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_EMGERPI_ETELPI_FUNART.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_EMGERPI_ETELPI_FUNART.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_ETELPI_FUNART.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_ETELPI_FUNART.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_ETELPI_FUNART'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_ETELPI_FUNART.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_ETELPI_FUNART.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_EMGERPI_ETELPI_FUNART.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'EMGERPI_CIDAPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_CIDAPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_CIDAPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_CIDAPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_CIDAPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_EMGERPI_CIDAPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_CIDAPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_EMGERPI_CIDAPI.FOLHA FO
    JOIN SW_EMGERPI_CIDAPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_EMGERPI_CIDAPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_EMGERPI_CIDAPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_CIDAPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_CIDAPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_CIDAPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_CIDAPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_CIDAPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_EMGERPI_CIDAPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'SEDUC' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEDUC.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEDUC.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEDUC.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEDUC.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_SEDUC.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_SEDUC.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_SEDUC.FOLHA FO
    JOIN SW_SEDUC.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_SEDUC.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_SEDUC.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_SEDUC.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEDUC.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'SEDUC'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_SEDUC.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_SEDUC.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_SEDUC.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'EMGERPI' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_EMGERPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_EMGERPI.FOLHA FO
    JOIN SW_EMGERPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_EMGERPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_EMGERPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_EMGERPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
UNION ALL    
    SELECT
    'EMGERPI_CODIPI       ' ORGAO,
    FO.CHAVE_FOLHA,
    FO.DESCRICAO,
    FC.ANO                          NU_ANO,
    FC.MES                          NU_MES,
    22                              CO_IBGE,
    'Governo do Estado do Piauí'    NO_ENTE,
    'PI'                            SG_UF,
    CASE
        WHEN CF.ID_CATEGORIA_FUNCIONAL IN (
            1000061, -- SOLDADO
            1000080, -- CABO
            1000261, -- 1 TENENTE
            1000281, -- 2 TENENTE
            1000060, -- 1 SARGENTO
            1000262, -- 2 SARGENTO
            1000260, -- 3 SARGENTO
            1000440, -- CORONEL
            1000284, -- TENENTE-CORONEL
            1000223, -- MAJOR
            1000286, -- CAPITAO
            1000287, -- SUBTENENTE
            1000285, -- 1º Sargento
            1000263, -- Soldado
            1000421, -- 1º Tenente
            1000280, -- Capitão
            1000460, -- Tenente Coronel
            1000461, -- Coronel
            1000380  -- Major
        ) THEN 2 -- Militar
        ELSE 1   -- Civil
    END                             CO_COMP_MASSA,
    1                               CO_TIPO_FUNDO, -- Plano Previdenciário
    E.CNPJ                          CNPJ_ORGAO,
    E.RAZAO_SOCIAL                  NO_ORGAO,
    1                               CO_PODER,      -- Executivo
    1                               CO_TIPO_PODER, -- Administração Direta
    CASE
        WHEN FI.ID_REGIME IN (1000003, 9) THEN
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 4 -- Militar Inativo (Reserva/Reforma)
                ELSE 3                                    -- Militar Ativo
            END
        WHEN FI.ID_REGIME = 5 THEN 2  -- Pensão Previdenciária → Instituidor era Civil Aposentado
        ELSE
            CASE
                WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2 -- Civil Aposentado
                ELSE 1                                    -- Civil Ativo
            END
    END                             CO_TIPO_INSTITUIDOR,
    FC.MATRICULA_INSTITUIDOR        ID_INSTITUIDOR_MATRICULA,
    FC.CPF_INSTITUIDOR              ID_INSTITUIDOR_CPF,
    FC.PISPASEP                     ID_INSTITUIDOR_PIS_PASEP,
    FC.DATA_NASCIMENTO              DT_NASC_INSTITUIDOR,
    PO.DATA_OBITO                   DT_OBITO_INSTITUIDOR,
    FC.COD_INSTITUCIONAL            ID_PENSIONISTA_MATRICULA,
    FC.CPF_PESSOA                   ID_PENSIONISTA_CPF,
    CASE
        WHEN P.ID_SEXO = 1 THEN 'M'
        WHEN P.ID_SEXO = 2 THEN 'F'
    END                             CO_SEXO_PENSIONISTA,
    FC.DATA_NASCIMENTO              DT_NASC_PENSIONISTA,
    CASE
        WHEN PO.DATA_OBITO IS NOT NULL THEN 12 
        ELSE 13                                
    END                             CO_SITUACAO,
    PO.DATA_OBITO                   DT_SITUACAO,
    CASE PF.ID_PARENTESCO
        WHEN 2       THEN 1  -- Cônjuge
        WHEN 3       THEN 1  -- Companheiro(a)
        WHEN 1000307 THEN 1  -- Ex-cônjuge
        WHEN 28      THEN 1  -- Ex-esposo(a)
        WHEN 1       THEN 2  -- Filho(a) < 21 anos
        WHEN 12      THEN 3  -- Filho Excepcional (inválido/deficiência)
        WHEN 4       THEN 4  -- Pai(Mãe)
        WHEN 26      THEN 5  -- Irmão(ã)
        WHEN 8       THEN 6  -- Menor sob Guarda
        WHEN 9       THEN 6  -- Enteado(a)
        WHEN 10      THEN 6  -- Padastro(Madrasta)
        WHEN 13      THEN 6  -- Agregado/Outros
        WHEN 14      THEN 6  -- Primo(a)
        WHEN 15      THEN 6  -- Tio(a)
        WHEN 16      THEN 6  -- Avô(ó)
        WHEN 17      THEN 6  -- Cunhado(a)
        WHEN 18      THEN 6  -- Bisavô(ó)
        WHEN 19      THEN 6  -- Neto(a)
        WHEN 20      THEN 6  -- Bisneto(a)
        WHEN 21      THEN 6  -- Sobrinho(a)
        WHEN 23      THEN 6  -- Pensionista Alimentar (Desativado)
        WHEN 24      THEN 6  -- Pensionista Civil
        WHEN 27      THEN 6  -- Pensionista
        WHEN 29      THEN 6  -- Pensionista Alimentar (Pensão Civil)
        ELSE 6               -- Não informado ou outros
    END                             CO_TIPO_RELACAO,
    PF.DATA_INICIO                  DT_INICIO_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_CODIPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (141001, 142001, 151001, 152001)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_BENEF_PENSAO,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_CODIPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 710900
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TOT_PENSAO,
    PC.PERCENTUAL                   VL_PCT_QUOTA, 
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_CODIPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA IN (1552873, 1001040, 1000600, 1553806)
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_CONTRIBUICAO,
    /*
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_CODIPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = ZZZZ  -- ⚠️ PENDENTE: rubrica da compensação previdenciária
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_COMPENS_PREVID,
    */
    CASE
        WHEN PC.IND_CALCULO = 'P' THEN 1 
        WHEN PC.IND_CALCULO IN ('R', 'B') THEN 2  
        ELSE NULL
    END                             IN_PARID_SERV,
    CASE 
        WHEN PCF.IND_DEF_FISICA = 'S' 
          OR PCF.IND_DEF_VISUAL = 'S' 
          OR PCF.IND_DEF_AUDITIVA = 'S' 
          OR PCF.IND_DEF_MENTAL = 'S' 
          OR PCF.IND_DEF_INTELECTUAL = 'S' 
          OR PCF.IND_CAPACIDADE_TRABALHO = 'S' THEN 2 -- Inválido
        ELSE 1 -- Válido
    END                             CO_CONDICAO,
    CASE
        WHEN PC.IND_PENSAO = 'V' THEN 1  -- Vitalício
        WHEN PC.IND_PENSAO = 'T' THEN 2  -- Temporário
        ELSE NULL
    END                             CO_DURACAO,
    CASE
        WHEN PC.IND_PENSAO = 'T' THEN 2026 - EXTRACT(YEAR FROM PC.DATA_INICIO)
        ELSE NULL
    END                             NU_TEMPO_DURACAO,
    NVL((
        SELECT 1
        FROM SW_EMGERPI_CODIPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 1001042
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
    ), 2)                           IN_PREV_COMP,
    NVL((
        SELECT SUM(VALOR_CALCULADO)
        FROM SW_EMGERPI_CODIPI.FOLHA_FICHA_FINANCEIRA
        WHERE ID_RUBRICA = 431
          AND ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO
        GROUP BY ID_FOLHA_FUNCIONARIO
    ), 0)                           VL_TETO_ESPECIFICO,
    ROW_NUMBER() OVER (PARTITION BY FO.ANO, FC.COD_INSTITUCIONAL, FC.CPF_PESSOA ORDER BY FO.MES DESC) RN,
    CASE WHEN EXTRACT(YEAR FROM PO.DATA_OBITO) = 2025 THEN 'S' ELSE 'N' END AS IN_OBITO_2025
FROM
    SW_EMGERPI_CODIPI.FOLHA FO
    JOIN SW_EMGERPI_CODIPI.FOLHA_CONTRACHEQUE FC ON FC.ID_FOLHA = FO.ID_FOLHA
    JOIN SW_EMGERPI_CODIPI.FUNC_PENSAO_CIVIL PC ON PC.ID_PENSIONISTA = FC.ID_PENSIONISTA
    JOIN SW_EMGERPI_CODIPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = PC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_CODIPI.FUNCIONARIO_REFERENCIA FREF ON FREF.ID_FUNCIONARIO = PC.ID_FUNCIONARIO AND FREF.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_CODIPI.RHB_CARREIRA_CATEG_FUNCIONAL CF ON CF.ID_CATEGORIA_FUNCIONAL = FREF.ID_CATEGORIA_FUNCIONAL
    JOIN SW_PUBLICO.EMPRESA E ON E.SIGLA = 'EMGERPI_CODIPI'
    JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_CERTIDAO_OBITO PO ON PO.ID_PESSOA = FC.ID_PESSOA
    JOIN SW_PUBLICO.PESSOA_DECLARACAO_FAMILIA PF ON PF.ID_DECLARACAO_FAMILIA = PC.ID_DECLARACAO_FAMILIA
    JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ESTADO_CIVIL EC ON EC.ID_PESSOA = P.ID_PESSOA AND EC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_CODIPI.FOLHA_FUNC_PERFIL FP ON FP.ID_FOLHA_FUNCIONARIO = FC.ID_FOLHA_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_CODIPI.RHB_PERFIL PER ON PER.ID_PERFIL = FP.ID_PERFIL
    LEFT JOIN SW_EMGERPI_CODIPI.RHB_CARREIRA C ON C.ID_CARREIRA = CF.ID_CARREIRA
WHERE
    FO.ANO = 2025
    AND FO.ID_TIPO_FOLHA = 1000000
    AND FC.ID_PENSIONISTA IS NOT NULL
)S WHERE S.RN = 1