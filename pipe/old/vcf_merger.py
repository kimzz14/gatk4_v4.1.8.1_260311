
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
    print('     python vcf_merger.py -c Chr3A -s size')
    print('')
    print('Common options')
    print('')
    print('     -c      chrom Name')
    sys.exit()

input_chrom = opt.CHROM

# --------------------------------------------------
# Read chromosome size information from FASTA index
# --------------------------------------------------
fai_file = 'db/ref.fa.fai'
chromSize_DICT = {}

with open(fai_file, 'r') as fin:
    for line in fin:
        fields = line.rstrip('\n').split('\t')
        chrom, chromSize = fields[0], fields[1]
        chromSize_DICT[chrom] = int(chromSize)

# Check whether the requested chromosome exists in the index
if input_chrom not in chromSize_DICT:
    print(f"Error: chromosome '{input_chrom}' was not found in {fai_file}")
    sys.exit(1)

chromSize = chromSize_DICT[input_chrom]

# Size of each genomic chunk
unit = 10000000

# --------------------------------------------------
# Check which chunk files exist
# --------------------------------------------------
existing_files = []
missing_files = []

#check file

for unit_idx in range(int(chromSize / unit) + 1):
    sPos = 1 + unit_idx * unit
    ePos = (unit_idx + 1) * unit
    if ePos > chromSize:
        ePos = chromSize

    fileName = f'pooled.HaplotypeCaller.{input_chrom}.{sPos}-{ePos}.all.vcf.gz'

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
fout = open(f'pooled.HaplotypeCaller.{input_chrom}.all.vcf', 'w')

# Write header from the first existing VCF file only
fin = gzip.open(existing_files[0], 'rt')
for line in fin:
    fout.write(line)
    if line.startswith('#CHROM') == True:
        break
fin.close()

# --------------------------------------------------
    # Append variant records from all existing VCF files
    # Skip header lines in each input file
    # --------------------------------------------------

for fileName  in existing_files:
    print(fileName)

    fin = gzip.open(fileName, 'rt')
    # Skip all header lines
    for line in fin:
        if line.startswith('#CHROM') == True:
            break
    
    # Write only variant records
    for line in fin:
        fout.write(line)
    
    fin.close()

fout.close()