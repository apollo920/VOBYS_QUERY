import csv
from decimal import Decimal
from pathlib import Path

PASTA = Path(__file__).parent
ENTRADA = PASTA / "consignacoes_658.csv"
SAIDA = PASTA / "query.sql"

def formata_matricula(mat):
    # 7 dígitos -> 6 + hífen + dígito verificador (ex.: 0003387 -> 000338-7)
    return f"{mat[:-1]}-{mat[-1]}"

selects = []
with open(ENTRADA, encoding="utf-8", newline="") as f:
    for row in csv.DictReader(f, delimiter=";"):
        matricula = formata_matricula(row["MATRICULA"])
        valor = Decimal(row["VALOR"]) / 100  # 000050000 -> 500.00
        selects.append(
            f"SELECT '{matricula}' MATRICULA, {valor:.2f} VALOR FROM DUAL"
        )

query = " UNION ALL\n".join(selects)
with open(SAIDA, "w", encoding="utf-8") as f:
    f.write(query + "\n")

print(f"{len(selects)} registros -> {SAIDA}")