############################################################################################
chrom=$1
############################################################################################
outDir=result
tmpDir=/dev/shm/tmp

if [ -z ${chrom} ]; then
    echo "chrom is empty."
    exit 1
fi

#gatk='/s3/opt/soft/gatk/gatk'
gatk='gatk'

${gatk} --java-options "-Djava.io.tmpdir=.${tmpDir}" SelectVariants \
    --reference             db/ref.fa \
    --intervals             ${chrom} \
    -select-type SNP \
    --variant               ${outDir}/pooled.HaplotypeCaller.${chrom}.all.vcf \
    --output                ${outDir}/pooled.HaplotypeCaller.${chrom}.all.snp.vcf \
    1>                      ${outDir}/pooled.HaplotypeCaller.${chrom}.all.snp.vcf.log \
    2>                      ${outDir}/pooled.HaplotypeCaller.${chrom}.all.snp.vcf.err
