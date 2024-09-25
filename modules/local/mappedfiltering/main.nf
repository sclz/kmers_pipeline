process MAPPEDFILTERING {
    container 'quay.io/biocontainers/samtools:1.6--hc3601fc_10'

    memory '1 GB'

    publishDir params.outdir_lists,  mode: 'copy'

    input:
    tuple val(chrom), val(start), val(end), path("${chrom}_${start}-${end}_all_kmers_mapped.sam")

    output:
    tuple val(chrom), val(start), val(end), path("${chrom}_${start}-${end}_list.fa"), emit: kmers_list

    shell:
    '''
    region="!{chrom}:!{start}-!{end}"
    samtools view -bS "!{chrom}_!{start}-!{end}_all_kmers_mapped.sam" > "!{chrom}_!{start}-!{end}_all_kmers_mapped.bam"
    samtools sort -o "!{chrom}_!{start}-!{end}_all_kmers_mapped_sorted.bam" "!{chrom}_!{start}-!{end}_all_kmers_mapped.bam"
    samtools index "!{chrom}_!{start}-!{end}_all_kmers_mapped_sorted.bam"
    samtools view  "!{chrom}_!{start}-!{end}_all_kmers_mapped_sorted.bam" ${region} > "!{chrom}_!{start}-!{end}_all_kmers_mapped_filtered.sam"
    awk 'BEGIN { RS="\\n"; FS="\\t"; OFS="\\t"; ORS="\\n" } $1 ~ /^[0-9]/ { print ">kmer"NR"\\n"$10 }' "!{chrom}_!{start}-!{end}_all_kmers_mapped_filtered.sam" > "!{chrom}_!{start}-!{end}_list.fa"
    '''
}