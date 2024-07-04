params.reference = "$projectDir/hg38.fa"
params.bed = "$projectDir/coordinates/cordinate_prova.bed"
params.kmer = "25"
params.outdir = "$projectDir/kmers_lists"

process COORDINATEFILTER {

    container 'quay.io/biocontainers/samtools:1.6--hc3601fc_10'

    input: // input specificare i canali di iput
    path reference
    path bed

  
    output:
    path("region.fa"), emit: region_fasta

    shell:
    '''
    read -r chrom start end < "!{bed}"
    region="${chrom}:${start}-${end}"
    samtools faidx !{reference} ${region} > "region.fa"
    '''
}

process KMERSCOUNTDUMP {

    container 'quay.io/biocontainers/kmer-jellyfish:2.3.1--h4ac6f70_0'

    input: 
    val kmer
    path region_fasta 
  
    output:
    path("all_kmers.fa"), emit: kmers_fasta
  
 

    shell:

    '''
    jellyfish count -m !{kmer} -s 100M --out-counter-len 1 -t 8 !{region_fasta} -o "all_kmers.jf"
    jellyfish dump "all_kmers.jf" > "all_kmers.fa"
    '''

}

process KMERSMAPPING {
    container 'quay.io/biocontainers/bowtie:1.3.1--py310h7b97f60_6'

    input:
    path kmers_fasta
    path reference

    output:
    path("all_kmers_mapped.sam"), emit: kmers_sam
    shell:
    '''
    bowtie --no-unal --sam -v 0 -p 8 -m 1 -f -x "!{projectDir}/genome" !{kmers_fasta} > "all_kmers_mapped.sam"
    '''
}


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

workflow { 
    region_fasta_ch = COORDINATEFILTER(params.reference, params.bed)
    kmers_fasta_ch = KMERSCOUNTDUMP(params.kmer, region_fasta_ch)
    kmers_sam_ch = KMERSMAPPING(kmers_fasta_ch, params.reference)
    kmers_list_ch = MAPPEDFILTERING(kmers_sam_ch, params.bed)
}