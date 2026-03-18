chrom=$1

#SNP
bash pipe/gatk-SplitVCF_SNP.sh ${chrom}
bash pipe/gatk-VariantFiltration-SNP.sh ${chrom}
bash pipe/gatk-SelectVariants-SNP.sh ${chrom}
bash pipe/gatk-VariantsToTable.sh pooled.HaplotypeCaller.${chrom}.all.snp.filtered.pass
