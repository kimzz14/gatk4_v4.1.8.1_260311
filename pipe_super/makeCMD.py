unit = 1000*1000*10

fin = open('db/ref.fa.fai')
for line in fin:
    chrom, chromSize = line.rstrip('\n').split('\t')[0:2]
    chromSize = int(chromSize)

    for sPos in range(1, chromSize + 1, unit):
        ePos = min(sPos + unit - 1, chromSize)
        print(f'bash pipe/run_VC20.sh {chrom} {sPos} {ePos}')
fin.close()