chrom=$1

#InDel
bash pipe/gatk-SplitVCF_InDel.sh ${chrom}
bash pipe/gatk-VariantFiltration-InDel.sh ${chrom}
bash pipe/gatk-SelectVariants-InDel.sh ${chrom}
bash pipe/gatk-VariantsToTable.sh pooled.HaplotypeCaller.${chrom}.all.indel.filtered
