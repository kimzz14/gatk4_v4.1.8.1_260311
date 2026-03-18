chrom=$1

bash pipe/gatk-CombineGVCFs2.sh  ${chrom}
bash pipe/gatk-GenotypeGVCFs2.sh ${chrom}

#bash pipe/run_VC-SNP.sh         ${chrom} &
#bash pipe/run_VC-InDel.sh       ${chrom} &
#bash pipe/run_VC-All.sh         ${chrom} &
#wait
