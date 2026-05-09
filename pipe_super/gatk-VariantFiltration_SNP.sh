############################################################################################
chrom=$1
############################################################################################

if [ -z ${chrom} ]; then
    echo "chrom is empty."
    exit 1
fi

mkdir -p /dev/shm/tmp

gatk='/s3/opt/soft/gatk/gatk'
${gatk} --java-options "-Xmx128g -Xms128g -Djava.io.tmpdir=/dev/shm/tmp" VariantFiltration \
    --reference             db/ref.fa \
    --intervals             ${chrom} \
    --filter-expression "QD < 2.0" \
    --filter-name "SNP_QD" \
    --filter-expression "FS > 60.0" \
    --filter-name "SNP_FS" \
    --filter-expression "SOR > 4.0" \
    --filter-name "SNP_SOR" \
    --filter-expression "MQ < 40.0" \
    --filter-name "SNP_MQ" \
    --filter-expression "MQRankSum < -12.5" \
    --filter-name "SNP_MQRankSum" \
    --filter-expression "ReadPosRankSum  < -8.0" \
    --filter-name "SNP_ReadPosRankSum" \
    --filter-expression "DP  < 1848" \
    --filter-name "SNP_lowDP" \
    --filter-expression "DP  > 18480" \
    --filter-name "SNP_hiDP" \
    --variant               result/pooled.HaplotypeCaller.${chrom}.all.snp.vcf \
    --output                result/pooled.HaplotypeCaller.${chrom}.all.snp.filtered.vcf \
    1>                      result/pooled.HaplotypeCaller.${chrom}.all.snp.filtered.vcf.log \
    2>                      result/pooled.HaplotypeCaller.${chrom}.all.snp.filtered.vcf.err

#--filter-expression "DP  < 645" \
#--filter-name "SNP_lowDP" \
#--filter-expression "DP  > 1290" \
#--filter-name "SNP_hiDP" \
