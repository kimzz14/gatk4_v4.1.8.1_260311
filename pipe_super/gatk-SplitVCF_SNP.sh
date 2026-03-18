############################################################################################
chrom=$1
############################################################################################

if [ -z ${chrom} ]; then
    echo "chrom is empty."
    exit 1
fi

#gatk='/s3/opt/soft/gatk/gatk'
gatk='gatk'
${gatk} --java-options "-Djava.io.tmpdir=./tmp" SelectVariants \
    --reference             db/ref.fa \
    --intervals             ${chrom} \
    -select-type SNP \
    --variant               result/pooled.HaplotypeCaller.${chrom}.all.vcf \
    --output                result/pooled.HaplotypeCaller.${chrom}.all.snp.vcf \
    1>                      result/pooled.HaplotypeCaller.${chrom}.all.snp.vcf.log \
    2>                      result/pooled.HaplotypeCaller.${chrom}.all.snp.vcf.err
