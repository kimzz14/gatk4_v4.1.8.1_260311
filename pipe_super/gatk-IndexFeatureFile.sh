############################################################################################
chrom=$1
############################################################################################
outDir=result

if [ -z ${chrom} ]; then
    echo "chrom is empty."
    exit 1
fi

mkdir -p /dev/shm/tmp

gatk='/s3/opt/soft/gatk/gatk'
${gatk} --java-options "-Xmx128g -Xms128g -Djava.io.tmpdir=/dev/shm/tmp" \
        IndexFeatureFile \
        --input                 ${outDir}/pooled.HaplotypeCaller.${chrom}.all.vcf \
        1>                      ${outDir}/pooled.HaplotypeCaller.${chrom}.all.vcf.idx.log \
        2>                      ${outDir}/pooled.HaplotypeCaller.${chrom}.all.vcf.idx.err
