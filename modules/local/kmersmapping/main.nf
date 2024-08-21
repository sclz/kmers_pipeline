process KMERSMAPPING {
    container 'quay.io/biocontainers/bowtie:1.3.1--py310h7b97f60_6'

    input:
    tuple val(chrom), val(start), val(end), path("${chrom}_${start}-${end}_all_kmers.fa")
    path reference

    output:
    tuple val(chrom), val(start), val(end), path("${chrom}_${start}-${end}_all_kmers_mapped.sam"), emit: kmers_sam
    
    shell:
    '''
    bowtie --no-unal --sam -v 0 -p 8 -m 1 -f -x "!{projectDir}/genome" "!{chrom}_!{start}-!{end}_all_kmers.fa" > "!{chrom}_!{start}-!{end}_all_kmers_mapped.sam"
    '''
}