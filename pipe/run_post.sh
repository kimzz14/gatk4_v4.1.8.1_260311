chrom=$1

#Merge VCF
python pipe/vcf_merger.py -c ${chrom}
bash pipe/gatk-IndexFeatureFile.sh ${chrom}

#Split VCF
bash pipe/gatk-SplitVCF_SNP.sh ${chrom} &
bash pipe/gatk-SplitVCF_INDEL.sh ${chrom} &
wait
pigz -p 16 result/pooled.HaplotypeCaller.${chrom}.all.vcf &

#VariantFilteration
bash pipe/gatk-VariantFiltration-SNP.sh ${chrom} &
bash pipe/gatk-VariantFiltration-INDEL.sh ${chrom} &
wait
pigz -p 8 result/pooled.HaplotypeCaller.${chrom}.all.snp.vcf &
pigz -p 8 result/pooled.HaplotypeCaller.${chrom}.all.indel.vcf &

#VariantFilteration
bash pipe/gatk-SelectVariants-SNP.sh ${chrom} &
bash pipe/gatk-SelectVariants-INDEL.sh ${chrom} &
wait
pigz -p 4 result/pooled.HaplotypeCaller.${chrom}.all.snp.filtered.vcf &
pigz -p 4 result/pooled.HaplotypeCaller.${chrom}.all.indel.filtered.vcf &
pigz -p 4 result/pooled.HaplotypeCaller.${chrom}.all.snp.filtered.pass.vcf &
pigz -p 4 result/pooled.HaplotypeCaller.${chrom}.all.indel.filtered.pass.vcf &
wait
