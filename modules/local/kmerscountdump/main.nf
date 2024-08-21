process KMERSCOUNTDUMP {

    container 'quay.io/biocontainers/kmer-jellyfish:2.3.1--h4ac6f70_0'

    input: 
    val kmer
    tuple val(chrom), val(start), val(end), path("${chrom}_${start}-${end}.fa")
    
  
    output:
    tuple val(chrom), val(start), val(end), path("${chrom}_${start}-${end}_all_kmers.fa"), emit: kmers_fasta
  
 

    shell:

    '''
    jellyfish count -m !{kmer} -s 100M --out-counter-len 1 -t 8 "!{chrom}_!{start}-!{end}.fa" -o "!{chrom}_!{start}-!{end}_all_kmers.jf"
    jellyfish dump "!{chrom}_!{start}-!{end}_all_kmers.jf" > "!{chrom}_!{start}-!{end}_all_kmers.fa"
    '''

}