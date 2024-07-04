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