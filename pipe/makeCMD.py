unit = 1000*1000*10

fin = open('db/ref.fa.fai')
for line in fin:
    chrom, chromSize = line.rstrip('\n').split('\t')[0:2]
    chromSize = int(chromSize)

    for unit_idx in range(int(chromSize / unit) + 1):
        sPos = 1 + unit_idx * unit
        ePos = (unit_idx + 1) * unit
        if ePos > chromSize:
            ePos = chromSize
        print(f'bash pipe/run_VC20.sh {chrom} {sPos} {ePos}')
fin.close()