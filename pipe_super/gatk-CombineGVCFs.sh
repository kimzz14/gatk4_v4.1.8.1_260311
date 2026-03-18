############################################################################################
chrom=$1
############################################################################################

baseDir=/s1/home/rda/kimzz12/SRA_MAPPING/Triticum_aestivum/Keumkang_v1.1/00.mappingTools_v01_250114/03.done

if [ -z ${chrom} ]; then
    echo "chrom is empty."
    exit 1
fi

mkdir /dev/shm/tmp

gatk='/s3/opt/soft/gatk/gatk'
${gatk} --java-options "-Xmx128g -Xms128g -Djava.io.tmpdir=/dev/shm/tmp" CombineGVCFs \
  --reference             db/ref.fa \
  --intervals             ${chrom} \
  --variant               ${baseDir}/P000000_KW/A00000/pooled_gvcf/pooled.HaplotypeCaller.${chrom}.g.vcf \
  --variant               ${baseDir}/P000000_KW/A00010/pooled_gvcf/pooled.HaplotypeCaller.${chrom}.g.vcf \
  --variant               ${baseDir}/P002000_C566/A00000/pooled_gvcf/pooled.HaplotypeCaller.${chrom}.g.vcf \
  --variant               ${baseDir}/P002000_C566/A00010/pooled_gvcf/pooled.HaplotypeCaller.${chrom}.g.vcf \
  --variant               ${baseDir}/P002000_C566/A00020/pooled_gvcf/pooled.HaplotypeCaller.${chrom}.g.vcf \
  --variant               ${baseDir}/P002000_C566/A00030/pooled_gvcf/pooled.HaplotypeCaller.${chrom}.g.vcf \
  --variant               ${baseDir}/P002000_C566/A00040/pooled_gvcf/pooled.HaplotypeCaller.${chrom}.g.vcf \
  --variant               ${baseDir}/P002000_C566/A00050/pooled_gvcf/pooled.HaplotypeCaller.${chrom}.g.vcf \
  --variant               ${baseDir}/P002000_C566/A00060/pooled_gvcf/pooled.HaplotypeCaller.${chrom}.g.vcf \
  --variant               ${baseDir}/P002000_C566/A00070/pooled_gvcf/pooled.HaplotypeCaller.${chrom}.g.vcf \
  --variant               ${baseDir}/P002000_C566/A00080/pooled_gvcf/pooled.HaplotypeCaller.${chrom}.g.vcf \
  --variant               ${baseDir}/P002000_C566/A00090/pooled_gvcf/pooled.HaplotypeCaller.${chrom}.g.vcf \
  --output                result/pooled.HaplotypeCaller.${chrom}.g.vcf \
  1>                      result/pooled.HaplotypeCaller.${chrom}.g.vcf.log \
  2>                      result/pooled.HaplotypeCaller.${chrom}.g.vcf.err
