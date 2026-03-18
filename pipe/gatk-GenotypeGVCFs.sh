############################################################################################
chrom=$1
############################################################################################
outDir=result
tmpDir=/dev/shm/tmp

if [ -z ${chrom} ]; then
    echo "chrom is empty."
    exit 1
fi

mkdir /dev/shm/tmp

#gatk='/s3/opt/soft/gatk/gatk'
gatk='gatk'

${gatk} --java-options "-Xmx128g -Xms128g -Djava.io.tmpdir=${tmpDir}" GenotypeGVCFs \
    --reference             db/ref.fa \
    --intervals             ${chrom} \
    -stand-call-conf        30 \
    --max-alternate-alleles 30 \
    --variant               ${outDir}/pooled.HaplotypeCaller.${chrom}.g.vcf \
    --output                ${outDir}/pooled.HaplotypeCaller.${chrom}.all.vcf \
    1>                      ${outDir}/pooled.HaplotypeCaller.${chrom}.all.vcf.log \
    2>                      ${outDir}/pooled.HaplotypeCaller.${chrom}.all.vcf.err
