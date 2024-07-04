process MAPPEDFILTERING {
    container 'quay.io/biocontainers/samtools:1.6--hc3601fc_10'

    publishDir params.outdir,  mode: 'copy'

    input:
    path kmers_sam
    path bed

    output:
    path("lista_test.fa"), emit: kmers_list

    shell:
    '''
    read -r chrom start end < "!{bed}"
    region="${chrom}:${start}-${end}"
    samtools view -bS !{kmers_sam} > "all_kmers_mapped.bam"
    samtools sort -o "all_kmers_mapped_sorted.bam" "all_kmers_mapped.bam"
    samtools index "all_kmers_mapped_sorted.bam"
    samtools view  "all_kmers_mapped_sorted.bam" ${region} > "all_kmers_mapped_filtered.sam"
    awk 'BEGIN { RS="\\n"; FS="\\t"; OFS="\\t"; ORS="\\n" } $1 ~ /^[0-9]/ { print ">kmer"NR"\\n"$10 }' "all_kmers_mapped_filtered.sam" > "lista_test.fa"
    '''
}