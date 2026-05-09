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
    --filter-name "INDEL_QD" \
    --filter-expression "FS > 200.0" \
    --filter-name "INDEL_FS" \
    --filter-expression "SOR > 10.0" \
    --filter-name "INDEL_SOR" \
    --filter-expression "InbreedingCoeff < -0.8" \
    --filter-name "INDEL_InbreedingCoeff" \
    --filter-expression "ReadPosRankSum < -20.0" \
    --filter-name "INDEL_ReadPosRankSum" \
    --filter-expression "DP  < 1848" \
    --filter-name "INDEL_lowDP" \
    --filter-expression "DP  > 18480" \
    --filter-name "INDEL_hiDP" \
    --variant               result/pooled.HaplotypeCaller.${chrom}.all.indel.vcf \
    --output                result/pooled.HaplotypeCaller.${chrom}.all.indel.filtered.vcf \
    1>                      result/pooled.HaplotypeCaller.${chrom}.all.indel.filtered.vcf.log \
    2>                      result/pooled.HaplotypeCaller.${chrom}.all.indel.filtered.vcf.err

#--filter-expression "DP  < 645" \
#--filter-name "SNP_lowDP" \
#--filter-expression "DP  > 1290" \
#--filter-name "SNP_hiDP" \
