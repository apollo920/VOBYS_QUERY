import csv
from pathlib import Path

PASTA = Path(__file__).parent
ENTRADA = PASTA / "consignacoes.txt"
SAIDA = PASTA / "consignacoes_separado.csv"
ENCODING = "latin-1"

# (nome, posição inicial, posição final) - base 1, inclusivo, igual à tabela do layout
LAYOUT = [
    ("MATRICULA", 1, 7),
    ("PRIORIDADE", 8, 8),
    ("FINANCEIRO_1", 9, 11),
    ("ORGAO", 12, 14),
    ("TOTAL_PARCELAS", 15, 17),
    ("PARCELA_ATUAL", 18, 20),
    ("SISTEMA", 21, 21),
    ("VALOR", 22, 30),
    ("REFERENCIA", 31, 36),
    ("FINANCEIRO_2", 37, 37),
    ("RESERVADO", 38, 46),
    ("ORGAO_ANTERIOR", 47, 49),
    ("FINANCEIRO_ANTERIOR", 50, 52),
    ("DATA_PROCESSAMENTO", 53, 60),
    ("STATUS", 61, 61),
]
TAMANHO = 61

with open(ENTRADA, encoding=ENCODING) as fin, \
     open(SAIDA, "w", encoding="utf-8", newline="") as fout:
    writer = csv.writer(fout, delimiter=";")
    writer.writerow([nome for nome, _, _ in LAYOUT])

    total = 0
    for linha in fin:
        linha = linha.rstrip("\r\n")
        if not linha.strip():
            continue
        linha = linha.ljust(TAMANHO)  # garante o tamanho caso o espaço final tenha sido cortado
        writer.writerow([linha[ini - 1:fim].strip() for _, ini, fim in LAYOUT])
        total += 1

print(f"{total} linhas separadas -> {SAIDA}")