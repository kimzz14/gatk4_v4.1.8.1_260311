chrom=$1

#Merge VCF
singularity exec -e /s3/simg/bio python3 pipe/vcf_merger.py -c ${chrom}
bash pipe/bgzip.sh 16 pooled.HaplotypeCaller.${chrom}.all.vcf &
bash pipe/gatk-IndexFeatureFile.sh ${chrom}

#Split VCF
bash pipe/gatk-SplitVCF_SNP.sh ${chrom} &
bash pipe/gatk-SplitVCF_InDel.sh ${chrom} &
wait
bash pipe/bgzip.sh 8 pooled.HaplotypeCaller.${chrom}.all.snp.vcf &
bash pipe/bgzip.sh 8 pooled.HaplotypeCaller.${chrom}.all.indel.vcf &

#VariantFilteration
bash pipe/gatk-VariantFiltration_SNP.sh ${chrom} &
bash pipe/gatk-VariantFiltration_InDel.sh ${chrom} &
wait
bash pipe/bgzip.sh 4 pooled.HaplotypeCaller.${chrom}.all.snp.filtered.vcf &
bash pipe/bgzip.sh 4 pooled.HaplotypeCaller.${chrom}.all.indel.filtered.vcf &

#VariantFilteration
bash pipe/gatk-SelectVariants_SNP.sh ${chrom} &
bash pipe/gatk-SelectVariants_InDel.sh ${chrom} &
wait
bash pipe/bgzip.sh 4 pooled.HaplotypeCaller.${chrom}.all.snp.filtered.pass.vcf &
bash pipe/bgzip.sh 4 pooled.HaplotypeCaller.${chrom}.all.indel.filtered.pass.vcf &

wait
