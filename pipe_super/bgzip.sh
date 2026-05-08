threadN=$1
vcfFile=$2

bgzip \
    result/${vcfFile} \
    --threads ${threadN} \
    --keep \
    --output result.bgzip/${vcfFile}.gz

tabix --csi --preset vcf result.bgzip/${vcfFile}.gz
