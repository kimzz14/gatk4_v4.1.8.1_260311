#2026.05.08 KJH
from optparse import OptionParser
import sys
import gzip
import os

# --------------------------------------------------
# Set up command-line options
# --------------------------------------------------
parser = OptionParser(usage="""Run annotation.py \n Usage: %prog [options]""")
parser.add_option("-c","--chrom",action = 'store',type = 'string',dest = 'CHROM',help = "")
(opt, args) = parser.parse_args()
if opt.CHROM == None:
    print('Basic usage')
    print('')
    print('     python vcf_merger.py -c Chr3A')
    print('')
    print('Common options')
    print('')
    print('     -c      chrom Name')
    sys.exit()

input_chrom = opt.CHROM

inputDir = 'result20'
outputDir = 'result'

# --------------------------------------------------
# Read chromosome size information from FASTA index
# --------------------------------------------------
fai_file = 'db/ref.fa.fai'
chromSize_DICT = {}

fin = open(fai_file, 'r')
for line in fin:
    data_LIST = line.rstrip('\n').split('\t')
    chrom, chromSize = data_LIST[0], data_LIST[1]
    chromSize_DICT[chrom] = int(chromSize)
fin.close()

# Check whether the requested chromosome exists in the index
if input_chrom not in chromSize_DICT:
    print(f"Error: chromosome '{input_chrom}' was not found in {fai_file}")
    sys.exit(1)

chromSize = chromSize_DICT[input_chrom]

# Size of each genomic chunk
unit = 1000*1000*10

# --------------------------------------------------
# Check which chunk files exist
# --------------------------------------------------
existing_files = []
missing_files = []

#check file
for sPos in range(1, chromSize + 1, unit):
    ePos = min(sPos + unit - 1, chromSize)

    fileName = f'{inputDir}/pooled.HaplotypeCaller.{input_chrom}.{sPos}-{ePos}.all.vcf.gz'

    if os.path.exists(fileName):
        #print(fileName, 'on')
        existing_files.append(fileName)
    else:
        print(fileName, 'off')
        missing_files.append(fileName)
# Stop if no input files are available
if len(missing_files) != 0:
    print(f"Error: no VCF chunk files were found for chromosome {input_chrom}")
    sys.exit(1)

# --------------------------------------------------
# Merge all chunk VCF files into one VCF
# --------------------------------------------------

#
fout = open(f'{outputDir}/pooled.HaplotypeCaller.{input_chrom}.all.vcf', 'w')

# Write header from the first existing VCF file only
fin = gzip.open(existing_files[0], 'rt')
for line in fin:
    fout.write(line)
    if line.startswith('#CHROM') == True:
        legend_LIST = line[1:].rstrip('\n').split('\t')
        break
fin.close()

# --------------------------------------------------
# Append variant records from all existing VCF files
# Skip header lines in each input file
# --------------------------------------------------

#check file
for sPos in range(1, chromSize + 1, unit):
    ePos = min(sPos + unit - 1, chromSize)

    fileName = f'{inputDir}/pooled.HaplotypeCaller.{input_chrom}.{sPos}-{ePos}.all.vcf.gz'

    fin = gzip.open(fileName, 'rt')
    for line in fin:
        if line.startswith('#CHROM') == True:
            break

    for line in fin:
        data_LIST = line.rstrip('\n').split('\t')
        pos = int(data_LIST[1])

        if sPos > pos or pos > ePos: continue
        if len(data_LIST) != len(legend_LIST): continue

        fout.write(line)

fout.close()