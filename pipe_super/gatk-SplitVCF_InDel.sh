############################################################################################
chrom=$1
############################################################################################

if [ -z ${chrom} ]; then
    echo "chrom is empty."
    exit 1
fi

gatk='/s3/opt/soft/gatk/gatk'
${gatk} --java-options "-Djava.io.tmpdir=./tmp" SelectVariants \
    --reference             db/ref.fa \
    --intervals             ${chrom} \
    -select-type INDEL \
    --variant               result/pooled.HaplotypeCaller.${chrom}.all.vcf \
    --output                result/pooled.HaplotypeCaller.${chrom}.all.indel.vcf \
    1>                      result/pooled.HaplotypeCaller.${chrom}.all.indel.vcf.log \
    2>                      result/pooled.HaplotypeCaller.${chrom}.all.indel.vcf.err
