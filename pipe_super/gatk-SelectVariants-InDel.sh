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
    --exclude-filtered \
    --exclude-non-variants \
    --variant               result/pooled.HaplotypeCaller.${chrom}.all.indel.filtered.vcf \
    --output                result/pooled.HaplotypeCaller.${chrom}.all.indel.filtered.pass.vcf \
    1>                      result/pooled.HaplotypeCaller.${chrom}.all.indel.filtered.pass.vcf.log \
    2>                      result/pooled.HaplotypeCaller.${chrom}.all.indel.filtered.pass.vcf.err
