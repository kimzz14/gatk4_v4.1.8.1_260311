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

${gatk} --java-options "-Djava.io.tmpdir=${tmpDir}" VariantsToTable \
    --reference             db/ref.fa \
    --intervals             ${chrom} \
    --error-if-missing-data false \
    -F CHROM \
    -F POS \
    -F ID \
    -F REF \
    -F ALT \
    -F QUAL \
    -F FILTER \
    -F AC \
    -F AF \
    -F AN \
    -F DP \
    -GF GT \
    -GF AD \
    -GF DP \
    --variant               ${outDir}/${readID}.vcf \
    --output                ${outDir}/${readID}.tab \
    1>                      ${outDir}/${readID}.tab.log \
    2>                      ${outDir}/${readID}.tab.err
