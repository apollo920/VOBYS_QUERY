SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_ADAPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_ADAPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_ADAPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_ADAPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_ADAPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_ADAPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_ADAPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_ADH.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_ADH.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_ADH.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_ADH.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_ADH.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_ADH.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_ADH.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_AGESPISA.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_AGESPISA.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_AGESPISA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_AGESPISA.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_AGESPISA.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_AGESPISA.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_AGESPISA.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_AGESPISA02.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_AGESPISA02.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_AGESPISA02.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_AGESPISA02.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_AGESPISA02.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_AGESPISA02.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_AGESPISA02.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_AGRESP.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_AGRESP.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_AGRESP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_AGRESP.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_AGRESP.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_AGRESP.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_AGRESP.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_BEP.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_BEP.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_BEP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_BEP.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_BEP.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_BEP.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_BEP.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_CBMPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_CBMPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_CBMPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_CBMPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_CBMPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_CBMPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_CBMPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_CCOM.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_CCOM.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_CCOM.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_CCOM.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_CCOM.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_CCOM.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_CCOM.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_CDTER.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_CDTER.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_CDTER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_CDTER.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_CDTER.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_CDTER.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_CDTER.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_CENDROGAS.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_CENDROGAS.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_CENDROGAS.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_CENDROGAS.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_CENDROGAS.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_CENDROGAS.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_CENDROGAS.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_COFIR.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_COFIR.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_COFIR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_COFIR.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_COFIR.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_COFIR.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_COFIR.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_COJUV.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_COJUV.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_COJUV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_COJUV.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_COJUV.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_COJUV.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_COJUV.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_DEFCIVIL.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_DEFCIVIL.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_DEFCIVIL.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_DEFCIVIL.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_DEFCIVIL.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_DEFCIVIL.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_DEFCIVIL.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_DER.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_DER.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_DER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_DER.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_DER.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_DER.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_DER.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_DETRAN.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_DETRAN.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_DETRAN.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_DETRAN.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_DETRAN.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_DETRAN.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_DETRAN.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_EMGERPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_EMGERPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_EMGERPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_EMGERPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_EMGERPI_CEASA.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_EMGERPI_CEASA.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_CEASA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_CEASA.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_EMGERPI_CEASA.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_CEASA.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_EMGERPI_CEASA.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_EMGERPI_CIDAPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_EMGERPI_CIDAPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_CIDAPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_CIDAPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_EMGERPI_CIDAPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_CIDAPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_EMGERPI_CIDAPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_EMGERPI_CODIPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_EMGERPI_CODIPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_CODIPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_CODIPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_EMGERPI_CODIPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_CODIPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_EMGERPI_CODIPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_EMGERPI_COHAB.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_EMGERPI_COHAB.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_COHAB.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_COHAB.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_EMGERPI_COHAB.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_COHAB.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_EMGERPI_COHAB.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_EMGERPI_COMDEPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_EMGERPI_COMDEPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_COMDEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_COMDEPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_EMGERPI_COMDEPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_COMDEPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_EMGERPI_COMDEPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_EMGERPI_COMEPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_EMGERPI_COMEPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_COMEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_COMEPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_EMGERPI_COMEPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_COMEPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_EMGERPI_COMEPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_EMGERPI_CORESA.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_EMGERPI_CORESA.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_CORESA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_CORESA.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_EMGERPI_CORESA.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_CORESA.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_EMGERPI_CORESA.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_EMGERPI_EMATER.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_EMGERPI_EMATER.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_EMATER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_EMATER.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_EMGERPI_EMATER.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_EMATER.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_EMGERPI_EMATER.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_EMGERPI_ETELPI_FUNART.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_EMGERPI_ETELPI_FUNART.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_ETELPI_FUNART.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_ETELPI_FUNART.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_EMGERPI_ETELPI_FUNART.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_ETELPI_FUNART.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_EMGERPI_ETELPI_FUNART.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_EMGERPI_PIEMTUR.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_EMGERPI_PIEMTUR.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_PIEMTUR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_PIEMTUR.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_EMGERPI_PIEMTUR.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_PIEMTUR.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_EMGERPI_PIEMTUR.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_EMGERPI_PRODEPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_EMGERPI_PRODEPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_EMGERPI_PRODEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_EMGERPI_PRODEPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_EMGERPI_PRODEPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_EMGERPI_PRODEPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_EMGERPI_PRODEPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_FAPEPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_FAPEPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_FAPEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_FAPEPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_FAPEPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_FAPEPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_FAPEPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_FESPPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_FESPPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_FESPPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_FESPPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_FESPPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_FESPPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_FESPPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_FUESPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_FUESPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_FUESPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_FUESPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_FUESPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_FUESPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_FUESPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_FUNPREV.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_FUNPREV.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_FUNPREV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_FUNPREV.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_FUNPREV.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_FUNPREV.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_FUNPREV.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_FUPIP.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_FUPIP.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_FUPIP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_FUPIP.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_FUPIP.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_FUPIP.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_FUPIP.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_GMG.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_GMG.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_GMG.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_GMG.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_GMG.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_GMG.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_GMG.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_IASPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_IASPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_IASPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_IASPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_IASPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_IASPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_IASPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_IDEPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_IDEPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_IDEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_IDEPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_IDEPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_IDEPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_IDEPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_IMEPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_IMEPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_IMEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_IMEPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_IMEPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_IMEPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_IMEPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_IMEPIPROD.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_IMEPIPROD.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_IMEPIPROD.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_IMEPIPROD.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_IMEPIPROD.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_IMEPIPROD.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_IMEPIPROD.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_INTERPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_INTERPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_INTERPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_INTERPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_INTERPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_INTERPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_INTERPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_JUCEPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_JUCEPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_JUCEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_JUCEPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_JUCEPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_JUCEPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_JUCEPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_METRO.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_METRO.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_METRO.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_METRO.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_METRO.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_METRO.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_METRO.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_PGEPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_PGEPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_PGEPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PGEPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_PGEPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_PGEPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_PGEPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_PMPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_PMPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_PMPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PMPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_PMPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_PMPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_PMPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SADA.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SADA.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SADA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SADA.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SADA.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SADA.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SADA.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SAF.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SAF.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SAF.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SAF.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SAF.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SAF.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SAF.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SASC.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SASC.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SASC.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SASC.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SASC.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SASC.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SASC.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SEADPREVPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SEADPREVPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEADPREVPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SEADPREVPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SEADPREVPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SEADPREVPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SEADPREVPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SEAGRO.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SEAGRO.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEAGRO.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SEAGRO.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SEAGRO.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SEAGRO.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SEAGRO.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SECESP.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SECESP.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SECESP.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SECESP.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SECESP.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SECESP.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SECESP.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SECID.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SECID.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SECID.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SECID.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SECID.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SECID.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SECID.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SECMULHERES.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SECMULHERES.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SECMULHERES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SECMULHERES.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SECMULHERES.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SECMULHERES.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SECMULHERES.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SECULT.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SECULT.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SECULT.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SECULT.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SECULT.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SECULT.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SECULT.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SEDET.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SEDET.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEDET.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SEDET.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SEDET.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SEDET.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SEDET.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SEDUC.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SEDUC.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEDUC.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SEDUC.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SEDUC.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SEDUC.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SEDUC.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SEFAZPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SEFAZPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEFAZPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SEFAZPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SEFAZPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SEFAZPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SEFAZPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SEGOV.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SEGOV.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEGOV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SEGOV.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SEGOV.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SEGOV.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SEGOV.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SEID.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SEID.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEID.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SEID.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SEID.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SEID.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SEID.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SEINFRA.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SEINFRA.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEINFRA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SEINFRA.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SEINFRA.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SEINFRA.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SEINFRA.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SEJUSPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SEJUSPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEJUSPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SEJUSPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SEJUSPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SEJUSPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SEJUSPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SEMAR.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SEMAR.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEMAR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SEMAR.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SEMAR.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SEMAR.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SEMAR.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SEMINPER.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SEMINPER.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEMINPER.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SEMINPER.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SEMINPER.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SEMINPER.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SEMINPER.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SEPLAN.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SEPLAN.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SEPLAN.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SEPLAN.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SEPLAN.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SEPLAN.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SEPLAN.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SERES.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SERES.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SERES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SERES.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SERES.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SERES.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SERES.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SESAPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SESAPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SESAPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SESAPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SESAPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SESAPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SESAPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SETRANS.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SETRANS.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SETRANS.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SETRANS.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SETRANS.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SETRANS.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SETRANS.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SETRE.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SETRE.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SETRE.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SETRE.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SETRE.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SETRE.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SETRE.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SETUR.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SETUR.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SETUR.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SETUR.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SETUR.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SETUR.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SETUR.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SIA.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SIA.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SIA.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SIA.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SIA.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SIA.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SIA.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SSPPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SSPPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SSPPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SSPPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SSPPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SSPPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SSPPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_SURPI.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_SURPI.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_SURPI.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_SURPI.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_SURPI.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_SURPI.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_SURPI.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_TVANTARES.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_TVANTARES.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_TVANTARES.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_TVANTARES.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_TVANTARES.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_TVANTARES.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_TVANTARES.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000

UNION ALL

SELECT 
    CUF.NOME_UNIDADE_FEDERACAO ESTADO,                                    
    CUF.COD_UNIDADE_FEDERACAO SIGLA,                                        
    REGEXP_REPLACE(REGEXP_REPLACE(FC.CPF_PESSOA, '[^0-9]', ''), '^(\d{3})(\d{6})(\d{2})$', '***.\2-**') CPF_MASCARADO,
    FC.COD_INSTITUCIONAL NUMERO_VINCULO,
    EXTRACT(YEAR FROM P.DATA_NASCIMENTO) ANO_NASCIMENTO,
    FRC.NOME_RACA_COR RACA_COR,
    FS.NOME_SEXO SEXO,
    CASE TRIM(CNJ.NOME_CAT_NATUREZA_JURIDICA)
        WHEN 'Órgão Público do Poder Executivo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Executivo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Legislativo Municipal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público do Poder Judiciário Estadual' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Estadual ou do Distrito Federal' THEN 'Administração Direta'
        WHEN 'Órgão Público Autônomo Municipal' THEN 'Administração Direta'
        WHEN 'Estado ou Distrito Federal' THEN 'Administração Direta'
        WHEN 'Município' THEN 'Administração Direta'
        WHEN 'União' THEN 'Administração Direta'
        WHEN 'Autarquia Federal' THEN 'Autarquia'
        WHEN 'Autarquia Estadual ou do Distrito Federal' THEN 'Autarquia'
        WHEN 'Autarquia Municipal' THEN 'Autarquia'
        WHEN 'Fundação Pública de Direito Público Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Público Municipal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Estadual ou do Distrito Federal' THEN 'Fundação'
        WHEN 'Fundação Pública de Direito Privado Municipal' THEN 'Fundação'
        WHEN 'Fundação Privada' THEN 'Fundação'
        ELSE NULL 
    END ESTRUTURA_ORG,
    E.NOME_FANTASIA ORGAO_ENTE,
    PTF.NOME_TIPO_FUNCIONARIO TIPO_VINCULO,
    CCF.NOME_CATEGORIA_FUNCIONAL NOME_CARGO,
    RFC.NOME_FUNCAO_COMISSIONADA NOME_CARGO_COMISSAO,
    '' CARGO_LIDERANCA,
    '' NIVEL_LIDERANCA
FROM 
    SW_VICEGOV.FOLHA_CONTRACHEQUE FC
    LEFT JOIN SW_VICEGOV.FUNCIONARIO_REFERENCIA FR ON FR.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FR.DATA_TERMINO IS NULL
    LEFT JOIN SW_VICEGOV.FUNCIONARIO_INGRESSO FI ON FI.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_VICEGOV.RHB_CARREIRA_CATEG_FUNCIONAL CCF ON CCF.ID_CATEGORIA_FUNCIONAL = NVL(FR.ID_CATEGORIA_FUNCIONAL, FI.ID_CATEGORIA_FUNCIONAL)
    LEFT JOIN SW_VICEGOV.FUNCIONARIO_FUNCAO FUNC ON FUNC.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FUNC.DATA_FIM IS NULL
    LEFT JOIN SW_VICEGOV.RHB_FC_FUNCAO_COMISSIONADA RFC ON RFC.ID_FUNCAO_COMISSIONADA = FUNC.ID_FUNCAO_COMISSIONADA
    LEFT JOIN SW_VICEGOV.FUNCIONARIO_PERFIL FP ON FP.ID_FUNCIONARIO = FC.ID_FUNCIONARIO AND FP.DATA_FIM IS NULL
    LEFT JOIN SW_PUBLICO.RHB_PERFIL_TIPO_FUNCIONARIO PTF ON PTF.ID_TIPO_FUNCIONARIO = FP.ID_TIPO_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.PESSOA P ON P.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.PESSOA_ENDERECO PEN ON PEN.ID_PESSOA = P.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CEP_UNIDADE_FEDERACAO CUF ON CUF.ID_UNIDADE_FEDERACAO = PEN.ID_UNIDADE_FEDERACAO
    LEFT JOIN SW_PUBLICO.PESSOA_CARACTERISTICA_FISICA PCF ON PCF.ID_PESSOA = FC.ID_PESSOA
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_RACA_COR FRC ON FRC.ID_RACA_COR = PCF.ID_RACA_COR
    LEFT JOIN SW_PUBLICO.RHB_CARACT_FISICA_SEXO FS ON FS.ID_SEXO = P.ID_SEXO
    LEFT JOIN SW_PUBLICO.PREV_PROP_ORGAO_ORIGEM POO ON POO.ID_FUNCIONARIO = FC.ID_FUNCIONARIO
    LEFT JOIN SW_PUBLICO.EMPRESA E ON E.ID_EMPRESA = POO.ID_EMPRESA
    LEFT JOIN SW_PUBLICO.CATEGORIA_NATUREZA_JURIDICA CNJ ON CNJ.ID_CATEGORIA_NATUREZA_JURIDICA = E.ID_NATUREZA_JURIDICA
WHERE 
    FC.MES = 4
    AND FC.ANO = 2026
    AND PTF.ID_TIPO_FUNCIONARIO = 1000000