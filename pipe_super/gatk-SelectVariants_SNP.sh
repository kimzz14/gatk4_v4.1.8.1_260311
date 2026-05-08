############################################################################################
chrom=$1
############################################################################################

if [ -z ${chrom} ]; then
    echo "chrom is empty."
    exit 1
fi

mkdir -p /dev/shm/tmp

gatk='/s3/opt/soft/gatk/gatk'
${gatk} --java-options "-Xmx128g -Xms128g -Djava.io.tmpdir=/dev/shm/tmp" SelectVariants \
    --reference             db/ref.fa \
    --intervals             ${chrom} \
    --exclude-filtered \
    --exclude-non-variants \
    --variant               result/pooled.HaplotypeCaller.${chrom}.all.snp.filtered.vcf \
    --output                result/pooled.HaplotypeCaller.${chrom}.all.snp.filtered.pass.vcf \
    1>                      result/pooled.HaplotypeCaller.${chrom}.all.snp.filtered.pass.vcf.log \
    2>                      result/pooled.HaplotypeCaller.${chrom}.all.snp.filtered.pass.vcf.err
