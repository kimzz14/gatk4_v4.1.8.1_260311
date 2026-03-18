chrom=$1

pigz -p 24 result_compress/pooled.HaplotypeCaller.${chrom}.all.vcf
