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

${gatk} --java-options "-Xmx128g -Xms128g -Djava.io.tmpdir=${tmpDir}" \
        IndexFeatureFile \
        --input                 ${outDir}/pooled.HaplotypeCaller.${chrom}.all.vcf \
        1>                      ${outDir}/pooled.HaplotypeCaller.${chrom}.all.vcf.idx.log \
        2>                      ${outDir}/pooled.HaplotypeCaller.${chrom}.all.vcf.idx.err
