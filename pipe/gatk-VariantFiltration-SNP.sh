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

${gatk} --java-options "-Djava.io.tmpdir=${tmpDir}" SelectVariants \
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
    --variant               ${outDir}/pooled.HaplotypeCaller.${chrom}.all.snp.vcf \
    --output                ${outDir}/pooled.HaplotypeCaller.${chrom}.all.snp.filtered.vcf \
    1>                      ${outDir}/pooled.HaplotypeCaller.${chrom}.all.snp.filtered.vcf.log \
    2>                      ${outDir}/pooled.HaplotypeCaller.${chrom}.all.snp.filtered.vcf.err

#--filter-expression "DP  < 645" \
#--filter-name "SNP_lowDP" \
#--filter-expression "DP  > 1290" \
#--filter-name "SNP_hiDP" \
