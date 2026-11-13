"""Verify the judges' grounding quotes and score the two arms."""
import pathlib, re, sys, collections
E = pathlib.Path(__file__).parent
norm = lambda s: re.sub(r"\s+", " ", re.sub(r"[*_`#>|]", "", s)).strip().lower()
mapping = {l.split("\t")[0]: l.split("\t")[1:] for l in (E/"mapping.tsv").read_text().splitlines()}
tx = {w: norm((E/"transcripts"/f"{w}.md").read_text()) for w in mapping}
scores = collections.defaultdict(dict); void = []
for f in sorted((E/"judge-lines").glob("*.tsv")):
    judge = f.stem.split("-")[0]
    for line in f.read_text().splitlines():
        p = line.split("\t")
        if len(p) < 4 or p[0] not in mapping: continue
        w, first, last, d = p[0], norm(p[1]), norm(p[2]), p[3].strip()
        ok = tx[w].startswith(first[:25]) and tx[w].endswith(last[-25:]) and re.fullmatch(r"[01]{6}", d)
        if not ok: void.append((f.name, w)); continue
        scores[w][judge] = (d, p[4] if len(p) > 4 else "")
print("voided lines:", void)
missing = [(w, j) for w in mapping for j in ("opus", "sonnet") if j not in scores[w]]
print("missing:", missing)
agree = sum(a == b for w in mapping if len(scores[w]) == 2 for a, b in zip(scores[w]["opus"][0], scores[w]["sonnet"][0]))
print(f"agreement: {agree}/{6*sum(len(scores[w])==2 for w in mapping)}")
tot = collections.defaultdict(lambda: [0]*6); byinp = collections.defaultdict(lambda: collections.defaultdict(int))
for w, (arm, inp, s) in mapping.items():
    for j, (d, note) in scores[w].items():
        for i, c in enumerate(d): tot[arm][i] += int(c)
        byinp[inp][arm] += d.count("1")
for arm in ("O", "R"): print(arm, "total", sum(tot[arm]), "Q1..Q6", tot[arm])
for inp in sorted(byinp): print(inp, dict(byinp[inp]), "of 24 each")
if "-v" in sys.argv:
    for w, (arm, inp, s) in sorted(mapping.items(), key=lambda x: (x[1][1], x[1][0])):
        for j, (d, note) in sorted(scores[w].items()):
            if "0" in d: print(inp, arm, w, j, d, note)
