SELECT
    'FUNPREV' AS orgao,
    fo.chave_folha,
    ff.cod_institucional,
    r.nome_rubrica,
    ri.id_rubrica_importada,
    ri.valor_multiplicador,
    ce.id_especialidade,
    ce.nome_especialidade,
    CASE
        WHEN ce.id_especialidade IN (209, 547) THEN 'UPDATE SW_FUNPREV.FOLHA_FUNC_RUBRICA_IMPORTADA SET VALOR_MULTIPLICADOR = 8400 WHERE ID_RUBRICA_IMPORTADA = ' || ri.id_rubrica_importada || ';' -- AUD.FISCAL DA FAZ. ESTADUAL
        WHEN ce.id_especialidade = 548 THEN 'UPDATE SW_FUNPREV.FOLHA_FUNC_RUBRICA_IMPORTADA SET VALOR_MULTIPLICADOR = 2880 WHERE ID_RUBRICA_IMPORTADA = ' || ri.id_rubrica_importada || ';' -- AUD.FISCAL.AUX.FAZ.ESTADUAL
        WHEN ce.id_especialidade = 549 THEN 'UPDATE SW_FUNPREV.FOLHA_FUNC_RUBRICA_IMPORTADA SET VALOR_MULTIPLICADOR = 1620 WHERE ID_RUBRICA_IMPORTADA = ' || ri.id_rubrica_importada || ';' -- AGENTE DE TRIBUTOS DA FAZENDA ESTADUAL
        WHEN ce.id_especialidade = 550 THEN 'UPDATE SW_FUNPREV.FOLHA_FUNC_RUBRICA_IMPORTADA SET VALOR_MULTIPLICADOR = 800 WHERE ID_RUBRICA_IMPORTADA = ' || ri.id_rubrica_importada || ';' -- ANALISTA DO TESOURO ESTADUAL
        WHEN ce.id_especialidade = 551 THEN 'UPDATE SW_FUNPREV.FOLHA_FUNC_RUBRICA_IMPORTADA SET VALOR_MULTIPLICADOR = 720 WHERE ID_RUBRICA_IMPORTADA = ' || ri.id_rubrica_importada || ';' -- ANAL.AUX. DO TESOURO ESTADUAL
    END AS update_
FROM
         sw_FUNPREV.folha_func_rubrica_importada ri
    JOIN sw_FUNPREV.folha_func ff ON ff.id_folha_funcionario = ri.id_folha_funcionario
    JOIN sw_FUNPREV.folha fo ON fo.id_folha = ff.id_folha
    JOIN sw_FUNPREV.funcionario_ingresso fi ON fi.id_funcionario = ff.id_funcionario
    JOIN sw_FUNPREV.rhb_carreira_categ_especialid ce ON ce.id_especialidade = fi.id_especialidade
    JOIN sw_publico.folha_rubrica r ON r.id_rubrica = ri.id_rubrica
WHERE
        fo.mes = 7
    AND fo.ano = 2026
    AND r.cod_rubrica IN ( 132908, 112906, 112907, 122906, 132906, 142905, 152905 )
    AND ff.id_pensionista IS NULL
    AND NOT EXISTS (
        SELECT
            1
        FROM
            SW_SEFAZPI.PESSOA_VINCULO PV
            JOIN SW_SEFAZPI.FUNCIONARIO F ON F.ID_PESSOA_VINCULO = PV.ID_PESSOA_VINCULO
        WHERE
            PV.COD_INSTITUCIONAL = FF.COD_INSTITUCIONAL
    )
ORDER BY ce.nome_especialidade