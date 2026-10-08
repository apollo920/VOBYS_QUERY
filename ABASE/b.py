import csv
from pathlib import Path

PASTA = Path(__file__).parent
ENTRADA = PASTA / "consignacoes_separado.csv"
SAIDA = PASTA / "consignacoes_658.csv"
FILTRO = "658"

with open(ENTRADA, encoding="utf-8", newline="") as fin, \
     open(SAIDA, "w", encoding="utf-8", newline="") as fout:
    reader = csv.DictReader(fin, delimiter=";")
    writer = csv.DictWriter(fout, fieldnames=reader.fieldnames, delimiter=";")
    writer.writeheader()

    total = mantidas = 0
    for row in reader:
        total += 1
        if row["FINANCEIRO_1"] == FILTRO:
            writer.writerow(row)
            mantidas += 1

print(f"{mantidas} de {total} linhas com FINANCEIRO_1 = {FILTRO} -> {SAIDA}")