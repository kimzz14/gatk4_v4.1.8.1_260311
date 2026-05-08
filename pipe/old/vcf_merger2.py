
from optparse import OptionParser
import sys
import gzip
import os

# --------------------------------------------------
# Set up command-line options
# --------------------------------------------------
parser = OptionParser(usage="""Run annotation.py \n Usage: %prog [options]""")
parser.add_option("-c","--chrom",action = 'store',type = 'string',dest = 'CHROM',help = "")
parser.add_option("-s","--size",action = 'store',type = 'int',dest = 'SIZE',help = "")
(opt, args) = parser.parse_args()
if opt.CHROM == None or opt.SIZE == None:
    print('Basic usage')
    print('')
    print('     python vcf_merger.py -c Chr3A -s size')
    print('')
    print('Common options')
    print('')
    print('     -c      chrom Name')
    sys.exit()

input_chrom = opt.CHROM
chromSize = opt.SIZE

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

    try:
        fin = gzip.open(fileName, 'rt')
        # Skip all header lines
        for line in fin:
            if line.startswith('#CHROM') == True:
                break
        
        # Write only variant records
        for line in fin:
            if len(line.rstrip('\n').split('\t')) != 336: 
                print(fileName)
                continue

            fout.write(line)
        
        fin.close()
    except Exception:
        print(fileName)
        continue

fout.close()