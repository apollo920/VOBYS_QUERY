'INSERT INTO SW_SEDUC.FOLHA_FUNC_RUBRICA_IMPORTADA (ID_RUBRICA_IMPORTADA, ID_FOLHA_FUNCIONARIO,  ID_RUBRICA,  IND_TIPO, ID_FOLHA_VALORES, PRAZO_PARCELA, PRAZO_TOTAL, IND_PARAMETRO, IND_ORIGEM, VALOR_MULTIPLICADOR, IND_FORMA_ATUALIZACAO, DATA_CADASTRO, DATA_INICIO, DATA_FIM, ANO_REFERENCIA, MES_REFERENCIA, IND_SUBSTITUICAO, OBSERVACAO) VALUES (SW_SEDUC.SQ_PK_RUBRICA_IMPORTADA.NEXTVAL, ' || FF.ID_FOLHA_FUNCIONARIO || ', ' || R.ID_RUBRICA || ', ''' || R.TIPO || ''', ' || FO.ID_FOLHA || ', ''001'', ''001'', ''V'', ''D'', ' || <VALOR> || ', ''D'', ''' || SYSDATE || ''', ''01/04/2026'', ''30/04/2026'', 2026, 4, ''S'', ''<OBSERVACAO>'');'


INSERT INTO SW_FUESPI.FOLHA_FUNC_RUBRICA_IMPORTADA (
ID_RUBRICA_IMPORTADA,                                 -- CHAVE_PRIMARIA
ID_FOLHA_FUNCIONARIO,                                 -- ID DA FOLHA_FUNC
ID_RUBRICA,                                           -- ID DA RUBRICA
IND_TIPO,                                             -- TIPO DA RUBRICA, CAMPO TIPO DA TABELA FOLHA_RUBRICA
ID_FOLHA_VALORES,                                     -- ID DA FOLHA
PRAZO_PARCELA,                                        -- PARCELA ATUAL, 3 CARACTERES
PRAZO_TOTAL,                                          -- TOTAL DE PARCELAS, 3 CARACTERES
IND_PARAMETRO,                                        -- (C)Calcular (V)Valor Informado
IND_ORIGEM,                                           -- (B)Beneficio (C)Consigna��o (I)Individual (D)Digitada (F)Diferen�a  (P)Pens�o Aliment�cia (L)Saldo (S)Outros Sistemas (M)IPSEMG (E)IPSEMG Dependente (A)IPSEMG Atraso
VALOR_MULTIPLICADOR,                                  -- VALOR DA RUBRICA
IND_FORMA_ATUALIZACAO,                                -- (D)Digitado (G)Gerado pelo sistema (A)Alterado
DATA_CADASTRO,
DATA_INICIO,                                          -- SEMPRE DIA 1 DO MES
DATA_FIM,                                             -- ULTIMO DIA DO MES DEPENDENDO DA QUANTIDADE DE PARCELAR, SE PRAZO_TOTAL FOR 'PER' NAO PRECISA DESSE CAMPO
ANO_REFERENCIA,                                       -- ANO DA FOLHA
MES_REFERENCIA,                                       -- MES DA FOLHA
IND_SUBSTITUICAO                                      -- 'S'
) VALUES (
SW_FUESPI.SQ_PK_RUBRICA_IMPORTADA.NEXTVAL,
ID_FOLHA_FUNC,
1553846,
'R',
ID_FOLHA,
'001',
'001',
'V',
'I',
VALOR,
'D',
'29/02/2024',
'01/03/2024',
'31/03/2024',
2024,
3,
'S');