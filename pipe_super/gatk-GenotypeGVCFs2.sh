############################################################################################
chrom=$1
############################################################################################

if [ -z ${chrom} ]; then
    echo "chrom is empty."
    exit 1
fi

mkdir /dev/shm/tmp

gatk='/s3/opt/soft/gatk/gatk'
${gatk} --java-options "-Xmx128g -Xms128g -Djava.io.tmpdir=/dev/shm/tmp" GenotypeGVCFs \
    --reference             db/ref.fa \
    --intervals             ${chrom} \
    -stand-call-conf        30 \
    --max-alternate-alleles 30 \
    --variant               result2/pooled.HaplotypeCaller.${chrom}.g.vcf \
    --output                result2/pooled.HaplotypeCaller.${chrom}.all.vcf \
    1>                      result2/pooled.HaplotypeCaller.${chrom}.all.vcf.log \
    2>                      result2/pooled.HaplotypeCaller.${chrom}.all.vcf.err
