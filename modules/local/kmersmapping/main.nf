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