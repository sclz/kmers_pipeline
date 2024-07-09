process KMERSCOUNTQUERY {
  container 'quay.io/biocontainers/kmer-jellyfish:2.3.1--h4ac6f70_0'

  publishDir params.outdir, pattern: "*.fa",  mode: 'copy'

  input: 
  val klen
  tuple val(id), path(fastq) 
  path kmer_list

  
  output:
  tuple val(id), path("${id}.fa"), emit: kmers_fasta
  
 

  shell:
    '''
    jellyfish count -m !{klen} -s 100M --out-counter-len 1 -t 8 -C !{fastq} -o !{id}.jf
    jellyfish query !{id}.jf -s !{kmer_list} -o !{id}.fa
    '''

}