process KMERSCOUNTQUERY {
  container 'quay.io/biocontainers/kmer-jellyfish:2.3.1--h4ac6f70_0'

  memory '2 GB'
  cpus 2
  //publishDir params.outdir, pattern: "*.fa",  mode: 'copy'

  input: 
  val klen
  tuple val(id), val(chrom), val(start), val(end), path("${id}_${chrom}_${start}-${end}.fastq")
  path kmer_list

  
  output:
  tuple val(id), val(chrom), val(start), val(end), path("${id}_${chrom}_${start}-${end}.fa"), emit: kmers_fasta
  
 

  shell:
    '''
    jellyfish count -m !{klen} -s 100M -t 8 -C !{id}_!{chrom}_!{start}-!{end}.fastq -o !{id}_!{chrom}_!{start}-!{end}.jf
    jellyfish query !{id}_!{chrom}_!{start}-!{end}.jf -s !{kmer_list}/!{chrom}_!{start}-!{end}_list.fa -o !{id}_!{chrom}_!{start}-!{end}.fa
    '''

}